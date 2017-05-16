import 'package:flutter/material.dart';

void navigateTo(BuildContext context, Widget widget,
    {String path: '', bool replace: false}) {
  final builder = new PageRouteBuilder(
    settings: path.isNotEmpty ? new RouteSettings(name: path) : null,
    pageBuilder: (_, __, ___) {
      return widget;
    },
  );
  if (replace) {
    Navigator.of(context).pushReplacement(builder);
  } else {
    Navigator.of(context).push(builder);
  }
}

void materialNavigateTo(BuildContext context, Widget widget,
    {String path: '', bool replace: false}) {
  final route = new MaterialPageRoute(
    settings: path.isNotEmpty ? new RouteSettings(name: path) : null,
    builder: (BuildContext context) => widget,
  );
  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}
