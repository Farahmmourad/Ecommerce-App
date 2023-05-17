import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketky/core/model/Product.dart';

import '../../views/screens/product_detail.dart';

class MySearchDelegate extends SearchDelegate {

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('products');

  MySearchDelegate();

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
    return FutureBuilder<List<dynamic>>(
      future: fetchFilteredData(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<dynamic> filteredList = snapshot.data;
          // Display the filtered list as needed
          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredList[index]['name']),
                // Add more widget properties as needed
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query==''){
      return Container();
    }
    // Show suggestions while user is typing
    return FutureBuilder<List<dynamic>>(
      future: fetchFilteredData(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<dynamic> filteredList = snapshot.data;
          // Display the filtered list as needed
          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredList[index].name),
                // Add more widget properties as needed
                onTap: () {
                  query = filteredList[index].name;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDetail(product: filteredList[index])));

                },
              );
            },
          );
        }
      },
    );
  }

  Future<List<dynamic>> fetchFilteredData(String searchQuery) async {
    Query query = databaseReference.orderByChild('name').startAt(searchQuery).endAt(searchQuery + '\uf8ff');
    DatabaseEvent dataSnapshot = await query.once();
    Map<dynamic, dynamic> dataMap = dataSnapshot.snapshot.value;
    if (dataMap == null) {
      return []; // Return an empty list if no data is available
    }
    List<dynamic> dataList = dataMap.values.toList();
    List<Product> dataList1 = [];
    for (var data in dataList) {
      Product product = Product.fromJson(Map<String, dynamic>.from(data));
      dataList1.add(product);
    }
    return dataList1;
  }
}