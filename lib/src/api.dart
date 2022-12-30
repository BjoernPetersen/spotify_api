import 'package:spotify_api/src/api_models/search/request.dart';
import 'package:spotify_api/src/api_models/search/response.dart';
import 'package:spotify_api/src/flows/authentication_flow.dart';
import 'package:spotify_api/src/requests.dart';

class SpotifyWebApi<S extends AuthenticationState> {
  static const String baseUrl = "https://api.spotify.com/v1";

  final RequestsClient _client;
  final AuthenticationFlow<S> _authFlow;
  final StateStorage? _stateStorage;
  S? _authState;

  SpotifyWebApi({
    required AuthenticationFlow<S> authFlow,
    StateStorage? stateStorage,
  })  : _client = RequestsClient(),
        _authFlow = authFlow,
        _stateStorage = stateStorage;

  Future<String> _getAccessToken() async {
    S? authState = _authState;
    final stateStorage = _stateStorage;

    if (authState == null && stateStorage != null) {
      authState = await _authFlow.restoreState(stateStorage);
    }

    if (authState == null) {
      authState = await _authFlow.retrieveToken(_client, null);
    } else if (authState.isExpired && authState.isRefreshable) {
      authState = await _authFlow.retrieveToken(_client, authState);
    } else if (authState.isExpired && !authState.isRefreshable) {
      throw ExpiredTokenException();
    }

    if (stateStorage != null) {
      authState.store(stateStorage);
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
