import 'package:flutter/material.dart';

import '../../constant/app_color.dart';

class SideBar extends StatelessWidget {
  final Function(int) onOptionSelected;

  const SideBar({Key key,  this.onOptionSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Bar'),
            decoration: BoxDecoration(
              color: AppColor.primary,
            ),
          ),
          ListTile(
            title: Text('Products'),
            onTap: () => onOptionSelected(1),
          ),
          ListTile(
            title: Text('Orders'),
            onTap: () => onOptionSelected(2),
          ),
          ListTile(
            title: Text('LogOut'),
            onTap: () => onOptionSelected(3),
          ),
        ],
      ),
    );
  }
}