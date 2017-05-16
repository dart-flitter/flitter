library flitter.common.chat_room_widget;

import 'dart:async';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:intl/intl.dart';

class ChatRoomWidget extends StatefulWidget {
  final Iterable<Message> messages;
  final StreamController<Null> _onNeedData;

  @override
  _ChatRoomWidgetState createState() => new _ChatRoomWidgetState();

  ChatRoomWidget({@required this.messages: const []})
      : _onNeedData = new StreamController();

  Stream<Null> get onNeedDataStream => onNeedDataController.stream;

  StreamController<Null> get onNeedDataController => _onNeedData;
}

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return new Container(color: Colors.white);
    }
    return new Container(
      color: Colors.white,
      child: new ListView.builder(
        reverse: true,
        itemCount: widget.messages.length,
        itemBuilder: _buildListItem,
      ),
    );
  }

  _buildListItem(BuildContext context, int index) {
    Message message = widget.messages.elementAt(index);
    if (widget.messages.length >= 50 && index == widget.messages.length - 5) {
      widget.onNeedDataController.add(null);
    }

    if (index != widget.messages.length - 1 &&
        widget.messages.elementAt(index + 1).fromUser.id ==
            message.fromUser.id &&
        message.sent
                .difference(widget.messages.elementAt(index + 1).sent)
                .inMinutes <=
            10) {
      return new ChatMessageWidget(
        leading: new Container(),
        withDivider: false,
        body: new Text(message.text, softWrap: true),
      );
    }

    return new ChatMessageWidget(
        leading: new CircleAvatar(
            backgroundImage: new NetworkImage(message.fromUser.avatarUrlSmall),
            backgroundColor: Colors.grey[200]),
        body: new Text(message.text, softWrap: true),
        title: message.fromUser.displayName,
        date: message.sent);
  }
}

class ChatInput extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  ChatInput({@required this.onSubmit});

  @override
  _ChatInputState createState() => new _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Form(
      child: new Container(
        padding: new EdgeInsets.only(left: 8.0, right: 8.0),
        child: new TextField(
          controller: textController,
          decoration: new InputDecoration(hintText: intl.typeChatMessage()),
          onSubmitted: (String value) {
            textController.clear();
            widget.onSubmit(value);
          },
        ),
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final Widget leading;
  final String title;
  final DateTime date;
  final Widget body;
  final bool withDivider;

  final DateFormat _dateFormat = new DateFormat.MMMd()..add_Hm();

  ChatMessageWidget(
      {this.leading,
      @required this.body,
      this.title,
      this.withDivider: true,
      this.date});

  TextStyle _titleTextStyle() {
    return new TextStyle(color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (leading != null) {
      children.add(_buildAvatar());
    }

    final content = _buildContent();

    children.add(new Expanded(child: content));

    return _buildContainer(children);
  }

  Widget _buildContainer(Iterable<Widget> body) {
    final children = <Widget>[];

    if (withDivider) {
      children.add(new Divider(color: Colors.grey[200]));
    }

    children.add(new Padding(
        child: new Row(
            children: body, crossAxisAlignment: CrossAxisAlignment.start),
        padding: new EdgeInsets.only(bottom: 4.0, top: 4.0, right: 12.0)));

    return new Column(children: children);
  }

  Widget _buildAvatar() {
    return new Column(children: [
      new Container(
          margin: new EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
          width: 40.0,
          child: leading)
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _buildContent() {
    final children = [];

    if (title != null) {
      children.add(new AnimatedDefaultTextStyle(
          style: _titleTextStyle(),
          duration: kThemeChangeDuration,
          child: new Container(
              padding: new EdgeInsets.only(bottom: 6.0),
              child: new Row(children: [
                new Expanded(child: new Text(title, softWrap: true)),
                new Text(_dateFormat.format(date))
              ]))));
    }
    children.add(body);

    return new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children);
  }
}
