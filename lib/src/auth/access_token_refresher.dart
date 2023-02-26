import 'dart:async';

import 'package:meta/meta.dart';
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
  final String _value;
  final DateTime expiration;

  TokenInfo({required String value, required this.expiration}) : _value = value;

  bool get isExpired => expiration.isBefore(DateTime.now());

  bool expiresWithin(Duration duration) =>
      expiration.isBefore(DateTime.now().add(duration));

  String get accessToken {
    if (isExpired) {
      throw ExpiredTokenException();
    }
    return _value;
  }
}

@immutable
abstract class AccessTokenRefresher {
  Future<TokenInfo> retrieveToken(RequestsClient client);
}
