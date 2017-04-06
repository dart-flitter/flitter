import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/services/oauth/oauth.dart';
import 'package:flutter/services.dart';

Future<GitterToken> auth() async {
  String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
  File tokenFile = new File("$dir/token.json");
  GitterToken token;
  if (!tokenFile.existsSync()) {
    tokenFile.createSync();
  }
  final String content = await tokenFile.readAsString();
  if (content.isEmpty) {
    final GitterOAuth gitterOAuth = new GitterOAuth(new AppInformations(
        "26258fa3ccd13c487dd8b5ed7e2acbeb087d14eb",
        "9c2239a87cfcf51d43c2abb30eae7e1878e5f268",
        "http://localhost:8080/",
    ));
    token = await gitterOAuth.signIn();
    tokenFile.writeAsStringSync(JSON.encode(token.toMap()));
    return token;
  }
  return new GitterToken.fromJson(JSON.decode(content));
}