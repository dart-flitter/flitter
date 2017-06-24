library gitter.flutter.auth;

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:gitter/gitter.dart';
import 'package:gitter/src/oauth/oauth.dart';

Future<String> getContent() async {
  final content = await rootBundle.loadString("assets/html/success.html");
  if (content.isNotEmpty) {
    return content;
  }
  return """
    <html>
      <body>
        <h1>You can now close this page !</h1>
      </body>
    </html>
    """;
}

class FlutterGitterOAuth extends GitterOAuth {
  final StreamController<String> _onCode = new StreamController();

  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  var _isOpen = false;
  var _server;
  var _onCodeStream;

  Stream<String> get onCode =>
      _onCodeStream ??= _onCode.stream.asBroadcastStream();

  FlutterGitterOAuth(AppInformations appInformations, {bool force: false})
      : super(appInformations, force: force);

  Future<String> requestCode() async {
    if (shouldRequestCode() && !_isOpen) {
      // close any open browser (happen on hot reload)
      await flutterWebviewPlugin.close();
      _isOpen = true;

      // init server
      _server = await _createServer();
      _listenCode(_server);

      // construct url
      final String urlParams = constructUrlParams();

      // catch onDestroy event of WebView
      flutterWebviewPlugin.onDestroy.first.then((_) {
        _close();
      });

      // launch url inside webview
      flutterWebviewPlugin.launch("${codeInformations.url}?$urlParams",
          clearCookies: true, fullScreen: true);

      code = await onCode.first;
      _close();
    }
    return code;
  }

  void _close([_]) {
    if (_isOpen) {
      // close server
      _server.close(force: true);

      flutterWebviewPlugin.close();
    }
    _isOpen = false;
  }

  Future<HttpServer> _createServer() async {
    final server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080,
        shared: true);
    return server;
  }

  _listenCode(HttpServer server) {
    server.listen((HttpRequest request) async {
      final uri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.HTML.mimeType)
        ..write(await getContent());

      final code = uri.queryParameters["code"];
      final error = uri.queryParameters["error"];
      await request.response.close();
      if (code != null && error == null) {
        _onCode.add(code);
      } else if (error != null) {
        _onCode.add(null);
        _onCode.addError(error);
      }
    });
  }
}
