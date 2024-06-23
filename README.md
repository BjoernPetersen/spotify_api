# spotify_api

[![Workflow](https://github.com/BjoernPetersen/spotify_api/actions/workflows/workflow.yaml/badge.svg)](https://github.com/BjoernPetersen/spotify_api/actions/workflows/workflow.yaml)
[![codecov](https://codecov.io/gh/BjoernPetersen/spotify_api/branch/main/graph/badge.svg?token=c7hHoMDzxM)](https://codecov.io/gh/BjoernPetersen/spotify_api)

A Spotify Web API wrapper written in Dart.

## Stability

This project is in an early stage. Most notably, not all endpoints are available yet, and some
response fields are not modeled. If you are missing something in particular, feel free to
[open a new issue on GitHub](https://github.com/BjoernPetersen/spotify_api/issues).

This project follows semantic versioning, so minor and patch version updates will not contain
breaking changes.

## Usage

The main entry point to the API is the `SpotifyWebApi` class. The Dart API is organized similarly to the
[Spotify Web API reference](https://developer.spotify.com/documentation/web-api/reference/), so most endpoints are
collected in groups, e.g. `tracks` or `albums`.

```dart
import 'package:spotify_api/spotify_api.dart';

Future<void> example(AccessTokenRefresher refresher) async {
    final api = SpotifyWebApi(
        refresher: refresher,
    );

    // Search for tracks, albums, etc.
    final searchResult = await api.search(
        query: 'Bohemian Rhapsody',
        types: [SearchType.track],
    );

    // Look up a specific track
    final track = await api.tracks.getTrack('3z8h0TU7ReDPLIbEnYhWZb');
}
```

The `AccessTokenRefresher` is expected as a given in this example. See [Authentication](#authentication) for more
information.

### Pagination

You'll often encounter responses that contain a page of some API resource, perhaps most prominently when you [search
for something](https://developer.spotify.com/documentation/web-api/reference/#/operations/search), or when you try to
[get the tracks in a playlist](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlists-tracks).

If you want to retrieve further pages, you can use a `Paginator`, which has several convenient methods to go through the
pages:

```dart
void example(SpotifyWebApi api, Page<Track> tracks) async {
    final paginator = api.paginator(tracks);

    // Go over the items on the current page
    for (final track in paginator.currentItems()) {
        print(track.name);
    }

    // Go over the items on the next page
    final nextPage = await paginator.nextPage();
    for (final track in nextPage.currentItems()) {
        print(track.name);
    }

    // Iterate over all tracks in all pages (including the current one)
    await paginator.all().forEach((track) {
        print(track.name);
    });
}
```

## Authentication

Before you can do anything in the API, you have to think about authentication. Spotify offers
[four different OAuth flows](https://developer.spotify.com/documentation/general/guides/authorization/).

| Name                         | Supported |
|------------------------------|:---------:|
| Authorization code           |     ✅     |
| Authorization code with PKCE |     ✅     |
| Client credentials           |     ✅     |
| Implicit grant               |     ⛔     |

Note that it's possible to implement an authentication flow yourself. The table above just shows the existing ones that
are ready-to-use.

You'll need to [register your app with Spotify](https://developer.spotify.com/dashboard) before you can use this
library. Spotify will give you a client ID and a client secret, the latter of which you may not need, depending on the
OAuth flow you want to use.

### Persistent State

The Authorization Code OAuth flows yield you a long-lived refresh token. That token should be persisted if you want to
be able to obtain new access tokens without user interaction. For that purpose, there's a simple
`RefreshTokenStorage` interface that you'll need to implement.

There is a `MemoryRefreshTokenStorage` implementation available, but that will not persist updated refresh
tokens beyond the object's lifetime, essentially discarding all refresh token updates.

### Client credentials flow

This is the simplest full OAuth flow, as it only requires you client ID and your client secret and works without user
interaction. It's not possible to access any user data using this flow.

Example:

```dart
final api = SpotifyWebApi(
    refresher: ClientCredentialsRefresher(
        clientId: 'myclientid',
        clientSecret: 'supersecret',
    ),
);
```

### Authorization code flow

The authorization code flow must be used if you want to access user data. The flow to initially
authorize your app and obtain a refresh token is interactive. Once you have a refresh token, it can
be used virtually forever (as long as the user does not revoke access).

You'll need to implement the relevant user interaction and production ready storage yourself, but
this package provides a generic framework to implement the OAuth flow with the
`AuthorizationCodeUserAuthorization` class:

```dart
final flow = AuthorizationCodeUserAuthorization(
    clientId: 'myclientid',
    clientSecret: 'supersecret',
    stateManager: TtlRandomStateManager(ttl: Duration(minutes: 5)),
    redirectUri: Uri.parse('https://example.com/spotifyauthcallback'),
);

// You'll need to direct the user to visit this URL somehow.
final authUrl = await auth.generateAuthorizationUrl(scopes: [Scopes.playlistReadPrivate]);
```

The `stateManager` is responsible for creating and verifying the state for each authorization flow
to prevent CSRF attacks. The TtlRandomStateManager used in the example will create random states,
store them in memory, and clean them up after the given TTL. That may be enough for some users, but
most production setups will require a more durable solution, so the flow object doesn't need to be
stored while waiting for the user.

The redirect URL should match what you've specified in your Spotify app settings in the developer
portal. Note that this package will not provide a server for you. You'll have to figure out yourself
how to receive the callback. Once you have the callback data (see the
`UserAuthorizationCallbackBody` model), you can continue with a flow object like created above:

```dart
// Let's assume we got the callback data and it's stored in this variable
final UserAuthorizationCallbackBody callback;

// The flow object is the same as above. If all is well, you now have a refresh token!
final refreshToken = flow.handleCallback(callback);
```

#### Using Refresh Tokens

You should store the refresh token somewhere safe. With it, you can initialize a `SpotifyWebApi`
instance with it. It will refresh access tokens as needed.

```dart
final api = SpotifyWebApi(
    refresher: AuthorizationCodeRefresher(
        clientId: 'myclientid',
        clientSecret: 'supersecret',
        refreshTokenStorage: MemoryRefreshTokenStorage(refreshToken),
    ),
);
```

Note that Spotify will occasionally respond with a new refresh token in addition to an access token.
The new refresh token will be stored using the `refreshTokenStorage` that was passed to the
`AuthorizationCodeRefresher`. For that reason, it's highly recommended to use a
`RefreshTokenStorage` implementation that will persist the new refresh tokens somewhere, other than
the `MemoryRefreshTokenStorage` used in the example above.

#### PKCE Extension

If you want to use the recommended authorization code flow with PKCE, you'll simply need to provide
a way to store the code verifier (a string) while the user is logging in. A simple implementation
is available as `MemoryCodeVerifierStorage`, but it's recommended to provide a more durable storage
(perhaps using a relational database).

```dart
final flow = AuthorizationCodeUserAuthorization(
    clientId: 'myclientid',
    clientSecret: 'supersecret',
    stateManager: TtlRandomStateManager(ttl: Duration(minutes: 5)),
    redirectUri: Uri.parse('https://example.com/spotifyauthcallback'),
    codeVerifierStorage: MemoryCodeVerifierStorage(),
);
```

