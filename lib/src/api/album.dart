import 'package:meta/meta.dart';
import 'package:spotify_api/src/api/api.dart';
import 'package:spotify_api/src/api/core.dart';

@immutable
class SpotifyAlbumApiImpl implements SpotifyAlbumApi {
  final CoreApi coreApi;

  SpotifyAlbumApiImpl(this.coreApi);
}
