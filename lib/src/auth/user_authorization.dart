import 'package:spotify_api/src/api_models/auth/request.dart';
import 'package:spotify_api/src/exceptions.dart';
import 'package:spotify_api/src/auth/scopes.dart';

class UserAuthorizationException extends SpotifyApiException {
  UserAuthorizationException([super.message]);
}

class StateMismatchException extends SpotifyApiException {}

/// Creates and validates OAuth states.
abstract class AuthorizationStateManager {
  /// Create a new state, potentially based on the given [userContext] (if any).
  Future<String> createState({required String? userContext});

  /// Validates that the given state was actually created by this manager.
  ///
  /// If a [userContext] was given during creation, the one given here should
  /// match the one the state was created with.
  Future<bool> validateState({
    required String state,
    required String? userContext,
  });
}

/// An OAuth flow that can be used to obtain a refresh token.
abstract class UserAuthorizationFlow {
  final String clientId;
  final Uri redirectUri;
  final AuthorizationStateManager stateManager;

  /// The [stateManager] will be used to generate and validate the OAuth state.
  UserAuthorizationFlow({
    required this.clientId,
    required this.redirectUri,
    required this.stateManager,
  });

  /// Generates a URL that the user should visit to authorize the app.
  Future<Uri> generateAuthorizationUrl({
    required List<Scope> scopes,
    String? userContext,
  });

  /// Handles the callback once the user has either agreed or declined the
  /// authorization. Returns a refresh token.
  ///
  /// Raises a [StateMismatchException] if the state is not valid.
  /// Raises a [UserAuthorizationException] if the user declined the
  /// authorization.
  Future<String> handleCallback({
    String? userContext,
    required UserAuthorizationCallbackBody callback,
  });
}
