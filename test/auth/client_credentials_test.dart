@Tags(['integration'])
library;

import 'package:spotify_api/spotify_api.dart';
import 'package:spotify_api/src/requests.dart';
import 'package:test/test.dart';

import '../integration.dart';

void main() {
  final creds = loadCredentials();
  final refresher = ClientCredentialsRefresher(
    clientId: creds.clientId,
    clientSecret: creds.clientSecret,
  );

  late final RequestsClient client;

  setUpAll(() {
    client = RequestsClient();
  });

  tearDownAll(() {
    client.close();
  });

  test('ClientCredentialsRefresher works', () async {
    final future = refresher.retrieveToken(client);
    await expectLater(future, completes);
    final token = await future;
    expect(token.isExpired, isFalse);
    expect(() => token.accessToken, returnsNormally);
  });
}
