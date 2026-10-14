import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// permission_handler yalnızca Android ve iOS'ta çalışır; masaüstünde
/// mikrofon iznini işletim sistemi kayıt başlarken kendisi sorar.
bool get _isPhone => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

/// Masaüstünde kamera yok; fotoğraflar dosyadan seçilir.
bool get canTakePhoto => _isPhone;

Future<bool> requestMicrophone() async =>
    !_isPhone || (await Permission.microphone.request()).isGranted;

Future<bool> requestCamera() async =>
    !_isPhone || (await Permission.camera.request()).isGranted;
