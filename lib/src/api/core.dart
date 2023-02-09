import 'dart:async';

import 'package:spotify_api/src/api/album.dart';
import 'package:spotify_api/src/api/api.dart';
import 'package:spotify_api/src/api/paginator.dart';
import 'package:spotify_api/src/api/playlist.dart';
import 'package:spotify_api/src/api/track.dart';
import 'package:spotify_api/src/api_models/error/response.dart';
import 'package:spotify_api/src/api_models/page.dart';
import 'package:spotify_api/src/api_models/search/request.dart';
import 'package:spotify_api/src/api_models/search/response.dart';
import 'package:spotify_api/src/exceptions.dart';
import 'package:spotify_api/src/flows/authentication_flow.dart';
import 'package:spotify_api/src/requests.dart';

class CoreApi<S extends AuthenticationState> implements SpotifyWebApi<S> {
  static const String baseUrl = 'https://api.spotify.com/v1';

  final RequestsClient client;
  final AuthenticationFlow<S> _authFlow;
  final StateStorage? _stateStorage;
  S? _authState;

  CoreApi({
    required AuthenticationFlow<S> authFlow,
    StateStorage? stateStorage,
  })  : client = RequestsClient(),
        _authFlow = authFlow,
        _stateStorage = stateStorage;

  Uri resolveUri(String path) {
    return Uri.parse('$baseUrl$path');
  }

  Future<String> getAccessToken() async {
    S? authState = _authState;
    final stateStorage = _stateStorage;

    if (authState == null && stateStorage != null) {
      authState = await _authFlow.restoreState(stateStorage);
    }

    if (authState == null) {
      authState = await _authFlow.retrieveToken(client, null);
    } else if (authState.isExpired && authState.isRefreshable) {
      authState = await _authFlow.retrieveToken(client, authState);
    } else if (authState.isExpired && !authState.isRefreshable) {
      throw ExpiredTokenException();
    }

    if (stateStorage != null) {
      authState.store(stateStorage);
    }

    return authState.accessToken;
  }

  Future<List<Header>> get headers async {
    final token = await getAccessToken();
    return [Header.bearerAuth(token)];
  }

  void checkErrors(Response response) {
    if (!response.isSuccessful) {
      final body = response.body.decodeJson(ErrorResponse.fromJson);
      switch (response.statusCode) {
        case 401:
          throw AuthenticationException();
        case 403:
          throw AuthorizationException();
        case 429:
          throw RateLimitException();
        default:
          throw SpotifyApiException(body.error.message);
      }
    }
  }

  @override
  Future<SearchResponse> search({
    required String query,
    required List<SearchType> types,
  }) async {
    // TODO: move to subsection
    final url = Uri.parse('$baseUrl/search');

    final response = await client.get(
      url,
      headers: await headers,
      params: {
        'q': query,
        'type': types.map((it) => it.name).join(','),
      },
    );

    checkErrors(response);

    return response.body.decodeJson(SearchResponse.fromJson);
  }

  @override
  SpotifyAlbumApi get albums => SpotifyAlbumApiImpl(this);

  @override
  SpotifyPlaylistApi get playlists => SpotifyPlaylistApiImpl(this);

  @override
  SpotifyTrackApi get tracks => SpotifyTrackApiImpl(this);

  @override
  FutureOr<Paginator<T>> paginator<T>(PageRef<T> page) =>
      PaginatorImpl.fromPage(this, page);

  @override
  void close() {
    client.close();
  }
}
