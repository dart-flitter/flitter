library oauth.get_token;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flitter/services/oauth/src/server.dart';

String mapToQueryParams(Map<String, String> params) {
  final List<String> queryParams = [];
  params.forEach((String key, String value) => queryParams.add("$key=$value"));
  return queryParams.join("&");
}

Future<String> getCode(String url, Map<String, String> params) async {
  final Stream<String> onCode = await server();
  final String urlParams = mapToQueryParams(params);
  UrlLauncher.launch("$url?$urlParams");
  return await onCode.first;
}

Future<Map<String, String>> getToken(
    String url, String code, Map<String, String> params,
    {bool isPost: false, Map<String, String> headers}) async {
  http.Response response;
  if (isPost) {
    response =
        await http.post("$url", body: JSON.encode(params), headers: headers);
  } else {
    response = await http.get("$url?${mapToQueryParams(params)}");
  }
  return JSON.decode(response.body);
}
