import 'dart:async';

import 'package:spotify_api/src/api/album.dart';
import 'package:spotify_api/src/api/api.dart';
import 'package:spotify_api/src/api/paginator.dart';
import 'package:spotify_api/src/api/playlist.dart';
import 'package:spotify_api/src/api/track.dart';
import 'package:spotify_api/src/api/user.dart';
import 'package:spotify_api/src/api_models/error/response.dart';
import 'package:spotify_api/src/api_models/page.dart';
import 'package:spotify_api/src/api_models/search/request.dart';
import 'package:spotify_api/src/api_models/search/response.dart';
import 'package:spotify_api/src/auth/access_token_refresher.dart';
import 'package:spotify_api/src/exceptions.dart';
import 'package:spotify_api/src/requests.dart';

class CoreApi implements SpotifyWebApi {
  static const String baseUrl = 'https://api.spotify.com/v1';

  final RequestsClient client;
  final AccessTokenRefresher _accessTokenRefresher;
  TokenInfo? _authState;

  CoreApi({
    required AccessTokenRefresher refresher,
  })  : client = RequestsClient(),
        _accessTokenRefresher = refresher;

  Uri resolveUri(String path) {
    return Uri.parse('$baseUrl$path');
  }

  @override
  Future<String> get rawAccessToken {
    return _getAccessToken(minLifetime: const Duration(minutes: 10));
  }

  Future<String> get accessToken {
    return _getAccessToken(minLifetime: const Duration(minutes: 1));
  }

  Future<String> _getAccessToken({required Duration minLifetime}) async {
    var authState = _authState;

    if (authState == null || authState.expiresWithin(minLifetime)) {
      authState = await _accessTokenRefresher.retrieveToken(client);
    }

    _authState = authState;

    return authState.accessToken;
  }

  Future<List<Header>> get headers async {
    final token = await accessToken;
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
  SpotifyUserApi get users => SpotifyUserApiImpl(this);

  @override
  FutureOr<Paginator<T>> paginator<T>(PageRef<T> page) =>
      PaginatorImpl.fromPage(this, page);

  @override
  void close() {
    client.close();
  }
}
