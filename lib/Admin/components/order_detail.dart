import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../constant/app_color.dart';
import '../../core/model/Cart.dart';
import '../../core/model/ColorWay.dart';
import '../../core/model/Order.dart';
import '../../core/model/Product.dart';
import '../../core/model/ProductSize.dart';

class DetailOrder extends StatefulWidget {
  final Order order;
  DetailOrder({@required this.order});
  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {

  final _formKey = GlobalKey<FormState>();
  List<dynamic> _images = [];
  String _status = 'pending';
  List<dynamic> _cart = [];
  String _category = '';
  String orderId = '';
  String dropdownValue = 'pending';

  @override
  void initState() {
    super.initState();

  }
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('orders');

  List<Product> orderList = [];

  void editOrder(BuildContext context, Order orderI) async {
    // Navigate to the edit product page and get the updated product data
    databaseReference.onValue.listen((event) async {
      Map<dynamic, dynamic> dataMap = event.snapshot.value;

      if (dataMap == null) {
        orderList = [];
        return;
      }

      for (var key in dataMap.keys) {
        Order order = Order.fromJson(Map<String, dynamic>.from(dataMap[key]));
        if (order.orderId == orderI.orderId){
          orderId = key.toString();
          DatabaseReference productRef =
          FirebaseDatabase.instance.ref().child('orders').child(orderId);
          orderI.status = dropdownValue;
          await productRef.set(orderI.toJson());
        }
      }
    });

    // Show a success message and navigate back to the product list page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product updated')),
    );
    Navigator.pop(context);
  }
  // Define a function to edit a product

  @override
  Widget build(BuildContext context) {
    Order order = widget.order;
    _cart = order.cart;
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Details'),
          backgroundColor: AppColor.primary,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    SizedBox(height: 16),
                    Text('Order Items'),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _cart.length,
                      itemBuilder: (context, index) {
                        return ListTile(

                          title: Text(_cart[index].name),
                          subtitle: Text(_cart[index].price.toString()+'\$'),
                          onTap: () {
                            // TODO: Implement color editing
                          },
                        );
                      },
                    ),

                    SizedBox(height: 8),
                    Text('Order Status'),
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;

                        });
                        _status = newValue;
                      },

                      items: <String>['pending', 'confirmed', 'delivered']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement color adding
                        editOrder(context, order);

                      },
                      child: Text('Update Status'),
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.primary, // Change the color here
                      ),
                    ),


                  ]
              ),

            ),
          ),
        )
    );
  }

}