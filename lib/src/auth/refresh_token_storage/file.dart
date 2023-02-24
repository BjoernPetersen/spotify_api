import 'package:file/file.dart';
import 'package:spotify_api/src/auth/access_token_refresher.dart';

class FileRefreshTokenStorage implements RefreshTokenStorage {
  final File _file;

  FileRefreshTokenStorage(this._file);

  static Future<FileRefreshTokenStorage> withInitialToken({
    required String refreshToken,
    required File file,
  }) async {
    final result = FileRefreshTokenStorage(file);
    await result.store(refreshToken);
    return result;
  }

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
