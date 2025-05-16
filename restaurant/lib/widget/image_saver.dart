import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageSaver {
  static const MethodChannel _channel = MethodChannel('image_saver');

  static Future<void> saveImage(Uint8List imageBytes, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(imageBytes);

    await _channel.invokeMethod('saveImage', {'filePath': file.path});
  }
}