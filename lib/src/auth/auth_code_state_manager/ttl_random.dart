import 'dart:async';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:spotify_api/src/auth/user_authorization.dart';

const _kStateLength = 16;
const _kStateAlphabet =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

@immutable
final class _Entry {
  final DateTime createdAt;
  final String? userContext;

  _Entry(this.userContext) : createdAt = DateTime.now();
}

final class TtlRandomStateManager implements AuthorizationStateManager {
  final Random _random;
  final Map<String, _Entry> _states;
  final Duration _ttl;

  TtlRandomStateManager({
    Duration ttl = const Duration(minutes: 5),
  })  : _random = Random.secure(),
        _states = {},
        _ttl = ttl;

  String _generateState() {
    return List.generate(
      _kStateLength,
      (_) => _kStateAlphabet[_random.nextInt(_kStateAlphabet.length)],
    ).join();
  }

  void _cleanUp() {
    final threshold = DateTime.now().subtract(_ttl);
    _states.removeWhere((key, value) => value.createdAt.isBefore(threshold));
  }

  @override
  Future<String> createState({String? userContext}) {
    _cleanUp();
    final state = _generateState();
    _states[state] = _Entry(userContext);
    return Future.value(state);
  }

  @override
  Future<bool> validateState({
    required String state,
    String? userContext,
  }) {
    _cleanUp();
    final entry = _states[state];
    if (entry != null) {
      return Future.value(userContext == entry.userContext);
    }

    return Future.value(false);
  }
}
