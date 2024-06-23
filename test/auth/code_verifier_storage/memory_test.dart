import 'package:spotify_api/spotify_api.dart';
import 'package:spotify_api/src/auth/pkce.dart';
import 'package:test/test.dart';

void main() {
  late CodeVerifierStorage storage;

  setUp(() {
    storage = MemoryCodeVerifierStorage();
  });

  test('round trip works', () async {
    final value = generateCodeVerifier();
    final state = 'key';
    await storage.store(state: state, codeVerifier: value);
    await expectLater(storage.load(state: state), completion(value));
    expect(storage.load(state: state), completion(isNull),
        reason: 'Previous load should have removed value.');
  });

  test('load without store', () {
    expect(storage.load(state: 'abc'), completion(isNull));
  });
}
