# spotify_api Examples

Have a look at the [example directory][examples] for some examples on how to use the library.
To execute the examples, you should have a `.env` file containing a client ID and client secret from
Spotify:

```
file: .env
---

CLIENT_ID=abcdefg
CLIENT_SECRET=hijklmop
```

Examples that interact with user data (e.g. `get_user_playlists.dart`) require a refresh token, which can
be obtained by running `dart run tool/retrieve_refresh_token.dart` and following the instructions
to log in.

[examples]: https://github.com/BjoernPetersen/spotify_api/tree/main/example
