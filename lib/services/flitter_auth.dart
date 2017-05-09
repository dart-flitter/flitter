library flitter.auth;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flitter/redux/store.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/services/oauth/oauth.dart';
import 'package:flutter/services.dart';
import 'package:flitter/services/flutter_gitter_auth.dart';
import 'package:flitter/redux/actions.dart';


class FlitterAuth {
  static Future<File> _getTokenFile() async {
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    return new File("$dir/token.json");
  }

  static Future<GitterToken> auth() async {
    final GitterOAuth gitterOAuth = new FlutterGitterOAuth(new AppInformations(
      "26258fa3ccd13c487dd8b5ed7e2acbeb087d14eb",
      "9c2239a87cfcf51d43c2abb30eae7e1878e5f268",
      "http://localhost:8080/",
    ));
    GitterToken token = await gitterOAuth.signIn();
    if (token != null) {
      File tokenFile = await _getTokenFile();
      tokenFile.writeAsStringSync(JSON.encode(token.toMap()));
    }
    return token;
  }

  static Future<Null> saveToken(GitterToken token) async {
    File tokenFile = await _getTokenFile();
    if (!tokenFile.existsSync()) {
      await tokenFile.create(recursive: true);
    }
    if (token != null) {
      return tokenFile.writeAsString(JSON.encode(token.toMap()));
    }
    return tokenFile.writeAsString(JSON.encode({}));
  }

  static Future<Null> logout() async {
    await saveToken(null);
    flitterStore.dispatch(new LogoutAction());
    flitterStore.dispatch(new LogoutAction());
  }

  static Future<GitterToken> getSavedToken() async {
    File tokenFile = await _getTokenFile();
    if (!await tokenFile.exists()) {
      return null;
    }
    Map token = JSON.decode(await tokenFile.readAsString());
    if (token.isEmpty) {
      return null;
    }
    return new GitterToken.fromJson(token);
  }
}
