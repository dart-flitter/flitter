library flitter.routes.home;

import 'dart:async';

import 'package:flitter/common.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
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

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _isRequesting = false;
    _searchResult = [];
    _fetchRooms();

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
    if (flitterStore.state.rooms == null) {
      return new Splash();
    }

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

  _fetchRooms() {
    gitterApi.user.me.rooms().then((List<Room> rooms) {
      flitterStore.dispatch(new FetchRoomsAction(rooms));
    });
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
      List result = await gitterApi.user.search(query, limit: 5);
      result.addAll(await gitterApi.room.search(query, limit: 10));
      setState(() {
        _searchResult = result;
        _isRequesting = false;
      });
    }
  }

  _buildSearchResult() => new ListSearchResult(_searchResult);

  _buildListRooms() => new ListRoomWidget(
      rooms: flitterStore.state.rooms,
      onRefresh: () {
        _fetchRooms();
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
    return SearchBar.buildSearchBar(context, 'Search', //todo: intl
        onSearchEnd: _handleSearchEnd,
        onChange: _handleSearchChange);
  }
}
