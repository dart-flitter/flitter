import 'package:flutter/material.dart';

DateTime parseLastAccessTime(String lastAccessTime) {
  RegExp regExp = new RegExp(
      r"^([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2})");
  Match match = regExp.firstMatch(lastAccessTime);
  return new DateTime(
    int.parse(match.group(1)),
    int.parse(match.group(2)),
    int.parse(match.group(3)),
    int.parse(match.group(4)),
    int.parse(match.group(5)),
    int.parse(match.group(6)),
  );
}

void navigateTo(BuildContext context, Widget widget,
    {String path: '', bool replace: false}) {
  PageRouteBuilder builder = new PageRouteBuilder(
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
  MaterialPageRoute route = new MaterialPageRoute(
    settings: path.isNotEmpty ? new RouteSettings(name: path) : null,
    builder: (BuildContext context) => widget,
  );
  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}