import 'dart:math';

import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/auth/response.dart';
import 'package:spotify_api/src/flows/authentication_flow.dart';
import 'package:spotify_api/src/flows/scopes.dart';
import 'package:spotify_api/src/flows/token.dart';
import 'package:spotify_api/src/requests.dart';

class AuthorizationCodeFlowState implements AuthenticationState {
  final Token _accessToken;
  final String refreshToken;

  AuthorizationCodeFlowState({
    required this.refreshToken,
    required Token accessToken,
  }) : _accessToken = accessToken;

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

const _kStateLength = 16;
const _kStateAlphabet =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

@immutable
class AuthorizationCodeFlow
    extends AuthenticationFlow<AuthorizationCodeFlowState> {
  final Random _random = Random.secure();
  final String _clientSecret;
  final List<Scope> _scopes;
  final Uri _redirectUri;
  final UserAuthorizationPrompt userAuthorizationPrompt;
  final AuthorizationCodeReceiver authorizationCodeReceiver;

  AuthorizationCodeFlow({
    required super.clientId,
    required String clientSecret,
    required Uri redirectUri,
    required this.userAuthorizationPrompt,
    required this.authorizationCodeReceiver,
    List<Scope> scopes = const [],
  })  : _clientSecret = clientSecret,
        _redirectUri = redirectUri,
        _scopes = scopes;

  String _generateState() {
    return List.generate(
      _kStateLength,
      (_) => _kStateAlphabet[_random.nextInt(_kStateAlphabet.length)],
    ).join();
  }

  Future<String> _authorize() async {
    final state = _generateState();
    final authorizeUrl = baseUrl.resolve("/authorize");
    final promptUrl = authorizeUrl.replace(
      queryParameters: {
        "client_id": clientId,
        "response_type": "code",
        "redirect_uri": _redirectUri.toString(),
        "state": state,
        "scope": _scopes.join(" "),
      },
    );
    final responseFuture = authorizationCodeReceiver.receiveCode(
      state,
      Duration(minutes: 1),
    );
    await userAuthorizationPrompt(promptUrl);
    // At this point we're waiting for the user to follow the prompt
    final response = await responseFuture;

    if (response.state != state) {
      throw RefreshException("Received response with invalid state");
    }

    if (response.error != null) {
      throw RefreshException(response.error);
    }

    return response.code!;
  }

  Future<AuthorizationCodeFlowState> _refreshToken(
    RequestsClient client,
    String refreshToken,
  ) async {
    final url = baseUrl.resolve('/api/token');
    final response = await client.post(
      url,
      headers: [
        Header.basicAuth(username: clientId, password: _clientSecret),
      ],
      body: RequestBody.formData({
        "grant_type": "refresh_token",
        "refresh_token": refreshToken,
      }),
    );

    if (!response.isSuccessful) {
      throw RefreshException("Could not refresh access token");
    }

    final token = response.body.decodeJson(TokenResponse.fromJson);
    final accessToken = Token(
      value: token.accessToken,
      expiration: DateTime.now().add(Duration(seconds: token.expiresIn)),
    );
    final newRefreshToken = token.refreshToken ?? refreshToken;

    return AuthorizationCodeFlowState(
      refreshToken: newRefreshToken,
      accessToken: accessToken,
    );
  }

  Future<AuthorizationCodeFlowState> _obtainInitialToken(
    RequestsClient client,
  ) async {
    final code = await _authorize();

    final url = baseUrl.resolve('/api/token');
    final response = await client.post(
      url,
      headers: [
        Header.basicAuth(username: clientId, password: _clientSecret),
      ],
      body: RequestBody.formData({
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": _redirectUri.toString(),
      }),
    );

    if (!response.isSuccessful) {
      throw RefreshException();
    }

    final token = response.body.decodeJson(TokenResponse.fromJson);
    final accessToken = Token(
      value: token.accessToken,
      expiration: DateTime.now().add(Duration(seconds: token.expiresIn)),
    );
    final refreshToken = token.refreshToken;

    if (refreshToken == null) {
      throw RefreshException("Did not receive a refresh token!");
    }

    return AuthorizationCodeFlowState(
      refreshToken: refreshToken,
      accessToken: accessToken,
    );
  }

  @override
  Future<AuthorizationCodeFlowState> retrieveToken(
    RequestsClient client,
    AuthorizationCodeFlowState? state,
  ) async {
    if (state == null) {
      return await _obtainInitialToken(client);
    } else {
      return await _refreshToken(client, state.refreshToken);
    }
  }
}
