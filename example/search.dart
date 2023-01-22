import 'package:dotenv/dotenv.dart';
import 'package:spotify_api/api.dart';

import 'example_utils.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    throw ArgumentError('No args given!');
  }
  final query = args[0];

  final env = DotEnv(includePlatformEnvironment: true)..load();
  final clientId = env['CLIENT_ID'];
  final clientSecret = env['CLIENT_SECRET'];

  if (clientId == null || clientSecret == null) {
    throw StateError('Missing client ID or secret');
  }

  final creds = loadCreds();

  final client = SpotifyWebApi(
    authFlow: ClientCredentialsFlow(
      clientId: creds.clientId,
      clientSecret: creds.clientSecret,
    ),
  );
  try {
    final result = await client.search(
      query: query,
      types: [SearchType.track],
    );
    final tracks = result.tracks!.items;
    if (tracks.isEmpty) {
      print('Did not find any');
    } else {
      final best = tracks.first;
      print(
        "Best result: ${best.name} by ${best.artists.map((e) => e.name).join(',')}",
      );
    }
  } finally {
    client.close();
  }
}
