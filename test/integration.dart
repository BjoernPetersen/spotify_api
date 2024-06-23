import 'package:dotenv/dotenv.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/spotify_api.dart';

@immutable
class ClientCredentials {
  final String clientId;
  final String clientSecret;

  ClientCredentials({
    required this.clientId,
    required this.clientSecret,
  });
}

DotEnv _loadEnv() {
  return DotEnv(includePlatformEnvironment: true)..load(['.env', '.env.test']);
}

ClientCredentials loadCredentials([DotEnv? env]) {
  env ??= _loadEnv();
  final clientId = env['CLIENT_ID'];
  final clientSecret = env['CLIENT_SECRET'];

  if (clientId == null || clientSecret == null) {
    throw StateError('Client ID or secret missing');
  }

  return ClientCredentials(
    clientId: clientId,
    clientSecret: clientSecret,
  );
}

Future<SpotifyWebApi> loadApi() async {
  final env = _loadEnv();
  final creds = loadCredentials(env);
  final refreshToken = env['REFRESH_TOKEN'];

  if (refreshToken == null) {
    throw StateError('Missing REFRESH_TOKEN');
  }

  final storage = MemoryRefreshTokenStorage(refreshToken);
  return SpotifyWebApi(
    refresher: AuthorizationCodeRefresher.withoutPkce(
      clientId: creds.clientId,
      clientSecret: creds.clientSecret,
      refreshTokenStorage: storage,
    ),
  );
}
