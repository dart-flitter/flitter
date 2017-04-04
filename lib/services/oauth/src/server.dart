library oauth.server;

import 'dart:async';
import 'dart:io';

Future<Stream<String>> server() async {
  final StreamController<String> onCode = new StreamController();
  HttpServer server =
      await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  server.listen((HttpRequest request) async {
    final String code = request.uri.queryParameters["code"];
    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", ContentType.HTML.mimeType)
      ..write("<html><h1>You can now close this window</h1></html>");
    await request.response.close();
    await server.close(force: true);
    onCode.add(code);
    await onCode.close();
  });
  return onCode.stream;
}
