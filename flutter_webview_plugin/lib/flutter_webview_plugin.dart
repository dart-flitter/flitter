import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWebViewPlugin {
  static const PlatformMethodChannel _channel =
      const PlatformMethodChannel('flutter_webview_plugin');

  /// Provides an instance of this class.
  factory FlutterWebViewPlugin() => const FlutterWebViewPlugin._();

  /// We don't want people to extend this class, but implementing its interface,
  /// e.g. in tests, is OK.
  const FlutterWebViewPlugin._();

  Future<Null> open(String url) async {
    await _channel.invokeMethod('open', <String, dynamic>{
      'url': url,
    });
  }
}
