library flitter.auth;

import 'dart:async';
import 'dart:convert';

import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_config.dart';
import 'package:gitter/gitter.dart';
import 'package:flitter/services/flutter_gitter_auth.dart';
import 'package:flitter/redux/actions.dart';
import 'package:gitter/src/oauth/oauth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlitterAuth {
  static const _tokenKey = "gitter_token";

  static Future<GitterToken> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenJson = prefs.getString(_tokenKey);
    if (tokenJson == null) {
      return null;
    }
    return new GitterToken.fromJson(JSON.decode(tokenJson));
  }

  static Future<bool> saveToken(GitterToken token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        _tokenKey, token == null ? null : JSON.encode(token?.toMap()));
    return prefs.commit();
  }

  static Future<GitterToken> auth() async {
    final cfg = Config.getInstance();
    final GitterOAuth gitterOAuth = new FlutterGitterOAuth(new AppInformations(
      cfg.gitter.appId,
      cfg.gitter.appSecret,
      cfg.gitter.redirectionUrl,
    ));
    GitterToken token = await gitterOAuth.signIn();
    await saveToken(token);
    return token;
  }

  static Future<Null> logout() async {
    saveToken(null);
    gitterStore.dispatch(new LogoutAction());
  }
}
