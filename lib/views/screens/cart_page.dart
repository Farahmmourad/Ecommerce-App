import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketky/constant/app_color.dart';
import 'package:marketky/core/model/Cart.dart';
import 'package:marketky/core/services/CartService.dart';
import 'package:marketky/views/screens/order_success_page.dart';
import 'package:marketky/views/widgets/cart_tile.dart';

class CartPage extends StatefulWidget {
  // final dynamic cartDataList;
  // CartPage({@required this.cartDataList});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // List<Cart> cartData = CartService.cartData;
//add data from db with where condition on the email

  String email = FirebaseAuth.instance.currentUser.email;
  // final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('orders');
  // List<dynamic> cartDataList2 = [];
  // dynamic totalPrice = 0;

  final DatabaseReference databaseReferenceOrders = FirebaseDatabase.instance.ref().child('orders');
  // String email = FirebaseAuth.instance.currentUser.email;
  int totalItemsInCart = 0;
  bool isEmpty = true;
  dynamic cartDataList = [];
  dynamic totalPrice = 0;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // set initial values for the text fields
    // _nameController.text = 'Type your name ...';
    // _addressController.text = 'Type your location ...';
    // _phoneNumberController.text = 'Type your phone number ...';

    databaseReferenceOrders.onValue.listen((event) {
      totalItemsInCart = 0;
      totalPrice = 0;

      setState(() {
        cartDataList = event.snapshot.value;
        dynamic listofproducts = [];

        if (cartDataList != null) {
          cartDataList.forEach((key, value) {
            if (value['email'] == email && value['active'] == true) {
              listofproducts = value['cart'];
              if(listofproducts != null) {
                isEmpty = false;
              }
            }
          });
        }

        List<Map<String, Object>> mappedList = [];
        for (var item in listofproducts) {
          Map<String, Object> mappedItem = Map<String, Object>.from(item);
          // if(mappedList.remove(item))
          mappedList.add(mappedItem);
        }
        List<Cart> cardsItem = mappedList.map((data) => Cart.fromJson(data)).toList();

        cardsItem.removeWhere((item) => item.count == 0);

        for (var item in cardsItem) {
          totalPrice = totalPrice + item.count * item.price;
          totalItemsInCart = totalItemsInCart + item.count;
        }

        cartDataList = cardsItem;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text('Your Cart',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            Text('$totalItemsInCart Items',
                style: TextStyle(
                    fontSize: 10, color: Colors.black.withOpacity(0.7))),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColor.primarySoft,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      // Checkout Button
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColor.border, width: 1))),
        child: ElevatedButton(
          onPressed: () {

            if (_nameController.text.isEmpty || _addressController.text.isEmpty || _phoneNumberController.text.isEmpty) {
              // Show an error message to the user indicating that all fields are required
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please fill all the required fields')),
              );
            } else {
              // Call the checkoutCart function and navigate to the OrderSuccessPage
              checkoutCart(email, _nameController.text, _addressController.text, _phoneNumberController.text, DateTime.now().toString());
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => OrderSuccessPage()));
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 6,
                child: Text(
                  'Checkout',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: 'poppins'),
                ),
              ),
              Container(
                width: 2,
                height: 26,
                color: Colors.white.withOpacity(0.5),
              ),
              Flexible(
                flex: 6,
                child: Text(
                  '\$${totalPrice.toString()}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: 'poppins'),
                ),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
            backgroundColor: AppColor.primary,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CartTile(
                data: cartDataList[index],
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 16),
            itemCount: cartDataList.length,
          ),
          // Section 2 - Shipping Information
          Container(
            margin: EdgeInsets.only(top: 24),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: AppColor.primarySoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.border, width: 1),
            ),
            child: Column(
              children: [
                // header
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shipping information',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            color: AppColor.secondary),
                      ),
                    ],
                  ),
                ),
                // Name
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        child: SvgPicture.asset('assets/icons/Profile.svg',
                            width: 18),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Type your name *',
                            hintStyle: TextStyle(color: AppColor.secondary.withOpacity(0.7)),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: AppColor.secondary.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Address
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12, top:13),
                        child: SvgPicture.asset('assets/icons/Home.svg',
                            width: 18),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintText: 'Type your address *',
                            hintStyle: TextStyle(color: AppColor.secondary.withOpacity(0.7)),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: AppColor.secondary.withOpacity(0.7),
                          ),
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ),
                // Phone Number
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12, top:13),
                        child: SvgPicture.asset('assets/icons/Call.svg',
                            width: 18),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            hintText: 'Type your phone number *',
                            hintStyle: TextStyle(color: AppColor.secondary.withOpacity(0.7)),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: AppColor.secondary.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Section 3 - Select Shipping method
          Container(
            margin: EdgeInsets.only(top: 24),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.border, width: 1),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColor.primarySoft,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  // Content
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pay cash on delivery',
                              style: TextStyle(
                                  color: AppColor.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'poppins')),
                          Text('Free delivery',
                              style: TextStyle(
                                  color: AppColor.secondary.withOpacity(0.7),
                                  fontSize: 10)),
                        ],
                      ),
                      // Text('free delivery',
                      //     style: TextStyle(
                      //         color: AppColor.primary,
                      //         fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Shipping',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.secondary),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '3-5 Days',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor.secondary.withOpacity(0.7)),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Subtotal',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.secondary),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '$totalItemsInCart Items',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor.secondary.withOpacity(0.7)),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '\$${totalPrice.toString()}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
