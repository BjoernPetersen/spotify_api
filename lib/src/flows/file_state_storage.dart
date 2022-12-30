import 'dart:convert';
import 'dart:io';

import 'package:spotify_api/src/flows/authentication_flow.dart';

class FileStateStorage implements StateStorage {
  final File _file;

  FileStateStorage(this._file);

  Future<Map> _loadFile() async {
    if (!await _file.exists()) {
      return {};
    }
    final content = await _file.readAsString();
    final Map decoded = jsonDecode(content);
    return decoded;
  }

  @override
  Future<String?> load(String key) async {
    final data = await _loadFile();
    return data[key];
  }

  @override
  Future<void> store({required String key, required String? value}) async {
    final data = await _loadFile();
    if (value == null) {
      data.remove(key);
    } else {
      data[key] = value;
    }
    await _file.writeAsString(jsonEncode(data));
  }
}
