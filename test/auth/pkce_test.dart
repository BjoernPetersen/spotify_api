import 'package:spotify_api/src/auth/pkce.dart';
import 'package:test/test.dart';

void main() {
  group('PKCE helper', () {
    test(
      'verifier has custom length',
      () => expect(generateCodeVerifier(64), hasLength(64)),
    );
    test('verifier too short', () {
      expect(() => generateCodeVerifier(42), throwsArgumentError);
    });
    test('verifier too long', () {
      expect(() => generateCodeVerifier(129), throwsArgumentError);
    });
    test('challenge has no padding', () {
      final challenge = generateCodeChallenge(generateCodeVerifier(43));
      expect(challenge, isNot(contains('=')));
    });
    test('challenge is correct', () {
      final verifier = 'abcdefg';
      expect(
        generateCodeChallenge(verifier),
        'fRpUEnsiJQL1t5tfsIAwYRUqRPkrN-I8ZSe69mXU2po',
      );
    });
  });
}
