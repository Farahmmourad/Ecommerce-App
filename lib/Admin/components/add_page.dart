import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketky/core/model/Category.dart';
import '../../constant/app_color.dart';
import '../../core/model/ColorWay.dart';
import '../../core/model/Product.dart';
import '../../core/model/ProductSize.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _colorNameController = TextEditingController();
  final _colorTypeController = TextEditingController();
  final _sizeNameController = TextEditingController();
  final _sizeTypeController = TextEditingController();
  List<dynamic> _images = [];
  String _name = '';
  int _price = 0;
  String _description = '';
  List<ColorWay> _colors = [];
  List<ProductSize> _sizes = [];
  String _category = 'women shirts';
  ColorWay _newColor= new ColorWay(name: '', color: '');

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('products');
  final DatabaseReference databaseCategoryReference = FirebaseDatabase.instance.ref().child('categories');

  List<Category> categoryList = [];
  void addProduct(Product product) async {
    await databaseReference.push().set(product.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product added')),
    );
    Navigator.pop(context);
  }
  final ImagePicker _picker = ImagePicker();
  XFile _pickedFile;
  String imageUrl;

  void _pickImage() async {
    _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    print('${_pickedFile?.path}');
    if(_pickedFile == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference refrenceRoot = FirebaseStorage.instance.ref();
    Reference refrenceDirImage = refrenceRoot.child('images');
    Reference refrenceImageToUpload = refrenceDirImage.child(uniqueFileName);
    try{
      await refrenceImageToUpload.putFile(File(_pickedFile.path));
      imageUrl = await refrenceImageToUpload.getDownloadURL();

      setState(() {
        _images.add(imageUrl);
      });
    }
    catch(error){
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseCategoryReference.onValue.listen((event) {
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
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
        title: Text('Add Product'),
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
                if (_pickedFile != null)
                  Image.file(File(_pickedFile.path))
                else
                  Text('No image selected'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Select Image'),
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary, // Change the color here
                  ),
                ),
            TextFormField(
            decoration: InputDecoration(
            labelText: 'Name',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onSaved: (value) {
              _name = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Price',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a price';
              }
              return null;
            },
            onSaved: (value) {
              _price = int.parse(value);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            maxLines: 3,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            onSaved: (value) {
              _description = value;
            },
          ),
                SizedBox(height: 16),
                Text('Category'),
                DropdownButton<String>(

                  value: _category,
                  onChanged: (newValue) {
                    setState(() {
                      _category = newValue;
                    });
                  },
                  items: categoryList.map((option) {
                    return DropdownMenuItem(
                      value: option.name,
                      child: Text(option.name),
                    );
                  }).toList(),
                ),
          //   TextFormField(
          //   decoration: InputDecoration(
          //     labelText: 'Category',
          //   ),
          //   validator: (value) {
          //     if (value.isEmpty) {
          //       return 'Please enter a category';
          //     }
          //     return null;
          //   },
          //   onSaved: (value) {
          //     _category = value;
          //   },
          // ),
          SizedBox(height: 16),
          Text('Colors'),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _colors.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_colors[index].name),
                subtitle: Text(_colors[index].color.toString()),
                onTap: () {
                  // TODO: Implement color editing
                },
              );
            },
          ),
              TextFormField(
                controller: _colorNameController,
                decoration: InputDecoration(
                  labelText: 'Color Name',
                ),
                maxLines: 3,
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return 'Please enter a color name';
                //   }
                //   return null;
                // },
              ),

                TextFormField(
                  controller: _colorTypeController,
                  decoration: InputDecoration(
                    labelText: 'Color Code',
                  ),
                  maxLines: 3,
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Please enter a color code';
                  //   }
                  //   return null;
                  // },

                ),

              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                // TODO: Implement color adding
                  setState(() {
                    _colors.add(
                      ColorWay(name: _colorNameController.text, color: _colorTypeController.text)
                    );
                  });

                },
                child: Text('Add Color'),
                style: ElevatedButton.styleFrom(
                  primary: AppColor.primary, // Change the color here
                ),
              ),

                SizedBox(height: 16),
                Text('Sizes'),
                SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _sizes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_sizes[index].size),
                      onTap: () {
                        // TODO: Implement color editing
                      },
                    );
                  },
                ),


                TextFormField(
                  controller: _sizeTypeController,
                  decoration: InputDecoration(
                    labelText: 'Size number',
                  ),
                  maxLines: 3,
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Please enter a size number';
                  //   }
                  //   return null;
                  // },

                ),

                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement color adding
                    setState(() {
                      _sizes.add(
                          ProductSize(name: _sizeTypeController.text, size: _sizeTypeController.text)
                      );
                    });

                  },
                  child: Text('Add Size'),
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary, // Change the color here
                  ),
                ),

                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Product newProduct = Product(
                        name: _name,
                        price: _price,
                        category: _category,
                        description: _description,
                        colors: _colors,
                        sizes: _sizes,
                        image: _images,
                        reviews: [],
                      );
                      addProduct(newProduct);
                    }
                  },
                  child: Text('Add Product'),
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