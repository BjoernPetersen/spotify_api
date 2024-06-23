import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/auth/response.dart';
import 'package:spotify_api/src/auth/access_token_refresher.dart';
import 'package:spotify_api/src/auth/common.dart';
import 'package:spotify_api/src/requests.dart';

@immutable
final class ClientCredentialsRefresher implements AccessTokenRefresher {
  final String _clientId;
  final String _clientSecret;

  ClientCredentialsRefresher({
    required String clientId,
    required String clientSecret,
  })  : _clientId = clientId,
        _clientSecret = clientSecret;

  @override
  Future<TokenInfo> retrieveToken(RequestsClient client) async {
    final url = baseAuthUrl.resolve('/api/token');
    final now = DateTime.now();
    final response = await client.post(
      url,
      body: RequestBody.formData({
        'grant_type': 'client_credentials',
      }),
      headers: [
        Header.basicAuth(
          username: _clientId,
          password: _clientSecret,
        ),
      ],
    );

    if (!response.isSuccessful) {
      throw RefreshException();
    }

    final accessToken = response.body.decodeJson(TokenResponse.fromJson);
    return TokenInfo(
      value: accessToken.accessToken,
      expiration: now.add(Duration(seconds: accessToken.expiresIn)),
    );
  }
}
