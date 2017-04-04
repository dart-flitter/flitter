library gitter.get_token;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flitter/services/gitter/src/token.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

//  TODO(kleak): extract this to a oauth services
Future<Stream<String>> _server() async {
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

Future<Token> getToken(String appId, String appSecret) async {
  Stream<String> onCode = await _server();
  String url =
      "https://gitter.im/login/oauth/authorize?client_id=$appId&response_type=code&redirect_uri=http://localhost:8080/";
  UrlLauncher.launch(url);
  final String code = await onCode.first;
  final Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };
  final Map<String, String> data = {
    "client_id": appId,
    "client_secret": appSecret,
    "code": code,
    "redirect_uri": "http://localhost:8080/",
    "grant_type": "authorization_code",
  };
  final http.Response response = await http.post(
      "https://gitter.im/login/oauth/token",
      body: JSON.encode(data),
      headers: headers);
  return new Token.fromJson(JSON.decode(response.body));
}
