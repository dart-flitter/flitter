library flitter.widgets;

import 'package:flutter/material.dart';

export 'widgets/common/drawer.dart';
export 'package:flitter/theme.dart';
export 'widgets/common/chat_room_widget.dart';
export 'widgets/common/list_room.dart';

navigateTo(BuildContext context, Widget route,
    {bool replace: false, bool opaque: false}) {
  PageRouteBuilder builder = new PageRouteBuilder(
      opaque: opaque,
      pageBuilder: (_, __, ___) {
        return route;
      });
  if (replace) {
    Navigator.of(context).pushReplacement(builder);
  } else {
    Navigator.of(context).push(builder);
  }
}
