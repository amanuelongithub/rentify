import 'dart:io';

import 'package:flutter/services.dart';

class Haptic {
  static Future<void> tick() async {
    if (Platform.isIOS) {
      HapticFeedback.selectionClick();
    } else {
      try {
        const ch = MethodChannel('haptic');
        await ch.invokeMethod('tick');
      } catch (_) {}
    }
  }
}
