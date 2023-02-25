import 'dart:async';

import 'package:meta/meta.dart';
import 'package:spotify_api/spotify_api.dart';
import 'package:spotify_api/src/api/core.dart';

abstract class SpotifyWebApi {
  factory SpotifyWebApi({
    required AccessTokenRefresher refresher,
  }) = CoreApi;

  /// Returns a Spotify access token that is valid for at least 10 minutes.
  Future<String> get rawAccessToken;

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
  /// Add one or more items to a user's playlist.
  ///
  /// Returns a snapshot ID for the playlist.
  Future<String> addItemsToPlaylist({
    required String playlistId,
    required List<String> uris,
    int? position,
  });

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

  Future<List<Image>> getPlaylistCoverImage(String playlistId);

  Future<Page<PlaylistTrack>> getPlaylistItems(
    String playlistId, {
    String? market,
    int? limit,
    int? offset,
  });

  /// Remove one or more items from a user's playlist.
  ///
  /// Returns a snapshot ID for the playlist.
  Future<String> removePlaylistItems({
    required String playlistId,
    required List<String> uris,
    required String snapshotId,
  });

  /// Reorder items in a playlist.
  ///
  /// [rangeStart] The position of the first item to be reordered.
  ///
  /// [insertBefore] The position where the items should be inserted.
  /// To reorder the items to the end of the playlist, simply set insert_before
  /// to the position after the last item.
  ///
  // Examples:
  ///- To reorder the first item to the last position in a playlist with 10
  ///  items, set range_start to 0, and insert_before to 10.
  ///- To reorder the last item in a playlist with 10 items to the start of the
  ///  playlist, set range_start to 9, and insert_before to 0.
  ///
  /// [rangeLength] The amount of items to be reordered. Defaults to 1 if not
  /// set. The range of items to be reordered begins from the
  /// range_start position, and includes the range_length subsequent items.
  ///
  /// Example:
  /// To move the items at index 9-10 to the start of the playlist, range_start
  /// is set to 9, and range_length is set to 2.
  Future<String> reorderPlaylistItems({
    required String playlistId,
    required String snapshotId,
    required int rangeStart,
    required int insertBefore,
    int rangeLength = 1,
  });

  /// Replace items in a playlist.
  ///
  /// Replacing items in a playlist will overwrite its existing items. This
  /// operation can be used for replacing or clearing items in a playlist.
  Future<String> replacePlaylistItems({
    required String playlistId,
    required List<String> uris,
  });
}

@immutable
abstract class SpotifyTrackApi {
  Future<List<bool>> checkUsersSavedTracks(List<String> ids);

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

  Future<void> removeUsersSavedTracks(List<String> ids);

  Future<void> saveTracksForCurrentUser(List<String> ids);
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
