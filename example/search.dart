import 'package:spotify_api/spotify_api.dart';

import 'example_utils.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    throw ArgumentError('No args given!');
  }
  final query = args.join(' ');

  final creds = loadCredentials();
  final client = SpotifyWebApi(
    refresher: ClientCredentialsRefresher(
      clientId: creds.clientId,
      clientSecret: creds.clientSecret,
    ),
  );

  try {
    final result = await client.search(
      query: query,
      types: [SearchType.track],
    );
    // We searched specifically for tracks, so this is null-safe.
    final tracks = result.tracks!.items;
    if (tracks.isEmpty) {
      print('Did not find any');
    } else {
      final best = tracks.first;
      print(
        "Best result: ${best.name} by ${best.artists.map((e) => e.name).join(', ')}",
      );
    }
  } finally {
    client.close();
  }
}
