
import 'package:flutter/material.dart';
import 'package:marketky/constant/app_color.dart';

import 'components/orders_page.dart';
import 'components/products_page.dart';
import 'components/sidebar.dart';

final Map<String, WidgetBuilder> routes = {
  '/products': (BuildContext context) => ProductsPage(),
  '/orders': (BuildContext context) => OrdersPage(),
};

class MainAdmin extends StatefulWidget {
  const MainAdmin({Key key}) : super(key: key);

  @override
  _MainAdminState createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  int _selectedOption = 1;

  void _onOptionSelected(int option) {
    setState(() {
      _selectedOption = option;
    });
    Navigator.pop(context);
  }

  Widget _getBody() {
    switch (_selectedOption) {
      case 1:
        return ProductsPage();
      case 2:
        return OrdersPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        backgroundColor: AppColor.primary,
      ),

      drawer: SideBar(onOptionSelected: _onOptionSelected),
      body: _getBody(),
    );
  }
}




