class SpotifyApiException implements Exception {
  final String? message;
  final int? statusCode;

  SpotifyApiException([this.message, this.statusCode]);

  @override
  String toString() {
    final message = this.message;
    final statusCode = this.statusCode;

    if (message == null && statusCode == null) {
      return runtimeType.toString();
    } else if (message == null && statusCode == null) {
      return '$runtimeType ($statusCode)';
    } else if (message != null && statusCode == null) {
      return '$runtimeType: $message';
    } else {
      return '$runtimeType ($statusCode): $message';
    }
  }
}

class AuthenticationException extends SpotifyApiException {}

class AuthorizationException extends SpotifyApiException {}

class RateLimitException extends SpotifyApiException {
  final DateTime? retryAfter;

  RateLimitException(this.retryAfter);
}

enum ResourceType {
  artist,
  market,
}

class NotFoundException extends SpotifyApiException {
  final ResourceType type;
  final String id;

  NotFoundException({
    required this.type,
    required this.id,
  }) : super('Could not find ${type.name} $id');
}
