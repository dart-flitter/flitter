library flitter.common.chat_room_widget;

import 'dart:async';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

final _dateFormat = new DateFormat.MMMd()..add_Hm();

class ChatRoom extends StatefulWidget {
  final Iterable<Message> messages;
  final Room room;
  final _onNeedData;

  @override
  _ChatRoomWidgetState createState() => new _ChatRoomWidgetState();

  ChatRoom({@required this.messages, @required this.room})
      : _onNeedData = new StreamController();

  Stream<Null> get onNeedDataStream => onNeedDataController.stream;

  StreamController<Null> get onNeedDataController => _onNeedData;
}

class _ChatRoomWidgetState extends State<ChatRoom> {
  bool get _userHasJoined =>
      flitterStore.state.rooms.any((Room r) => r.id == widget.room.id);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      new Flexible(
          child: new ListView.builder(
        reverse: true,
        itemCount: widget.messages.length,
        itemBuilder: _buildListItem,
      )),
    ];

    if (_userHasJoined) {
      children.addAll([
        new Divider(height: 1.0),
        new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildChatInput())
      ]);
    }

    return new Column(children: children);
  }

  Widget _buildChatInput() => new ChatInput(
        onSubmit: (String value) async {
          sendMessage(value, widget.room);
        },
      );

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
          atBottom: index == 0);
    }

    return new ChatMessage(message: message, atBottom: index == 0);
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
    return new Container(
        padding: new EdgeInsets.all(8.0),
        decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        child: new IconTheme(
            data: new IconThemeData(color: Theme.of(context).accentColor),
            child: new Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Row(children: [
                  new Flexible(
                    child: new TextField(
                      onSubmitted: (_) => _handleSubmitted(),
                      controller: _textController,
                      decoration: new InputDecoration.collapsed(
                          hintText: intl.typeChatMessage()),
                      maxLines: 3,
                    ),
                  ),
                  new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 4.0),
                      child: new IconButton(
                          icon: new Icon(Icons.send),
                          onPressed: _handleSubmitted)),
                ]))));
  }

  _handleSubmitted() {
    String value = _textController.text;
    _textController.clear();
    if (value.isNotEmpty) {
      widget.onSubmit(value);
    }
  }
}

class ChatMessage extends StatelessWidget {
  final Message message;
  final bool withDivider;
  final bool withAvatar;
  final bool withTitle;
  final bool atBottom;

  ChatMessage(
      {@required this.message,
      this.withDivider: true,
      this.withAvatar: true,
      this.withTitle: true,
      this.atBottom: false});

  @override
  Widget build(BuildContext context) {
    final row = <Widget>[];

    if (withAvatar) {
      row.add(new ChatMessageAvatar(
          avatar: new NetworkImage(message.fromUser.avatarUrlSmall)));
    } else {
      row.add(new Container(width: 54.0));
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
            bottom: withTitle || atBottom ? 8.0 : 0.0, right: 12.0)));

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
        width: 30.0,
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

    column.add(new MarkdownBody(
        data: message.text,
        //fixme does not seem to work
        onTapLink: (String url) async {
          bool can = await url_launcher.canLaunch(url);
          if (can) {
            url_launcher.launch(url);
          }
        }));

    return new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: column);
  }
}
