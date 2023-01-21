import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:spotify_api/api.dart';
import 'package:test/test.dart';
import 'package:file_testing/file_testing.dart';

void main() {
  group('file state storage', () {
    late File file;

    setUp(() async {
      final fileSystem = MemoryFileSystem();
      file = fileSystem.file('/test');
    });

    group('with non-existent file', () {
      late StateStorage storage;

      setUp(() {
        storage = FileStateStorage(file);
      });

      test('loads', () {
        expect(storage.load('key'), completion(isNull));
      });

      test('fails to store blank key', () {
        expect(storage.store(key: '', value: '42'), throwsArgumentError);
        expect(storage.store(key: ' ', value: '42'), throwsArgumentError);
        expect(storage.store(key: '\n', value: '42'), throwsArgumentError);
        expect(storage.store(key: ' \n', value: '42'), throwsArgumentError);
      });

      for (final value in ['42', null]) {
        test('stores $value', () async {
          await expectLater(
            storage.store(key: 'key', value: value),
            completes,
          );
          expect(file, isFile);
        });

        test('loads after store', () async {
          await storage.store(key: 'key', value: '42');
          expect(storage.load('key'), completion('42'));
        });
      }
    });

    group('with existent, valid file', () {
      late StateStorage storage;

      setUp(() {
        file.writeAsStringSync('{}');
        storage = FileStateStorage(file);
      });

      test('loads', () {
        expect(storage.load('key'), completion(isNull));
      });

      test('fails to store blank key', () {
        expect(storage.store(key: '', value: '42'), throwsArgumentError);
        expect(storage.store(key: ' ', value: '42'), throwsArgumentError);
        expect(storage.store(key: '\n', value: '42'), throwsArgumentError);
        expect(storage.store(key: ' \n', value: '42'), throwsArgumentError);
      });

      for (final value in ['42', null, 'value with\nline break']) {
        test('stores "$value"', () async {
          await expectLater(
            storage.store(key: 'key', value: value),
            completes,
          );
          expect(file, isFile);
        });

        test('loads after store', () async {
          await storage.store(key: 'key', value: '42');
          expect(storage.load('key'), completion('42'));
        });
      }
    });
  });
}
