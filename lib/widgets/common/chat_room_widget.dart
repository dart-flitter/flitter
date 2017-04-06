import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flitter/intl/messages_all.dart' as intl;

class ChatRoomWidget extends StatefulWidget {
  @override
  _ChatRoomWidgetState createState() => new _ChatRoomWidgetState();
}

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.white,
        child: new ListView(shrinkWrap: true, children: [
          new ChatMessageWidget(
              leading: new Icon(Icons.person),
              title: "user 1",
              body: new Text(
                  "dfk djfkldsj fjdsl;f jl;kdsf;j dkfdlsk fl;dks l;fkdsl;kf l;dskfl; kdls;kfl;d sklfk ;ldskfl;k dsl;kfl ;dskl;f kl;dskf l;ksl;d kfl;kds l;f;slgjdks;lg sdfljd skjfkl sjfklj dsljf jdslfjk sdjfklj sdkljfkljdkl sjfkl",
                  softWrap: true)),
          new ChatMessageWidget(
              leading: new Icon(Icons.person),
              title: "user 2",
              body: new Text(
                  "dfk djfkldsj fjdsl;f jl;kdsf;j dkfdlsk fl;dks l;fkdsl;kf l;dskfl; kdls;kfl;d sklfk ;ldskfl;k dsl;kfl ;dskl;f kl;dskf l;ksl;d kfl;kds l;f;slgjdks;lg sdfljd skjfkl sjfklj dsljf jdslfjk sdjfklj sdkljfkljdkl sjfkl",
                  softWrap: true))
        ]));
  }
}

class ChatInput extends StatefulWidget {
  final ValueChanged<String> onChanged;

  ChatInput({@required this.onChanged});

  @override
  _ChatInputState createState() => new _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  @override
  Widget build(BuildContext context) {
    return new Form(
        child: new Container(
      padding: new EdgeInsets.only(left: 8.0, right: 8.0),
      child: new TextField(
          decoration: new InputDecoration(hintText: intl.typeChatMessage()),
          onChanged: config.onChanged),
    ));
  }
}

class ChatMessageWidget extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget body;

  ChatMessageWidget(
      {@required this.leading, @required this.body, @required this.title});

  TextStyle _titleTextStyle() {
    return new TextStyle(color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final children = [];
    children.add(new Column(children: [
      new Container(
          margin: new EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
          width: 40.0,
          child: leading)
    ], crossAxisAlignment: CrossAxisAlignment.start));
    final content = new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new AnimatedDefaultTextStyle(
              style: _titleTextStyle(),
              duration: kThemeChangeDuration,
              child: new Container(
                  padding: new EdgeInsets.only(bottom: 6.0),
                  child: new Text(title, softWrap: true))),
          body
        ]);
    children.add(new Expanded(child: content));
    return new Column(children: [
      new Padding(
          child: new Row(
              children: children, crossAxisAlignment: CrossAxisAlignment.start),
          padding: new EdgeInsets.only(bottom: 8.0, top: 8.0, right: 12.0)),
      new Divider(height: 1.0)
    ]);
  }
}
