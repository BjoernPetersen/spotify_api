import 'package:spotify_api/src/flows/authentication_flow.dart';

class Token {
  final String value;
  final DateTime expiration;

  Token({required this.value, required this.expiration});

  bool get isExpired => expiration.isBefore(DateTime.now());
}

class TokenAuthenticationState implements AuthenticationState {
  final Token _accessToken;

  TokenAuthenticationState(this._accessToken);

  @override
  String get accessToken {
    if (isExpired) {
      throw ExpiredTokenException();
    }
    return _accessToken.value;
  }

  @override
  bool get isExpired => _accessToken.isExpired;

  @override
  bool get isRefreshable => true;
}
