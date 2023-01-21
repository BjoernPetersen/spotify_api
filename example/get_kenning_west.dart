import 'package:spotify_api/api.dart';

import 'example_utils.dart';

Future<void> main() async {
  final creds = loadCreds();
  final client = SpotifyWebApi(
    authFlow: flowWithoutRefresh(creds),
    stateStorage: getStorage(),
  );

  try {
    final track = await client.tracks.getTrack('75n8FqbBeBLW2jUzvjdjXV');
    if (track == null) {
      print('Track not found');
    } else {
      print('Found track ${track.name} (popularity ${track.popularity})');
    }
  } finally {
    client.close();
  }
}
