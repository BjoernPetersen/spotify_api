import 'package:spotify_api/src/api_models/search/request.dart';
import 'package:spotify_api/src/api_models/search/response.dart';
import 'package:spotify_api/src/flows/authentication_flow.dart';
import 'package:spotify_api/src/requests.dart';

class SpotifyWebApi<S extends AuthenticationState> {
  static const String baseUrl = "https://api.spotify.com/v1";

  final RequestsClient _client;
  final AuthenticationFlow<S> _authFlow;
  S? _authState;

  SpotifyWebApi({
    required AuthenticationFlow<S> authFlow,
  })  : _client = RequestsClient(),
        _authFlow = authFlow;

  Future<String> _getAccessToken() async {
    S? authState = _authState;
    if (authState == null) {
      authState = await _authFlow.retrieveToken(_client, null);
    } else if (authState.isExpired && authState.isRefreshable) {
      authState = await _authFlow.retrieveToken(_client, authState);
    } else if (authState.isExpired && !authState.isRefreshable) {
      throw ExpiredTokenException();
    }
    return authState.accessToken;
  }

  Future<SearchResponse> search({
    required String query,
    required List<SearchType> types,
  }) async {
    final token = await _getAccessToken();
    final url = Uri.parse("$baseUrl/search");

    final response = await _client.get(
      url,
      headers: [Header.bearerAuth(token)],
      params: {
        "q": query,
        "type": types.map((it) => it.name).join(","),
      },
    );
    return response.body.decodeJson(SearchResponse.fromJson);
  }

  void close() {
    _client.close();
  }
}
