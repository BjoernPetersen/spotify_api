import 'dart:async';

import 'package:meta/meta.dart';
import 'package:spotify_api/src/exceptions.dart';
import 'package:spotify_api/src/requests.dart';

final class ExpiredTokenException extends SpotifyApiException {}

final class RefreshException extends SpotifyApiException {
  RefreshException([super.message]);
}

abstract interface class RefreshTokenStorage {
  Future<void> store(String refreshToken);

  Future<String> load();
}

@immutable
final class TokenInfo {
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
abstract interface class AccessTokenRefresher {
  Future<TokenInfo> retrieveToken(RequestsClient client);
}
