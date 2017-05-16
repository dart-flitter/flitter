library flitter.routes.login;

import 'package:flitter/theme.dart';
import 'package:flutter/services.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_auth.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/gitter.dart';
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
    _subscription = flitterStore.onChange.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (flitterStore.state.token == null) {
      FlitterAuth.auth().then((GitterToken token) {
        initBasicData();
        flitterStore.dispatch(new AuthGitterAction(token));
      });

      // catch onBackPressed for Android
      flutterWebviewPlugin.onBackPressed.first.then((_) {
        return SystemNavigator.pop();
      });
    }
    return new MaterialApp(
        home: new Scaffold(
            body: new Center(child: new CircularProgressIndicator())),
        theme: kTheme);
  }
}
