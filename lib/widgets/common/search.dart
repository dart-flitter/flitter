library gitter.common.search;

import 'package:flutter/material.dart';
import 'package:flitter/common.dart';
import 'package:flitter/services/gitter/gitter.dart';

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
