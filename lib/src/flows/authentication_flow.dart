import 'dart:async';

import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/auth/response.dart';
import 'package:spotify_api/src/exceptions.dart';
import 'package:spotify_api/src/requests.dart';

class ExpiredTokenException extends SpotifyApiException {}

class RefreshException extends SpotifyApiException {
  RefreshException([super.message]);
}

abstract class UserAuthorizationPrompt {
  FutureOr<void> call(Uri uri);
}

abstract class AuthorizationCodeReceiver {
  Future<Future<AuthorizationCodeResponse?>> receiveCode(
    String state,
    Duration timeout,
  );
}

abstract class StateStorage {
  Future<void> store({required String key, required String? value});

  Future<String?> load(String key);
}

abstract class AuthenticationState {
  String get accessToken;

  bool get isExpired;

  bool get isRefreshable;

  Future<void> store(StateStorage stateStorage);
}

@immutable
abstract class AuthenticationFlow<S extends AuthenticationState> {
  final baseUrl = Uri.parse('https://accounts.spotify.com');

  final String clientId;

  AuthenticationFlow({
    required this.clientId,
  });

  Future<S?> restoreState(StateStorage stateStorage);

  Future<S> retrieveToken(RequestsClient client, S? state);
}
