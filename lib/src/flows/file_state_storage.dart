import 'dart:convert';

import 'package:file/file.dart';
import 'package:spotify_api/src/flows/authentication_flow.dart';

/// A simple file-based state storage implementation.
///
/// This implementation is not very optimized and there is no guarantee that the
/// storage format remains the same in the future. It's recommended to choose a
/// more robust implementation based on your platform.
class FileStateStorage implements StateStorage {
  final File _file;

  /// Initializes an instance that will write to the specified file.
  /// The file needs to be readable and writable. The file itself doesn't need
  /// to exist, but the parent directory should already exist.
  FileStateStorage(this._file);

  Future<Map> _loadFile() async {
    if (!await _file.exists()) {
      return {};
    }
    final content = await _file.readAsString();
    final Map decoded = jsonDecode(content);
    return decoded;
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
    final data = await _loadFile();
    return data[key];
  }

  @override
  Future<void> store({required String key, required String? value}) async {
    _checkKey(key);
    final data = await _loadFile();

    if (value == null) {
      data.remove(key);
    } else {
      data[key] = value;
    }

    await _file.writeAsString(jsonEncode(data));
  }
}
