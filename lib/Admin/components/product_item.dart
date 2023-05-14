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

      Listproduct.removeAt(index);
      databaseReference.update(Listproduct as Map<String, Object>);
      // for (var key in dataMap.keys) {
      //   Product product1 = Product.fromJson(
      //       Map<String, dynamic>.from(dataMap[key]));
      //   if (product1.name == product.name) {
      //     productId = key.toString();
      //     DatabaseReference productRef =
      //     FirebaseDatabase.instance.ref().child('products').child(productId);
      //     await productRef.set(product.toJson());
      //   }
      // }
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
            builder: (context) => EditPage(product: product)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // item image
            Image.network(
              product.image[0],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),


            // item details
            Container(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.name}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2, bottom: 8),
                    child: Text(
                      '${product.price}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: priceColor,
                      ),
                    ),
                  ),
                  Text(
                    '${product.storeName}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  deleteProduct(context);

                },
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  primary: AppColor.primary, // Change the color here
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}