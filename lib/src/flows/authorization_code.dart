import 'package:meta/meta.dart';
import 'package:spotify_api/api.dart';
import 'package:spotify_api/src/flows/token.dart';
import 'package:spotify_api/src/requests.dart';

@immutable
class AuthorizationCodeFlow
    extends AuthenticationFlow<TokenAuthenticationState> {
  final String _clientSecret;

  AuthorizationCodeFlow({
    required super.clientId,
    required String clientSecret,
  }) : _clientSecret = clientSecret;

  @override
  Future<TokenAuthenticationState> retrieveToken(
    RequestsClient client,
    TokenAuthenticationState? state,
  ) async {
    // TODO: implement retrieveToken
    throw UnimplementedError();
  }
}
