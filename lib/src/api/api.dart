import 'package:spotify_api/api.dart';
import 'package:spotify_api/src/api/core.dart';

abstract class SpotifyWebApi<S extends AuthenticationState> {
  factory SpotifyWebApi({
    required AuthenticationFlow<S> authFlow,
    StateStorage? stateStorage,
  }) = CoreApi;

  Future<SearchResponse> search({
    required String query,
    required List<SearchType> types,
  });

  SpotifyAlbumApi get albums;

  SpotifyTrackApi get tracks;

  void close();
}

abstract class SpotifyAlbumApi {
  Future<Album?> getAlbum(
    String albumId, {
    String? market,
  });
}

abstract class SpotifyTrackApi {
  Future<Track?> getTrack(
    String trackId, {
    String? market,
  });
}
