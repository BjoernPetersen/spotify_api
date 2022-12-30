class SpotifyApiException implements Exception {
  final String? message;

  SpotifyApiException([this.message]);

  @override
  String toString() {
    final message = this.message;
    if (message == null) {
      return runtimeType.toString();
    }

    return "$runtimeType: $message";
  }
}

class AuthenticationException extends SpotifyApiException {}

class AuthorizationException extends SpotifyApiException {}

class RateLimitException extends SpotifyApiException {}
