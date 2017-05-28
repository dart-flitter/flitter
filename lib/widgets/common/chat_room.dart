library flitter.common.chat_room_widget;

import 'dart:async';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  final Iterable<Message> messages;
  final _onNeedData;

  @override
  _ChatRoomWidgetState createState() => new _ChatRoomWidgetState();

  ChatRoom({@required this.messages: const []})
      : _onNeedData = new StreamController();

  Stream<Null> get onNeedDataStream => onNeedDataController.stream;

  StreamController<Null> get onNeedDataController => _onNeedData;
}

class _ChatRoomWidgetState extends State<ChatRoom> {
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

  _shouldMergeMessages(Message message, int index) =>
      index != widget.messages.length - 1 &&
      widget.messages.elementAt(index + 1).fromUser.id == message.fromUser.id &&
      message.sent
              .difference(widget.messages.elementAt(index + 1).sent)
              .inMinutes <=
          10;

  _buildListItem(BuildContext context, int index) {
    final message = widget.messages.elementAt(index);

    if (widget.messages.length >= 50 && index == widget.messages.length - 5) {
      widget.onNeedDataController.add(null);
    }

    if (_shouldMergeMessages(message, index)) {
      return new ChatMessage(
        withDivider: false,
        withAvatar: false,
        withTitle: false,
        message: message,
      );
    }

    return new ChatMessage(message: message);
  }
}

class ChatInput extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  ChatInput({@required this.onSubmit});

  @override
  _ChatInputState createState() => new _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Form(
      child: new Container(
        padding: new EdgeInsets.only(left: 8.0, right: 8.0),
        child: new TextField(
          controller: _textController,
          decoration: new InputDecoration(hintText: intl.typeChatMessage()),
          onSubmitted: (String value) {
            _textController.clear();
            widget.onSubmit(value);
          },
        ),
      ),
    );
  }
}

final _dateFormat = new DateFormat.MMMd()..add_Hm();

class ChatMessage extends StatelessWidget {
  final Message message;
  final bool withDivider;
  final bool withAvatar;
  final bool withTitle;

  ChatMessage(
      {@required this.message,
      this.withDivider: true,
      this.withAvatar: true,
      this.withTitle: true});

  @override
  Widget build(BuildContext context) {
    final row = <Widget>[];

    if (withAvatar) {
      row.add(new ChatMessageAvatar(
          avatar: new NetworkImage(message.fromUser.avatarUrlSmall)));
    } else {
      row.add(new Container(width: 64.0));
    }

    row.add(new Expanded(
        child: new ChatMessageContent(message: message, withTitle: withTitle)));

    final column = <Widget>[];

    if (withDivider) {
      column.add(new Divider(color: Colors.grey[200]));
    }

    column.add(new Padding(
        child: new Row(
            children: row, crossAxisAlignment: CrossAxisAlignment.start),
        padding: new EdgeInsets.only(
            bottom: withTitle ? 4.0 : 0.0,
            top: withTitle ? 4.0 : 0.0,
            right: 12.0)));

    return new Column(children: column);
  }
}

class ChatMessageAvatar extends StatelessWidget {
  final ImageProvider avatar;

  ChatMessageAvatar({@required this.avatar});

  @override
  Widget build(BuildContext context) {
    return new Column(children: [
      new Container(
        margin: new EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
        width: 40.0,
        child: new CircleAvatar(
            backgroundImage: avatar, backgroundColor: Colors.grey[200]),
      )
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }
}

class ChatMessageContent extends StatelessWidget {
  final Message message;
  final bool withTitle;

  ChatMessageContent({@required this.message, this.withTitle: true});

  TextStyle _titleTextStyle() {
    return new TextStyle(color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final column = [];

    if (message.fromUser.displayName != null) {
      column.add(new AnimatedDefaultTextStyle(
          style: _titleTextStyle(),
          duration: kThemeChangeDuration,
          child: new Container(
              padding: new EdgeInsets.only(bottom: 6.0),
              child: withTitle
                  ? new Row(children: [
                      new Expanded(
                          child: new Text(message.fromUser.displayName,
                              softWrap: true)),
                      new Text(_dateFormat.format(message.sent))
                    ])
                  : null)));
    }

    column.add(new Text(message.text, softWrap: true));

    return new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: column);
  }
}
