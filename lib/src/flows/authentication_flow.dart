import 'package:meta/meta.dart';

class ExpiredTokenException implements Exception {}

class RefreshException implements Exception {}

abstract class AuthenticationState {
  String get accessToken;

  bool get isExpired;

  bool get isRefreshable;
}

@immutable
abstract class AuthenticationFlow<S extends AuthenticationState> {
  final baseUrl = Uri.parse('https://accounts.spotify.com');

  final String clientId;
  final String clientSecret;

  AuthenticationFlow({
    required this.clientId,
    required this.clientSecret,
  });

  Future<S> retrieveToken(S? state);
}
