library flitter.common.search;

import 'package:flitter/widgets/common/list_room.dart';
import 'package:flutter/material.dart';
import 'package:gitter/gitter.dart';
import 'package:meta/meta.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';

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

class ListSearchResult<T> extends StatelessWidget {
  final Iterable<T> results;

  ListSearchResult(this.results);

  @override
  Widget build(BuildContext context) => new ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: results.length,
        itemBuilder: _buildListTile,
      );

  _buildListTile(BuildContext context, int index) =>
      new SearchResultTile(result: results.elementAt(index));
}

class SearchResultTile extends StatelessWidget {
  final result;

  SearchResultTile({@required this.result});

  @override
  Widget build(BuildContext context) {
    if (result is Room) {
      return new RoomTile(room: result);
    } else if (result is User) {
      return new UserTile(user: result);
    }
    return new ListTile();
  }
}

class ScaffoldWithSearchbar extends StatefulWidget {
  final Widget body;
  final String title;
  final Widget drawer;

  ScaffoldWithSearchbar(
      {@required this.body, @required this.title, this.drawer});

  @override
  _ScaffoldWithSearchbarState createState() =>
      new _ScaffoldWithSearchbarState();
}

class _ScaffoldWithSearchbarState extends State<ScaffoldWithSearchbar> {
  @override
  Widget build(BuildContext context) {
    var body;
    if (flitterStore.state.search.searching == true) {
      if (flitterStore.state.search.requesting == true) {
        body = new Container(child: new LinearProgressIndicator());
      } else {
        body = _buildSearchResult();
      }
    } else {
      body = widget.body;
    }

    return new Scaffold(
        appBar: flitterStore.state.search.searching == true
            ? _buildSearchBar()
            : _buildAppBar(),
        drawer: widget.drawer,
        body: body);
  }

  void _handleSearchBegin() {
    ModalRoute.of(context).addLocalHistoryEntry(new LocalHistoryEntry(
      onRemove: () {
        flitterStore.dispatch(new EndSearchAction());
      },
    ));
    flitterStore.dispatch(new ShowSearchBarAction());
  }

  void _handleSearchEnd() {
    Navigator.pop(context);
  }

  _handleSearchChange(String query) async {
    if (query.length > 3) {
      search(query);
    }
  }

  _buildSearchResult() =>
      new ListSearchResult(flitterStore.state.search.result);

  Widget _buildAppBar() => new AppBar(title: new Text(widget.title), actions: [
        new IconButton(
            icon: new Icon(Icons.search), onPressed: _handleSearchBegin)
      ]);

  Widget _buildSearchBar() {
    return SearchBar.buildSearchBar(context, 'Search', //todo: intl
        onSearchEnd: _handleSearchEnd,
        onChange: _handleSearchChange);
  }
}
