import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Search.dart';
import 'package:marketky/core/services/SearchService.dart';
import 'package:marketky/views/screens/search_result_page.dart';
import 'package:marketky/views/widgets/popular_search_card.dart';
import 'package:marketky/views/widgets/search_history_tile.dart';

import '../../core/model/Product.dart';
import '../../core/services/MySearchDelegate.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchHistory> listSearchHistory = SearchService.listSearchHistory;
  List<PopularSearch> listPopularSearch = SearchService.listPopularSearch;

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('products');
  dynamic dataList = [];
  MySearchDelegate _searchDelegate;

  @override
  void initState() {
    super.initState();

    databaseReference.onValue.listen((event) {
      setState(() {
        //change this to List<Map<String, Object>>
        Map<dynamic, dynamic> dataList1 = event.snapshot.value;
        List<Map<String, Object>> mappedList2 = [];
        dataList1.forEach((key, value) {
          Map<String, Object> mappedItem = Map<String, Object>.from(value);
          mappedList2.add(mappedItem);
        });
        // log(dataList1 as String);
        // for (var item in dataList) {
        // List<Map<String, Object>> mappedList = [];
        //   Map<String, Object> mappedItem = Map<String, Object>.from(item);
        //   mappedList.add(mappedItem);
        // }
        // log(mappedList as String);
        List<Product> products = mappedList2.map((data) => Product.fromJson(data)).toList();
        // log(products as String);
        dataList = products;
        _searchDelegate = MySearchDelegate(items: products);
        // log(dataList1 as String);
      });
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            'assets/icons/Arrow-left.svg',
            color: Colors.white,
          ),
        ),
        title: Container(
          height: 40,
          child: TextField(
            autofocus: false,
            style: TextStyle(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.3)),
              hintText: 'Find a products...',
              prefixIcon: Container(
                padding: EdgeInsets.all(10),
                child: SvgPicture.asset('assets/icons/Search.svg', color: Colors.white),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              fillColor: Colors.white.withOpacity(0.1),
              filled: true,
            ),
            onTap: () async {
              final result = await showSearch(
                context: context,
                delegate: _searchDelegate,
              );
              print(result);
            },
          ),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Search History
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Search history...',
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listSearchHistory.length,
                itemBuilder: (context, index) {
                  return SearchHistoryTile(
                    data: listSearchHistory[index],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchResultPage(
                            searchKeyword: listSearchHistory[index].title,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Delete search history',
                    style: TextStyle(color: AppColor.secondary.withOpacity(0.5)),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColor.primary.withOpacity(0.3), backgroundColor: AppColor.primarySoft,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  ),
                ),
              ),
            ],
          ),
          // Section 2 - Popular Search
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Popular search.',
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: List.generate(listPopularSearch.length, (index) {
                  return PopularSearchCard(
                    data: listPopularSearch[index],
                    onTap: () {},
                  );
                }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
