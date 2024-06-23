import 'package:spotify_api/src/auth/user_authorization.dart';

/// Simple implementation of [CodeVerifierStorage] that simply stores the code
/// verifiers in a map.
///
/// Note that this implementation never deletes a code verifier if it's not
/// retrieved using the [load] method.
final class MemoryCodeVerifierStorage implements CodeVerifierStorage {
  final Map<String, String> _data;

  MemoryCodeVerifierStorage() : _data = {};

  @override
  Future<String?> load({required String state}) {
    return Future.value(_data.remove(state));
  }

  @override
  Future<void> store({required String state, required String codeVerifier}) {
    _data[state] = codeVerifier;
    return Future.value();
  }
}
