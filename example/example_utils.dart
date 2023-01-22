import 'dart:async';

import 'package:dotenv/dotenv.dart';
import 'package:file/local.dart';
import 'package:spotify_api/api.dart';

class ClientCredentials {
  final String clientId;
  final String clientSecret;

  ClientCredentials({required this.clientId, required this.clientSecret});
}

ClientCredentials loadCreds() {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final clientId = env['CLIENT_ID'];
  final clientSecret = env['CLIENT_SECRET'];

  if (clientId == null || clientSecret == null) {
    throw StateError('Missing client ID or secret');
  }

  return ClientCredentials(clientId: clientId, clientSecret: clientSecret);
}

StateStorage getStorage() {
  const fs = LocalFileSystem();
  return FileStateStorage(fs.file('state.json'));
}

AuthenticationFlow refreshOnlyFlow(ClientCredentials creds) {
  return RefreshOnlyAuthorizationCodeFlow(
    clientId: creds.clientId,
    clientSecret: creds.clientSecret,
  );
}
