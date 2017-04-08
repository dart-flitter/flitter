library oauth.oauth;

import 'dart:async';
import 'dart:convert';

import 'package:flitter/services/oauth/src/models/app_informations.dart';
import 'package:flitter/services/oauth/src/models/code_informations.dart';
import 'package:flitter/services/oauth/src/models/token_informations.dart';
import 'package:http/http.dart' as http;
import 'package:flitter/services/oauth/src/server.dart';
import 'package:flutter/services.dart';

abstract class OAuth {
  final AppInformations appInformations;
  final CodeInformations _codeInformations;

  String code;
  Map<String, dynamic> token;

  TokenInformations tokenInformations;

  OAuth(this.appInformations, this._codeInformations);

  Future<String> getCode() async {
    if (code == null || _codeInformations.force) {
      final Stream<String> onCode = await server();
      final String urlParams = _mapToQueryParams(_codeInformations.params);
      UrlLauncher.launch("${_codeInformations.url}?$urlParams");
      code = await onCode.first;
    }
    return code;
  }

  Future<Map<String, dynamic>> getToken() async {
    if (token == null || tokenInformations.force) {
      http.Response response;
      if (tokenInformations.isPost) {
        response = await http.post("${tokenInformations.url}",
            body: JSON.encode(tokenInformations.params),
            headers: tokenInformations.headers);
      } else {
        response = await http.get(
            "${tokenInformations.url}?${_mapToQueryParams(tokenInformations.params)}");
      }
      token = JSON.decode(response.body);
    }
    return token;
  }

  void generateTokenInformations();

  String _mapToQueryParams(Map<String, String> params) {
    final List<String> queryParams = [];
    params
        .forEach((String key, String value) => queryParams.add("$key=$value"));
    return queryParams.join("&");
  }
}
