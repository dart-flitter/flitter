library flitter.auth;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/services/oauth/oauth.dart';
import 'package:flutter/services.dart';
import 'package:flitter/services/flutter_gitter_auth.dart';

Future<File> getTokenFile() async {
  String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
  return new File("$dir/token.json");
}

Future<GitterToken> auth() async {
  final GitterOAuth gitterOAuth = new FlutterGitterOAuth(new AppInformations(
    "26258fa3ccd13c487dd8b5ed7e2acbeb087d14eb",
    "9c2239a87cfcf51d43c2abb30eae7e1878e5f268",
    "http://localhost:8080/",
  ));
  GitterToken token = await gitterOAuth.signIn();
  if (token != null) {
    File tokenFile = await getTokenFile();
    tokenFile.writeAsStringSync(JSON.encode(token.toMap()));
  }
  return token;
}

Future<Null> saveToken(GitterToken token) async {
  File tokenFile = await getTokenFile();
  if (!tokenFile.existsSync()) {
    await tokenFile.create(recursive: true);
  }
  if (token != null) {
    return tokenFile.writeAsString(JSON.encode(token.toMap()));
  }
  return tokenFile.writeAsString(JSON.encode({}));
}

Future<Null> logout(BuildContext context) async {
  // App.of(context).rooms = [];
  // App.of(context).user = null;
  return saveToken(null);
}
