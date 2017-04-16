import 'dart:async';

import 'package:flitter/common.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/app.dart';

class HomeView extends StatefulWidget {
  static final String path = "/home";

  HomeView();

  static void go(BuildContext context, {bool replace: true}) {
    navigateTo(context, new HomeView(), path: HomeView.path, replace: replace);
  }

  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
      body = _buildListRooms();
    }

    return new Scaffold(
        appBar: _isSearching == true ? _buildSearchBar() : _buildAppBar(),
        drawer: new FlitterDrawer(onTapAllConversation: () {
          Navigator.pop(context);
        }, onTapPeoples: () {
          PeopleView.go(context);
        }),
        body: body);
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

  void _handleSearchEnd() {
    Navigator.pop(context);
  }

  _handleSearchChange(String query) async {
    if (query.length > 3) {
      setState(() {
        _isRequesting = true;
      });
      List result = await App.of(context).api.user.search(query, limit: 5);
      result.addAll(await App.of(context).api.room.search(query, limit: 10));
      setState(() {
        _searchResult = result;
        _isRequesting = false;
      });
    }
  }

  _buildSearchResult() => new ListSearchResult(_searchResult);

  _buildListRooms() => new ListRoomWidget(
      rooms: App.of(context).rooms ?? [],
      onRefresh: () {
        return onRefresh(context);
      });

  Widget _buildAppBar() => new AppBar(
          title: new Text(
            intl.allConversations(),
          ),
          actions: [
            new IconButton(
                icon: new Icon(Icons.search), onPressed: _handleSearchBegin)
          ]);

  Widget _buildSearchBar() {
    return SearchBar.buildSearchBar(context, 'Search',
        onSearchEnd: _handleSearchEnd, onChange: _handleSearchChange);
  }
}

class SearchBar extends StatelessWidget {
  final VoidCallback onSearchEnd;
  final ValueChanged<String> onChange;
  final TextEditingController controller;
  final String hintText;

  SearchBar({this.onSearchEnd, this.controller, this.hintText, this.onChange});

  @override
  Widget build(BuildContext context) {
    return buildSearchBar(context, hintText,
        onSearchEnd: onSearchEnd, onChange: onChange);
  }

  //todo: remove this when Scaffold will be less restrictive for appBar
  static Widget buildSearchBar(BuildContext context, String hintText,
          {TextEditingController controller,
          ValueChanged<String> onChange,
          VoidCallback onSearchEnd}) =>
      new AppBar(
        leading: new IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).accentColor,
            onPressed: onSearchEnd),
        title: new TextField(
          controller: controller,
          onChanged: onChange,
          autofocus: true,
          decoration: new InputDecoration(
            hintText: hintText,
          ),
        ),
        backgroundColor: Theme.of(context).canvasColor,
      );
}

class ListSearchResult extends StatelessWidget {
  final List results;

  ListSearchResult(this.results);

  @override
  Widget build(BuildContext context) => new ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: results.length,
        itemBuilder: _buildListTile,
      );

  Widget _buildListTile(BuildContext context, int index) {
    final result = results[index];
    if (result is Room) {
      return roomTile(context, result);
    } else if (result is User) {
      return userTile(context, result);
    }
    return new ListTile();
  }
}
