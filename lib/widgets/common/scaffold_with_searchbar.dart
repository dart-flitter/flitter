import 'package:flitter/widgets/common/search.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';

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
