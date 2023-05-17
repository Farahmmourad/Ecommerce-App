import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketky/Admin/components/add_page.dart';
import 'package:marketky/Admin/components/category_item.dart';
import 'package:marketky/Admin/components/add_category.dart';
import 'package:marketky/Admin/components/product_item.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Category.dart';
import '../../views/widgets/item_card.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('categories');

  List<Category> categoryList = [];

  @override
  void initState() {
    super.initState();

    // Listen for changes in database reference
    databaseReference.onValue.listen((event) {
      Map<dynamic, dynamic> dataMap = event.snapshot.value;

      if (dataMap == null) {
        categoryList = [];
        return;
      }

      List<dynamic> dataList = dataMap.values.toList();
      List<Category> categories = [];
      for (var data in dataList) {
        Category category = Category.fromJson(Map<String, dynamic>.from(data));
        categories.add(category);
      }

      setState(() {
        categoryList = categories;
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 20),
          Text('Categories'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                categoryList.length,
                    (index) => CategoryItem(
                  category: categoryList[index],
                  index: index,
                  Listcategory: categoryList,
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddCategory()));

              },
              child: Text('Add Category'),
              style: ElevatedButton.styleFrom(
                primary: AppColor.primary, // Change the color here
              ),
            ),
          ),
        ],
      ),
    );
  }
}
