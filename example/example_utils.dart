import 'package:dotenv/dotenv.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/spotify_api.dart';

@immutable
final class ClientCredentials {
  final String clientId;
  final String? clientSecret;

  ClientCredentials({required this.clientId, required this.clientSecret});
}

ClientCredentials loadCredentials() {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final clientId = env['CLIENT_ID'];
  final clientSecret = env['CLIENT_SECRET'];

  if (clientId == null) {
    throw StateError('Missing client ID');
  }

  return ClientCredentials(clientId: clientId, clientSecret: clientSecret);
}

class _FileRefreshTokenStorage implements RefreshTokenStorage {
  final File _file;

  _FileRefreshTokenStorage(this._file);

  @override
  Future<String> load() async {
    if (!await _file.exists()) {
      throw RefreshException(
          'Refresh token storage file does not exist. Try running "dart run tool/retrieve_refresh_token.dart"');
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
  final clientSecret = creds.clientSecret;
  if (clientSecret == null) {
    return AuthorizationCodeRefresher.withPkce(
      clientId: creds.clientId,
      refreshTokenStorage: fileRefreshTokenStorage(),
    );
  } else {
    return AuthorizationCodeRefresher.withoutPkce(
      clientId: creds.clientId,
      clientSecret: clientSecret,
      refreshTokenStorage: fileRefreshTokenStorage(),
    );
  }
}
