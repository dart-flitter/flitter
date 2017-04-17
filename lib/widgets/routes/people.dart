library flitter.routes.people;

import 'dart:async';

import 'package:flitter/common.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/app.dart';

class PeopleView extends StatefulWidget {
  static const String path = "/people";

  static void go(BuildContext context, {bool replace: true}) {
    navigateTo(context, new PeopleView(),
        path: PeopleView.path, replace: replace);
  }

  PeopleView();

  @override
  _PeopleViewState createState() => new _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  bool _isSearching;
  bool _isRequesting;
  List _searchResult;

  Future<Null> onRefresh(BuildContext context) async {
    List<Room> rooms = await App.of(context).api.user.me.rooms();
    if (!mounted) {
      return;
    }
    setState(() {
      App.of(context).rooms = rooms;
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _isRequesting = false;
    _searchResult = [];
  }

  @override
  Widget build(BuildContext context) {
    var body;

    if (_isSearching == true) {
      if (_isRequesting == true) {
        body = new Container(child: new LinearProgressIndicator());
      } else {
        body = _buildSearchResult();
      }
    } else {
      if (App.of(context).rooms == null) {
        body = new Center(child: new CircularProgressIndicator());
      } else {
        body = _buildListRooms();
      }
    }

    return new Scaffold(
      appBar: _isSearching == true ? _buildSearchBar() : _buildAppBar(),
      body: body,
      drawer: new FlitterDrawer(onTapAllConversation: () {
        HomeView.go(context);
      }, onTapPeoples: () {
        Navigator.pop(context);
      }),
    );
  }

  Widget _buildAppBar() => new AppBar(
          title: new Text(
            intl.people(),
          ),
          actions: [
            new IconButton(
                icon: new Icon(Icons.search), onPressed: _handleSearchBegin)
          ]);

  Widget _buildSearchBar() {
    return SearchBar.buildSearchBar(context, 'Search', //todo: intl
        onSearchEnd: _handleSearchEnd,
        onChange: _handleSearchChange);
  }

  void _handleSearchEnd() {
    Navigator.pop(context);
  }

  void _handleSearchBegin() {
    ModalRoute.of(context).addLocalHistoryEntry(new LocalHistoryEntry(
      onRemove: () {
        setState(() {
          _isSearching = false;
          _isRequesting = false;
          _searchResult = [];
        });
      },
    ));
    setState(() {
      _isSearching = true;
      _isRequesting = false;
      _searchResult = [];
    });
  }

  _handleSearchChange(String query) async {
    if (query.length > 3) {
      setState(() {
        _isRequesting = true;
      });
      List result = await App.of(context).api.user.search(query, limit: 15);
      setState(() {
        _searchResult = result;
        _isRequesting = false;
      });
    }
  }

  _buildListRooms() => new ListRoomWidget(
      rooms: App.of(context).rooms.where((Room room) => room.oneToOne).toList(),
      onRefresh: () {
        return onRefresh(context);
      });

  _buildSearchResult() => new ListSearchResult(_searchResult);
}
