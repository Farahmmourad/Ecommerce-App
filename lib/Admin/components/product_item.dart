import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketky/Admin/components/edit_product.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final int index;
  final List<Product> Listproduct;
  final Color titleColor;
  final Color priceColor;
   String productId;

  ProductItem({
    @required this.product,
    @required this.index,
    @required this.Listproduct,
    this.titleColor = Colors.black,
    this.priceColor = AppColor.primary,
  });

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('products');

  void deleteProduct(BuildContext context) async {
    // Navigate to the edit product page and get the updated product data

    databaseReference.onValue.listen((event) async {
      Map<dynamic, dynamic> dataMap = event.snapshot.value;

      for (var key in dataMap.keys) {
        Product product1 = Product.fromJson(Map<String, dynamic>.from(dataMap[key]));
        if (product1.name == product.name){
          productId = key.toString();
          dataMap.removeWhere((key, value) => key == productId);
          await databaseReference.set(dataMap);
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product updated')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditPage(product: product),
        ));
      },
      child: ListTile(
        leading: Image.network(
          product.image[0],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          '${product.name}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${product.price}\$',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                color: priceColor,
              ),
            ),
            Text(
              '${product.category}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
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