import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image/image.dart' as img;

/// Liste küçük resimleri için uzun kenarı [maxSide] piksel olan JPEG üretir.
/// Çözülemeyen görsellerde null döner.
Future<Uint8List?> makeJpegThumbnail(
  Uint8List bytes, {
  int maxSide = 320,
  int quality = 75,
}) async {
  ui.Codec? codec;
  ui.Image? image;
  try {
    codec = await ui.instantiateImageCodecWithSize(
      await ui.ImmutableBuffer.fromUint8List(bytes),
      getTargetSize: (w, h) {
        final longest = w > h ? w : h;
        if (longest <= maxSide) return ui.TargetImageSize(width: w, height: h);
        final scale = maxSide / longest;
        return ui.TargetImageSize(
          width: (w * scale).round(),
          height: (h * scale).round(),
        );
      },
    );
    image = (await codec.getNextFrame()).image;
    final rgba = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (rgba == null) return null;
    final pixels = img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: rgba.buffer,
      numChannels: 4,
    );
    return img.encodeJpg(pixels, quality: quality);
  } catch (_) {
    return null;
  } finally {
    image?.dispose();
    codec?.dispose();
  }
}
