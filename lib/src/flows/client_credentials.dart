import 'package:spotify_api/src/api_models/auth/response.dart';
import 'package:spotify_api/src/flows/authentication_flow.dart';
import 'package:spotify_api/src/flows/token.dart';
import 'package:spotify_api/src/requests.dart';

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
    RequestsClient client,
    ClientCredentialsFlowState? state,
  ) async {
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
