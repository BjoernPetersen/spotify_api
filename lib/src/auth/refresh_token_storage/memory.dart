import 'package:spotify_api/src/auth/access_token_refresher.dart';

class MemoryRefreshTokenStorage implements RefreshTokenStorage {
  String _refreshToken;

  MemoryRefreshTokenStorage(String refreshToken) : _refreshToken = refreshToken;

  @override
  Future<String> load() {
    return Future.value(_refreshToken);
  }

  @override
  Future<void> store(String refreshToken) {
    _refreshToken = refreshToken;
    return Future.value();
  }
}
