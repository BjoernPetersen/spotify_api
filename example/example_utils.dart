import 'package:dotenv/dotenv.dart';
import 'package:file/file.dart';
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

class _FileRefreshTokenStorage implements RefreshTokenStorage {
  final File _file;

  _FileRefreshTokenStorage(this._file);

  @override
  Future<String> load() async {
    if (!await _file.exists()) {
      throw RefreshException('Refresh token storage file does not exist');
    }
    final content = _file.readAsStringSync();
    return content.trim();
  }

  @override
  Future<void> store(String refreshToken) async {
    _file.writeAsStringSync(
      refreshToken,
      mode: FileMode.writeOnly,
      flush: true,
    );
  }
}

RefreshTokenStorage fileRefreshTokenStorage() {
  return _FileRefreshTokenStorage(LocalFileSystem().file('refresh.txt'));
}

AccessTokenRefresher accessTokenRefresher(ClientCredentials creds) {
  return AuthorizationCodeRefresher(
    clientId: creds.clientId,
    clientSecret: creds.clientSecret,
    refreshTokenStorage: fileRefreshTokenStorage(),
  );
}
