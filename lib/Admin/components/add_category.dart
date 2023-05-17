import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constant/app_color.dart';
import '../../core/model/ColorWay.dart';
import '../../core/model/Category.dart';
import '../../core/model/ProductSize.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  String _category = '';
  bool _featured = false;

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('categories');

  void addCategory(Category category) async {
    await databaseReference.push().set(category.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Category added')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Category'),
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

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a Category Name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _category = value;
                      },
                    ),

                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Category newCategory = new Category(name: _category, iconUrl: 'assets/icons/Category.svg', featured: _featured);
                          addCategory(newCategory);
                        }
                      },
                      child: Text('Add Category'),
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