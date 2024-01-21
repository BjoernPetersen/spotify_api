import 'package:spotify_api/src/api_models/albums/response.dart';
import 'package:test/test.dart';

void main() {
  group('AlbumType', () {
    group('can be deserialized', () {
      for (final (serialized, type) in [
        ('album', AlbumType.album),
        ('ALBUM', AlbumType.album),
        ('Album', AlbumType.album),
        ('compilation', AlbumType.compilation),
        ('COMPILATION', AlbumType.compilation),
        ('Compilation', AlbumType.compilation),
        ('single', AlbumType.single),
        ('SINGLE', AlbumType.single),
        ('Single', AlbumType.single),
      ]) {
        test(serialized, () {
          expect(AlbumType.fromJson(serialized), type);
        });
      }
    });

    group('fails deserialization', () {
      for (final serialized in [
        'unknown',
        'a single',
        'compilations',
      ]) {
        test(serialized, () {
          expect(() => AlbumType.fromJson(serialized), throwsArgumentError);
        });
      }
    });
  });
}
