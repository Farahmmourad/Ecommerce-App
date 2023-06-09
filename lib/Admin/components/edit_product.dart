import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constant/app_color.dart';
import '../../core/model/Category.dart';
import '../../core/model/ColorWay.dart';
import '../../core/model/Product.dart';
import '../../core/model/ProductSize.dart';
import '../../core/model/Review.dart';

class EditPage extends StatefulWidget {
  final Product product;
  EditPage({@required this.product});
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

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
  String _category = '';
  String productId = '';

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('products');
  final DatabaseReference databaseCategoryReference = FirebaseDatabase.instance.ref().child('categories');

  List<Category> categoryList = [];
  List<Product> productList = [];

  @override
  void initState() {
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
  // Define a function to edit a product
  void editProduct(BuildContext context, Product product)  {
    // Navigate to the edit product page and get the updated product data
    databaseReference.once().then((DatabaseEvent event) async {
      Map<dynamic, dynamic> dataMap = event.snapshot.value;

      if (dataMap == null) {
        productList = [];
        return;
      }

      for (var key in dataMap.keys) {
        Product product1 = Product.fromJson(Map<String, dynamic>.from(dataMap[key]));
        if (product1.name == product.name) {
          String productId = key.toString();
          DatabaseReference productRef =
          databaseReference.child(productId);
          await productRef.set(product.toJson());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product updated')),
          );
          return;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product not found')),
      );
    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    _colors = product.colors;
    _sizes = product.sizes;


    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
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
                      initialValue: '${product.name}',
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
                      initialValue: '${product.price}',
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
                      initialValue: '${product.description}',
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
                    Text('Category'),
                    DropdownButton<String>(
                      value:_category == '' ? product.category :_category ,
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
                          for (var image in product.image){
                            _images.add(image);
                          }
                          Product newProduct = Product(
                            name: _name,
                            price: _price,
                            category: _category,
                            description: _description,
                            colors: _colors,
                            sizes: _sizes,
                            image: _images,
                            reviews: product.reviews,
                          );
                          editProduct(context, newProduct);
                        }
                      },
                      child: Text('Edit Product'),
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