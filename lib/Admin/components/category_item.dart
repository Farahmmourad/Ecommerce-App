import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketky/Admin/components/edit_product.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Category.dart';
import 'package:marketky/core/model/Product.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final int index;
  final List<Category> Listcategory;
  final Color titleColor;
  final Color priceColor;
  String categoryId;

  CategoryItem({
    @required this.category,
    @required this.index,
    @required this.Listcategory,
    this.titleColor = Colors.black,
    this.priceColor = AppColor.primary,
  });

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('categories');

  void deleteProduct(BuildContext context) async {
    // Navigate to the edit product page and get the updated product data

    databaseReference.onValue.listen((event) async {
      Map<dynamic, dynamic> dataMap = event.snapshot.value;

      for (var key in dataMap.keys) {
        Category category1 = Category.fromJson(Map<String, dynamic>.from(dataMap[key]));
        if (category1.name == category.name){
          categoryId = key.toString();
          dataMap.removeWhere((key, value) => key == categoryId);
          await databaseReference.set(dataMap);
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Category deleted')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => EditPage(product: product),
        // ));
      },
      child: ListTile(
        title: Text(
          '${category.name}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),

        trailing: ElevatedButton(
          onPressed: () {
            deleteProduct(context);
          },
          child: Text('Delete'),
          style: ElevatedButton.styleFrom(
            primary: AppColor.primary, // Change the color here
          ),
        ),
      ),
    );
  }
}