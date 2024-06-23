import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

const kCodeVerifierAlphabet =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

final Random _random = Random.secure();

String generateCodeVerifier([int length = 128]) {
  if (length < 43 || length > 128) {
    throw ArgumentError.value(length, 'length', 'Must be in range 43-128');
  }
  return List.generate(
    length,
    (_) => kCodeVerifierAlphabet[_random.nextInt(kCodeVerifierAlphabet.length)],
  ).join();
}

String generateCodeChallenge(String verifier) {
  final digest = sha256.convert(ascii.encode(verifier));
  // Spotify does NOT want padding.
  return base64UrlEncode(digest.bytes).replaceAll('=', '');
}
