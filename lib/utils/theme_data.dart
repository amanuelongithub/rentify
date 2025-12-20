import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rentify/utils/globals.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = ui.Color.fromARGB(255, 0, 160, 0);
  static const Color secondaryColor = ui.Color.fromARGB(255, 210, 230, 29); // icon color
  static const Color backgroundColor = ui.Color.fromARGB(255, 1, 44, 8);
  static const Color iconInActive = ui.Color.fromARGB(255, 205, 205, 205);
  static const Color textColor = ui.Color.fromARGB(255, 249, 249, 249);

  // Theme
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      onPrimary: iconInActive,
      secondary: secondaryColor,
      surface: backgroundColor,
      onSurface: textColor,
    ),
    iconTheme: IconThemeData(color: secondaryColor, size: 22),
    scaffoldBackgroundColor: const ui.Color.fromARGB(255, 0, 26, 4),
    highlightColor: Colors.transparent,
    focusColor: primaryColor,
  );

  // Cache and load image
  static Future<ui.Image> loadImage(String url) async {
    final cacheManager = DefaultCacheManager();
    final fileInfo = await cacheManager.getFileFromCache(url);
    Uint8List bytes;

    if (fileInfo != null) {
      bytes = await fileInfo.file.readAsBytes();
    } else {
      final response = await http.get(Uri.parse(url));
      bytes = response.bodyBytes;
      await cacheManager.putFile(url, bytes);
    }

    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  // Get average color from left/right sides
  static Future<Map<String, Color>> sideAverageColors(ui.Image image, {int sideWidth = 50}) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return {'left': Colors.black, 'right': Colors.black};

    final pixels = byteData.buffer.asUint8List();
    final width = image.width;
    final height = image.height;

    int leftR = 0, leftG = 0, leftB = 0, leftCount = 0;
    int rightR = 0, rightG = 0, rightB = 0, rightCount = 0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < sideWidth; x++) {
        final index = (y * width + x) * 4;
        leftR += pixels[index];
        leftG += pixels[index + 1];
        leftB += pixels[index + 2];
        leftCount++;
      }
      for (int x = width - sideWidth; x < width; x++) {
        final index = (y * width + x) * 4;
        rightR += pixels[index];
        rightG += pixels[index + 1];
        rightB += pixels[index + 2];
        rightCount++;
      }
    }

    final leftColor = Color.fromARGB(255, leftR ~/ leftCount, leftG ~/ leftCount, leftB ~/ leftCount);
    final rightColor = Color.fromARGB(255, rightR ~/ rightCount, rightG ~/ rightCount, rightB ~/ rightCount);

    return {'left': leftColor, 'right': rightColor};
  }
}
