library flitter.routes.login;

import 'package:flutter/services.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_auth.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:flutter/material.dart';
import 'package:gitter/gitter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

typedef void OnLoginCallback(GitterToken token);

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => new _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var _subscription;

  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    _subscription = gitterStore.onChange.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  Future<Null> _auth() async {
    GitterToken token = await FlitterAuth.auth();
    initStores(token);
  }

  Future<Null> _catchOnBackPressed() async {
    // catch onBackPressed for Android
    await flutterWebviewPlugin.onBackPressed.first;
    return SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (gitterToken == null) {
      _auth();

      _catchOnBackPressed();
    }
    return new MaterialApp(
        home: new Scaffold(
            body: new Center(child: new CircularProgressIndicator())),
        theme: themeStore.state.theme);
  }
}
