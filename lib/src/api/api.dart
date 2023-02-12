import 'dart:async';

import 'package:meta/meta.dart';
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

  SpotifyPlaylistApi get playlists;

  SpotifyTrackApi get tracks;

  SpotifyUserApi get users;

  FutureOr<Paginator<T>> paginator<T>(PageRef<T> page);

  void close();
}

@immutable
abstract class SpotifyAlbumApi {
  Future<Album?> getAlbum(
    String albumId, {
    String? market,
  });

  Future<Page<Track>?> getAlbumTracks(
    String albumId, {
    String? market,
    int? limit,
    int? offset,
  });
}

@immutable
abstract class SpotifyPlaylistApi {
  Future<Playlist<Page<PlaylistTrack>>> createPlaylist({
    required String userId,
    required String name,
    PlaylistVisibility? visibility,
    String? description,
  });

  Future<Page<Playlist<PageRef<PlaylistTrack>>>> getCurrentUsersPlaylists();

  Future<Playlist<Page<PlaylistTrack>>?> getPlaylist(
    String id, {
    String? market,
  });
}

@immutable
abstract class SpotifyTrackApi {
  Future<Track?> getTrack(
    String trackId, {
    String? market,
  });

  Future<List<Track>> getTracks(
    List<String> trackIds, {
    String? market,
  });

  Future<Page<SavedTrack>> getSavedTracks({
    String? market,
    int? limit,
  });
}

@immutable
abstract class SpotifyUserApi {
  Future<User> getCurrentUsersProfile();
}

@immutable
abstract class Paginator<T> {
  Page<T> get page;

  List<T> get currentItems;

  Stream<T> all([int? pageSize]);

  Future<Paginator<T>?> nextPage([int? pageSize]);

  Future<Paginator<T>?> previousPage();
}
