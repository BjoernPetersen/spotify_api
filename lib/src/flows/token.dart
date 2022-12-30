class Token {
  final String value;
  final DateTime expiration;

  Token({required this.value, required this.expiration});

  bool get isExpired => expiration.isBefore(DateTime.now());
}
