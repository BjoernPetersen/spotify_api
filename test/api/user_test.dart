@Tags(['integration'])
import 'package:spotify_api/api.dart';
import 'package:test/test.dart';

import '../integration.dart';

void main() {
  late SpotifyWebApi api;

  setUpAll(() async {
    api = await loadApi();
  });

  tearDownAll(() {
    api.close();
  });

  test('getCurrentUsersProfile', () async {
    final result = api.users.getCurrentUsersProfile();
    await expectLater(result, completes);
    final user = await result;
    expect(user.country, isNotNull);
    expect(user.displayName, isNotNull);
    expect(user.email, isNotNull);
    expect(user.explicitContent?.filterEnabled, isFalse);
    expect(user.explicitContent?.filterLocked, isFalse);
    expect(user.href, isNotNull);
    expect(user.id, isNotNull);
    expect(user.images, isNotNull);
    expect(user.product, 'premium');
    expect(user.uri, isNotNull);
  });
}
