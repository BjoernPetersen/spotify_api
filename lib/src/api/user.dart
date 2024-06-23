import 'package:spotify_api/src/api/api.dart';
import 'package:spotify_api/src/api/core.dart';
import 'package:spotify_api/src/api_models/users/response.dart';

final class SpotifyUserApiImpl implements SpotifyUserApi {
  final CoreApi core;

  SpotifyUserApiImpl(this.core);

  @override
  Future<User> getCurrentUsersProfile() async {
    final url = core.resolveUri('/me');

    final response = await core.client.get(
      url,
      headers: await core.headers,
    );

    core.checkErrors(response);

    return response.body.decodeJson(User.fromJson);
  }
}
