@Tags(['leaky'])
import 'package:sane_uuid/uuid.dart';
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

  test('create playlist', () async {
    final user = await api.users.getCurrentUsersProfile();
    final name = 'test-${Uuid.v4()}';

    final playlist = await api.playlists.createPlaylist(
      userId: user.id,
      name: name,
    );

    expect(playlist, isNotNull);
    expect(playlist.name, name);
    expect(playlist.owner.id, user.id);
  });
}
