import 'dart:async';

import 'package:flutter/services.dart';

class ZgAudioPlugin {
  static const MethodChannel _channel =
      const MethodChannel('zg_audio_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
