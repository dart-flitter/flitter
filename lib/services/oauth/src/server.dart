library oauth.server;

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

Future<String> getContent() async {
  String content = await rootBundle.loadString("assets/html/success.html");
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

Future<Stream<String>> server() async {
  final StreamController<String> onCode = new StreamController();
  HttpServer server =
      await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  server.listen((HttpRequest request) async {
    final String code = request.uri.queryParameters["code"];
    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", ContentType.HTML.mimeType)
      ..write(await getContent());
    await request.response.close();
    await server.close(force: true);
    onCode.add(code);
    await onCode.close();
  });
  return onCode.stream;
}
