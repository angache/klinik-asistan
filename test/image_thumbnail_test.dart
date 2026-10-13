import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:klinik_asistan/services/image_thumbnail.dart';
import 'package:klinik_asistan/services/storage_media.dart';

void main() {
  test('makeJpegThumbnail uzun kenarı küçültür, oranı korur', () async {
    final source = img.encodeJpg(img.Image(width: 1200, height: 900));
    final thumb = await makeJpegThumbnail(source, maxSide: 320);
    expect(thumb, isNotNull);
    final decoded = img.decodeJpg(thumb!)!;
    expect(decoded.width, 320);
    expect(decoded.height, 240);
    expect(thumb.length, lessThan(source.length));
  });

  test('makeJpegThumbnail geçersiz veride null döner', () async {
    expect(await makeJpegThumbnail(Uint8List.fromList([1, 2, 3])), isNull);
  });

  test('thumbnailPathFor', () {
    expect(
      StorageMedia.thumbnailPathFor('k/foto/h/abc.jpeg'),
      'k/foto/h/abc_kucuk.jpg',
    );
    expect(
      StorageMedia.thumbnailPathFor('k/foto/h/abc.PNG'),
      'k/foto/h/abc_kucuk.jpg',
    );
    expect(StorageMedia.thumbnailPathFor('k/foto/h/abc_kucuk.jpg'), isNull);
    expect(StorageMedia.thumbnailPathFor('k/ses/h/abc.m4a'), isNull);
  });
}
