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
    final tracks = await client.tracks.getTracks(
      ['75n8FqbBeBLW2jUzvjdjXV', '3SCVUhmOKIhWYDhWBU1yC2'],
    );

    print('Found tracks:');
    for (final track in tracks) {
      print(track.name);
    }
  } finally {
    client.close();
  }
}
