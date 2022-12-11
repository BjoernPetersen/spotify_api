import 'package:spotify_api/src/auth/response.dart';
import 'package:spotify_api/src/requests.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/search/request.dart';
import 'package:spotify_api/src/search/response.dart';

class Token {
  final String value;
  final DateTime expiration;

  Token({required this.value, required this.expiration});

  bool get isExpired => expiration.isBefore(DateTime.now());
}

class ExpiredTokenException implements Exception {}

class RefreshException implements Exception {}

abstract class AuthenticationState {
  String get accessToken;

  bool get isExpired;

  bool get isRefreshable;
}

@immutable
abstract class AuthenticationFlow<S extends AuthenticationState> {
  final baseUrl = Uri.parse('https://accounts.spotify.com');

  final String clientId;
  final String clientSecret;

  AuthenticationFlow({
    required this.clientId,
    required this.clientSecret,
  });

  Future<S> retrieveToken(S? state);
}

class ClientCredentialsFlowState implements AuthenticationState {
  final Token _accessToken;

  ClientCredentialsFlowState(this._accessToken);

  @override
  String get accessToken {
    if (isExpired) {
      throw ExpiredTokenException();
    }
    return _accessToken.value;
  }

  @override
  bool get isExpired => _accessToken.isExpired;

  @override
  bool get isRefreshable => true;
}

class ClientCredentialsFlow
    extends AuthenticationFlow<ClientCredentialsFlowState> {
  ClientCredentialsFlow({
    required String clientId,
    required String clientSecret,
  }) : super(
          clientId: clientId,
          clientSecret: clientSecret,
        );

  @override
  Future<ClientCredentialsFlowState> retrieveToken(
    ClientCredentialsFlowState? state,
  ) async {
    final client = RequestsClient();
    final Response response;
    try {
      final url = baseUrl.resolve("/api/token");
      final body = RequestBody.formData({
        "grant_type": "client_credentials",
      });
      response = await client.post(
        url,
        body: body,
        headers: [
          Header.basicAuth(username: clientId, password: clientSecret),
        ],
      );
    } finally {
      client.close();
    }

    if (!response.isSuccessful) {
      throw RefreshException();
    }

    final accessToken = response.body.decodeJson(AccessToken.fromJson);
    final token = Token(
      value: accessToken.accessToken,
      expiration: DateTime.now().add(Duration(seconds: accessToken.expiresIn)),
    );

    return ClientCredentialsFlowState(token);
  }
}

class SpotifyWebApi<S extends AuthenticationState> {
  static const String baseUrl = "https://api.spotify.com/v1";

  final RequestsClient _client;
  final AuthenticationFlow<S> _authFlow;
  S? _authState;

  SpotifyWebApi({
    required AuthenticationFlow<S> authFlow,
  })  : _client = RequestsClient(),
        _authFlow = authFlow;

  Future<String> _getAccessToken() async {
    S? authState = _authState;
    if (authState == null) {
      authState = await _authFlow.retrieveToken(null);
    } else if (authState.isExpired && authState.isRefreshable) {
      authState = await _authFlow.retrieveToken(authState);
    } else if (authState.isExpired && !authState.isRefreshable) {
      throw ExpiredTokenException();
    }
    return authState.accessToken;
  }

  Future<SearchResponse> search({
    required String query,
    required List<SearchType> types,
  }) async {
    final token = await _getAccessToken();
    final url = Uri.parse("$baseUrl/search");

    final response = await _client.get(
      url,
      headers: [Header.bearerAuth(token)],
      params: {
        "q": query,
        "type": types.map((it) => it.name).join(","),
      },
    );
    return response.body.decodeJson(SearchResponse.fromJson);
  }

  void close() {
    _client.close();
  }
}
