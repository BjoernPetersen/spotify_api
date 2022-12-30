import 'package:spotify_api/api.dart';

import 'example_utils.dart';

Future<void> main() async {
  final creds = loadCreds();
  final client = SpotifyWebApi(
    authFlow: flowWithoutRefresh(creds),
    stateStorage: getStorage(),
  );

  try {
    final tracks = await client.albums.getAlbumTracks('6Q1fxM7xBU5K2J1zo0usMz');
    if (tracks == null) {
      print('Album not found');
    } else {
      print('Found tracks:');
      for (final track in tracks.items) {
        print(track.name);
      }
    }
  } finally {
    client.close();
  }
}
