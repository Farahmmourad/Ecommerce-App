import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../views/screens/login_page.dart';

class SideBar extends StatelessWidget {
  final Function(int) onOptionSelected;

   SideBar({Key key,  this.onOptionSelected}) : super(key: key);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          // DrawerHeader(
          //   child: Text('Bar'),
          //   decoration: BoxDecoration(
          //     color: AppColor.primary,
          //   ),
          // ),
          ListTile(
            title: Text('Products'),
            onTap: () => onOptionSelected(1),
          ),
          ListTile(
            title: Text('Orders'),
            onTap: () => onOptionSelected(2),
          ),
          ListTile(
            title: Text('Categories'),
            onTap: () => onOptionSelected(3),
          ),
          ListTile(
            title: Text('LogOut'),
            onTap: () => {
              signOut(),
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()))
            }
          ),
        ],
      ),
    );
  }
}