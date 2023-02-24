import 'dart:async';

import 'package:meta/meta.dart';
import 'package:spotify_api/src/auth/common.dart';
import 'package:spotify_api/src/exceptions.dart';
import 'package:spotify_api/src/requests.dart';

class ExpiredTokenException extends SpotifyApiException {}

class RefreshException extends SpotifyApiException {
  RefreshException([super.message]);
}

abstract class RefreshTokenStorage {
  Future<void> store(String refreshToken);
  Future<String> load();
}

@immutable
class TokenInfo {
  final Token _accessToken;

  TokenInfo(this._accessToken);

  String get accessToken {
    if (isExpired) {
      throw ExpiredTokenException();
    }
    return _accessToken.value;
  }

  bool get isExpired => _accessToken.isExpired;
}

@immutable
abstract class AccessTokenRefresher {
  final String clientId;

  AccessTokenRefresher({
    required this.clientId,
  });

  Future<TokenInfo> retrieveToken(RequestsClient client);
}
