import 'package:dotenv/dotenv.dart';
import 'package:spotify_api/api.dart';

class _MemoryStateStorage extends StateStorage {
  final Map<String, String> _values = {};

  _MemoryStateStorage([Map<String, String>? initialValues]) {
    if (initialValues != null) {
      _values.addAll(initialValues);
    }
  }

  static void _checkKey(String key) {
    final trimmed = key.trim();
    if (trimmed.length != key.length) {
      throw ArgumentError.value(
        key,
        'key',
        'key may not contain trailing or leading whitespace',
      );
    }

    if (trimmed.isEmpty) {
      throw ArgumentError.value(key, 'key', 'key may not be blank');
    }
  }

  @override
  Future<String?> load(String key) async {
    _checkKey(key);
    return _values[key];
  }

  @override
  Future<void> store({
    required String key,
    required String? value,
  }) async {
    _checkKey(key);
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }
}

Future<SpotifyWebApi> loadApi() async {
  final env = DotEnv(includePlatformEnvironment: true)
    ..load(['.env', '.env.test']);

  final clientId = env['CLIENT_ID'];
  final clientSecret = env['CLIENT_SECRET'];
  final refreshToken = env['REFRESH_TOKEN'];

  if (clientId == null || clientSecret == null || refreshToken == null) {
    throw StateError('Not all required variables set');
  }

  final state = _MemoryStateStorage({'refresh': refreshToken});
  return SpotifyWebApi(
    authFlow: RefreshOnlyAuthorizationCodeFlow(
      clientId: clientId,
      clientSecret: clientSecret,
    ),
    stateStorage: state,
  );
}
