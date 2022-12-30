import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/auth/response.dart';
import 'package:spotify_api/src/flows/authentication_flow.dart';
import 'package:spotify_api/src/flows/token.dart';
import 'package:spotify_api/src/requests.dart';

class ClientCredentialsFlowStateState implements AuthenticationState {
  final Token _accessToken;

  ClientCredentialsFlowStateState(this._accessToken);

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

@immutable
class ClientCredentialsFlow
    extends AuthenticationFlow<ClientCredentialsFlowStateState> {
  final String _clientSecret;

  ClientCredentialsFlow({
    required super.clientId,
    required String clientSecret,
  }) : _clientSecret = clientSecret;

  @override
  Future<ClientCredentialsFlowStateState> retrieveToken(
    RequestsClient client,
    ClientCredentialsFlowStateState? state,
  ) async {
    final url = baseUrl.resolve("/api/token");
    final body = RequestBody.formData({
      "grant_type": "client_credentials",
    });
    final response = await client.post(
      url,
      body: body,
      headers: [
        Header.basicAuth(username: clientId, password: _clientSecret),
      ],
    );

    if (!response.isSuccessful) {
      throw RefreshException();
    }

    final accessToken = response.body.decodeJson(TokenResponse.fromJson);
    final token = Token(
      value: accessToken.accessToken,
      expiration: DateTime.now().add(Duration(seconds: accessToken.expiresIn)),
    );

    return ClientCredentialsFlowStateState(token);
  }
}
