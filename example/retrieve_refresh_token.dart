import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:spotify_api/api.dart';
import 'package:spotify_api/src/requests.dart' as requests;

import 'example_utils.dart';

class CliUserAuthorizationPrompt implements UserAuthorizationPrompt {
  @override
  void call(Uri uri) {
    print('Please visit $uri to authorize the app');
  }
}

class AdHocServerAuthReceiver implements AuthorizationCodeReceiver {
  final int port;
  final String path;

  const AdHocServerAuthReceiver({
    required this.port,
    required this.path,
  });

  @override
  Future<Future<AuthorizationCodeResponse?>> receiveCode(
    String state,
    Duration timeout,
  ) async {
    final result = Completer<AuthorizationCodeResponse?>();

    Future<Response> handleRequest(Request request) async {
      if (request.url.path != path.substring(1)) {
        return Response.notFound('Not found');
      }

      final AuthorizationCodeResponse parsed;
      try {
        parsed = AuthorizationCodeResponse.fromJson(
          request.url.queryParameters,
        );
      } on Exception {
        return Response.badRequest();
      }

      if (parsed.state != state) {
        return Response.forbidden('Invalid state');
      }

      result.complete(parsed);

      return Response.ok('You can close this window now.');
    }

    final pipeline = Pipeline().addHandler(handleRequest);
    final server = await shelf_io.serve(
      pipeline,
      InternetAddress.loopbackIPv4,
      port,
    );
    result.future.timeout(timeout);
    result.future.whenComplete(() => server.close());
    return result.future;
  }
}

Future<void> main() async {
  final creds = loadCreds();

  final authFlow = AuthorizationCodeFlow(
    clientId: creds.clientId,
    clientSecret: creds.clientSecret,
    redirectUri: Uri.parse('http://localhost:8082/authcallback'),
    userAuthorizationPrompt: CliUserAuthorizationPrompt(),
    authorizationCodeReceiver: AdHocServerAuthReceiver(
      port: 8082,
      path: '/authcallback',
    ),
    scopes: [
      Scope.userLibraryRead,
    ],
  );

  final storage = getStorage();
  final client = requests.RequestsClient();
  try {
    final state = await authFlow.retrieveToken(client, null);
    await state.store(storage);
  } finally {
    client.close();
  }

  print("The app is now authorized");
}
