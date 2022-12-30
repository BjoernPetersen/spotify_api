import 'dart:async';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:spotify_api/api.dart';

class ClientCredentials {
  final String clientId;
  final String clientSecret;

  ClientCredentials({required this.clientId, required this.clientSecret});
}

ClientCredentials loadCreds() {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final clientId = env["CLIENT_ID"];
  final clientSecret = env["CLIENT_SECRET"];

  if (clientId == null || clientSecret == null) {
    throw StateError("Missing client ID or secret");
  }

  return ClientCredentials(clientId: clientId, clientSecret: clientSecret);
}

StateStorage getStorage() => FileStateStorage(File('state.json'));

class _StubUserPrompt implements UserAuthorizationPrompt {
  @override
  void call(Uri uri) {}
}

class _StubAuthReceiver implements AuthorizationCodeReceiver {
  @override
  Future<Future<AuthorizationCodeResponse?>> receiveCode(
    String state,
    Duration timeout,
  ) async {
    throw UnimplementedError();
  }
}

AuthenticationFlow flowWithoutRefresh(ClientCredentials creds) {
  return AuthorizationCodeFlow(
    clientId: creds.clientId,
    clientSecret: creds.clientSecret,
    redirectUri: Uri.parse('http://localhost'),
    userAuthorizationPrompt: _StubUserPrompt(),
    authorizationCodeReceiver: _StubAuthReceiver(),
  );
}
