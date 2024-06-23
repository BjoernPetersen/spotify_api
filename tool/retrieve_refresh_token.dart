import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:spotify_api/spotify_api.dart';

import '../example/example_utils.dart';

class AdHocServerAuthReceiver {
  final int port;
  final String path;

  const AdHocServerAuthReceiver({
    required this.port,
    required this.path,
  });

  Stream<UserAuthorizationCallbackBody> listen(Future<void> cancel) async* {
    final controller = StreamController<UserAuthorizationCallbackBody>();
    HttpServer? server;
    cancel.whenComplete(() async {
      final saveServer = server;
      if (saveServer != null) {
        await saveServer.close(force: true);
      }
      await controller.close();
    });

    Future<Response> handleRequest(Request request) async {
      if (request.url.path != path.substring(1)) {
        return Response.notFound('Not found');
      }

      final UserAuthorizationCallbackBody parsed;
      try {
        parsed = UserAuthorizationCallbackBody.fromJson(
          request.url.queryParameters,
        );
      } on Exception {
        return Response.badRequest();
      }

      controller.add(parsed);

      return Response.ok('You can close this window now.');
    }

    server = await shelf_io.serve(
      handleRequest,
      InternetAddress.loopbackIPv4,
      port,
    );

    yield* controller.stream;
  }
}

void promptUser(Uri url) {
  print('Please visit $url to authorize the app');
}

Future<void> main() async {
  // TODO: accept args for URI
  final creds = loadCredentials();

  const timeout = Duration(minutes: 5);

  final auth = AuthorizationCodeUserAuthorization(
    clientId: creds.clientId,
    clientSecret: creds.clientSecret,
    redirectUri: Uri.parse('http://localhost:8082/authcallback'),
    stateManager: TtlRandomStateManager(ttl: timeout),
  );

  final authUrl = await auth.generateAuthorizationUrl(scopes: Scope.values);
  promptUser(authUrl);

  final receiver = AdHocServerAuthReceiver(port: 8082, path: '/authcallback');
  final cancel = Completer<void>();
  final callbacks = receiver.listen(
    cancel.future.timeout(timeout),
  );

  String? refreshToken;
  try {
    await for (final callback in callbacks) {
      try {
        refreshToken = await auth.handleCallback(
          callback: callback,
        );
        break;
      } on UserAuthorizationException catch (e) {
        print('Could not process callback: $e');
      } on StateMismatchException {
        print('Ignoring callback with mismatched state');
      }
    }
  } finally {
    cancel.complete();
  }

  if (refreshToken == null) {
    print('No refresh token obtained');
  } else {
    final storage = fileRefreshTokenStorage();
    await storage.store(refreshToken);
    print('The app is now authorized');
  }
}
