import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/auth/response.dart';
import 'package:spotify_api/src/flows/authentication_flow.dart';
import 'package:spotify_api/src/flows/token.dart';
import 'package:spotify_api/src/requests.dart';

@immutable
class ClientCredentialsFlow
    extends AuthenticationFlow<TokenAuthenticationState> {
  final String _clientSecret;

  ClientCredentialsFlow({
    required super.clientId,
    required String clientSecret,
  }) : _clientSecret = clientSecret;

  @override
  Future<TokenAuthenticationState> retrieveToken(
    RequestsClient client,
    TokenAuthenticationState? state,
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
          Header.basicAuth(username: clientId, password: _clientSecret),
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

    return TokenAuthenticationState(token);
  }
}
