import 'package:dotenv/dotenv.dart';
import 'package:file/local.dart';
import 'package:spotify_api/spotify_api.dart';

class ClientCredentials {
  final String clientId;
  final String clientSecret;

  ClientCredentials({required this.clientId, required this.clientSecret});
}

ClientCredentials loadCreds() {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final clientId = env['CLIENT_ID'];
  final clientSecret = env['CLIENT_SECRET'];

  if (clientId == null || clientSecret == null) {
    throw StateError('Missing client ID or secret');
  }

  return ClientCredentials(clientId: clientId, clientSecret: clientSecret);
}

RefreshTokenStorage fileRefreshTokenStorage() {
  return FileRefreshTokenStorage(LocalFileSystem().file('refresh.txt'));
}

AccessTokenRefresher accessTokenRefresher(ClientCredentials creds) {
  return AuthorizationCodeRefresher(
    clientId: creds.clientId,
    clientSecret: creds.clientSecret,
    refreshTokenStorage: fileRefreshTokenStorage(),
  );
}
