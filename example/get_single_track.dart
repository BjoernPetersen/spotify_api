import 'package:spotify_api/spotify_api.dart';

import 'example_utils.dart';

Future<void> main() async {
  final creds = loadCredentials();
  final client = SpotifyWebApi(
    refresher: ClientCredentialsRefresher(
      clientId: creds.clientId,
      clientSecret: creds.clientSecret,
    ),
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
