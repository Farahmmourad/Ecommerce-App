import 'package:flutter/material.dart';
import 'package:marketky/core/model/Product.dart';

import '../../views/screens/product_detail.dart';

class MySearchDelegate extends SearchDelegate {
  final List<Product> items;

  MySearchDelegate({this.items});

  @override
  List<Widget> buildActions(BuildContext context) {
    // Implement the clear button
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Implement the back button
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show search results based on query
    final filteredItems = items
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(filteredItems[index].name),
          onTap: () {
            close(context, filteredItems[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions while user is typing
    final suggestionItems = items
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionItems.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(suggestionItems[index].name),
          onTap: () {
            query = suggestionItems[index].name;
              Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetail(product: suggestionItems[index])));

          },
        );
      },
    );
  }
}