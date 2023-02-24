enum Scope {
  /// ## Description
  ///
  /// Write access to user-provided images.
  ///
  /// ## Visible to Users
  ///
  /// Upload images to Spotify on your behalf.
  ///
  ugcImageUpload('ugc-image-upload'),

  /// ## Description
  ///
  /// Read access to a user’s player state.
  ///
  /// ## Visible to Users
  ///
  /// Read your currently playing content and Spotify Connect devices
  /// information.
  ///
  userReadPlaybackState('user-read-playback-state'),

  /// ## Description
  ///
  /// Write access to a user’s playback state
  ///
  /// ## Visible to Users
  ///
  /// Control playback on your Spotify clients and Spotify Connect devices.
  ///
  userModifyPlaybackState('user-modify-playback-state'),

  /// ## Description
  ///
  /// Read access to a user’s currently playing content.
  ///
  /// ## Visible to Users
  ///
  /// Read your currently playing content.
  ///
  userReadCurrentlyPlaying('user-read-currently-playing'),

  /// ## Description
  ///
  /// Remote control playback of Spotify. This scope is currently available to
  /// Spotify iOS and Android SDKs.
  ///
  /// ## Visible to Users
  ///
  /// Communicate with the Spotify app on your device.
  ///
  appRemoteControl('app-remote-control'),

  /// ## Description
  ///
  /// Control playback of a Spotify track. This scope is currently available to
  /// the Web Playback SDK. The user must have a Spotify Premium account.
  ///
  /// ## Visible to Users
  ///
  /// Play content and control playback on your other devices.
  ///
  streaming('streaming'),

  /// ## Description
  ///
  /// Read access to user's private playlists.
  ///
  /// ## Visible to Users
  ///
  /// Access your private playlists.
  ///
  playlistReadPrivate('playlist-read-private'),

  /// ## Description
  ///
  /// Include collaborative playlists when requesting a user's playlists.
  ///
  /// ## Visible to Users
  ///
  /// Access your collaborative playlists.
  ///
  playlistReadCollaborative('playlist-read-collaborative'),

  /// ## Description
  ///
  /// Write access to a user's private playlists.
  ///
  /// ## Visible to Users
  ///
  /// Manage your private playlists.
  ///
  playlistModifyPrivate('playlist-modify-private'),

  /// ## Description
  ///
  /// Write access to a user's public playlists.
  ///
  /// ## Visible to Users
  ///
  /// Manage your public playlists.
  ///
  playlistModifyPublic('playlist-modify-public'),

  /// ## Description
  ///
  /// Write/delete access to the list of artists and other users that the user
  /// follows.
  ///
  /// ## Visible to Users
  ///
  /// Manage who you are following.
  ///
  userFollowModify('user-follow-modify'),

  /// ## Description
  ///
  /// Read access to the list of artists and other users that the user follows.
  ///
  /// ## Visible to Users
  ///
  /// Access your followers and who you are following.
  ///
  userFollowRead('user-follow-read'),

  /// ## Description
  ///
  /// Read access to a user’s playback position in a content.
  ///
  /// ## Visible to Users
  ///
  /// Read your position in content you have played.
  ///
  userReadPlaybackPosition('user-read-playback-position'),

  /// ## Description
  ///
  /// Read access to a user's top artists and tracks.
  ///
  /// ## Visible to Users
  ///
  /// Read your top artists and content.
  ///
  userTopRead('user-top-read'),

  /// ## Description
  ///
  /// Read access to a user’s recently played tracks.
  ///
  /// ## Visible to Users
  ///
  /// Access your recently played items.
  ///
  userReadRecentlyPlayed('user-read-recently-played'),

  /// ## Description
  ///
  /// Write/delete access to a user's "Your Music" library.
  ///
  /// ## Visible to Users
  ///
  /// Manage your saved content.
  ///
  userLibraryModify('user-library-modify'),

  /// ## Description
  ///
  /// Read access to a user's library.
  ///
  /// ## Visible to Users
  ///
  /// Access your saved content.
  ///
  userLibraryRead('user-library-read'),

  /// ## Description
  ///
  /// Read access to user’s email address.
  ///
  /// ## Visible to Users
  ///
  /// Get your real email address.
  ///
  userReadEmail('user-read-email'),

  /// ## Description
  ///
  /// Read access to user’s subscription details (type of user account).
  ///
  /// ## Visible to Users
  ///
  /// Access your subscription details.
  ///
  userReadPrivate('user-read-private'),
  ;

  final String code;

  const Scope(this.code);
}
