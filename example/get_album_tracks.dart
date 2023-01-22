import 'package:spotify_api/api.dart';

import 'example_utils.dart';

Future<void> main() async {
  final creds = loadCreds();
  final client = SpotifyWebApi(
    authFlow: refreshOnlyFlow(creds),
    stateStorage: getStorage(),
  );

  try {
    final tracks = await client.albums.getAlbumTracks('6Q1fxM7xBU5K2J1zo0usMz');
    if (tracks == null) {
      print('Album not found');
    } else {
      print('Found tracks:');
      final paginator = client.paginator(tracks);
      await paginator.all().forEach((track) {
        print(track.name);
      });
    }
  } finally {
    client.close();
  }
}
