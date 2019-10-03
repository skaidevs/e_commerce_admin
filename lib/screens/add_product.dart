import 'dart:io';

import 'package:e_commerce_admin/db/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/db/category.dart';
import 'package:e_commerce_admin/db/brand.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  Color blue = Colors.blue;

  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService _productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  List<String> selectedSizes = <String>[];
  File _image1;
  File _image2;
  File _image3;

  String _currentCategory;
  String _currentBrand;
  bool isLoading = false;

  @override
  void initState() {
    _getCategories();
    _getBrands();
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
          0,
          DropdownMenuItem(
            child: Text(categories[i].data['category']),
            value: categories[i].data['category'],
          ),
        );
      });
    }

    return items;
  }

  List<DropdownMenuItem<String>> getBrandsDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        items.insert(
          0,
          DropdownMenuItem(
            child: Text(brands[i].data['brand']),
            value: brands[i].data['brand'],
          ),
        );
      });
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: black,
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            }),
        title: Text(
          "add product",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineButton(
                            onPressed: () {
                              _selectImage(
                                ImagePicker.pickImage(
                                    source: ImageSource.gallery),
                                1,
                              );
                            },
                            borderSide: BorderSide(
                                color: grey.withOpacity(0.8), width: 1.0),
                            child: _displayChild1(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineButton(
                            onPressed: () {
                              _selectImage(
                                ImagePicker.pickImage(
                                    source: ImageSource.gallery),
                                2,
                              );
                            },
                            borderSide: BorderSide(
                                color: grey.withOpacity(0.8), width: 1.0),
                            child: _displayChild2(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineButton(
                            onPressed: () {
                              _selectImage(
                                ImagePicker.pickImage(
                                    source: ImageSource.gallery),
                                3,
                              );
                            },
                            borderSide: BorderSide(
                                color: grey.withOpacity(0.8), width: 1.0),
                            child: _displayChild3(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'enter a product name with 10 characters as maximum',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: red,
                      fontSize: 12.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: productNameController,
                      decoration: InputDecoration(
                          hintText: 'enter product name',
                          labelText: 'Product Name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "You must enter the product name";
                        } else if (value.length > 10) {
                          return "Product name can't habe more than 10 letters";
                        }

                        return null;
                      },
                    ),
                  ),

                  //select category
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Category',
                            style: TextStyle(color: blue),
                          ),
                        ),
                        DropdownButton(
                          items: categoriesDropDown,
                          onChanged: changeSelectCategory,
                          value: _currentCategory,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Brand',
                            style: TextStyle(color: blue),
                          ),
                        ),
                        DropdownButton(
                          items: brandsDropDown,
                          onChanged: changeSelectBrand,
                          value: _currentBrand,
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'enter quantity', labelText: 'Quantity'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "You must enter the product name";
                        }
                        return null;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'enter price', labelText: 'Price'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "You must enter the product name";
                        }
                        return null;
                      },
                    ),
                  ),
                  Center(child: Text('Available Sizes')),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: selectedSizes.contains('XS'),
                        onChanged: (value) => changeSelectedSize('XS'),
                      ),
                      Text('XS'),
                      Checkbox(
                        value: selectedSizes.contains('S'),
                        onChanged: (value) => changeSelectedSize('S'),
                      ),
                      Text('S'),
                      Checkbox(
                        value: selectedSizes.contains('M'),
                        onChanged: (value) => changeSelectedSize('M'),
                      ),
                      Text('M'),
                      Checkbox(
                        value: selectedSizes.contains('L'),
                        onChanged: (value) => changeSelectedSize('L'),
                      ),
                      Text('L'),
                      Checkbox(
                        value: selectedSizes.contains('XL'),
                        onChanged: (value) => changeSelectedSize('XL'),
                      ),
                      Text('XL'),
                      Checkbox(
                        value: selectedSizes.contains('XXL'),
                        onChanged: (value) => changeSelectedSize('XXL'),
                      ),
                      Text('XXL'),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: selectedSizes.contains('28'),
                        onChanged: (value) => changeSelectedSize('28'),
                      ),
                      Text('28'),
                      Checkbox(
                        value: selectedSizes.contains('30'),
                        onChanged: (value) => changeSelectedSize('30'),
                      ),
                      Text('30'),
                      Checkbox(
                        value: selectedSizes.contains('32'),
                        onChanged: (value) => changeSelectedSize('32'),
                      ),
                      Text('32'),
                      Checkbox(
                        value: selectedSizes.contains('34'),
                        onChanged: (value) => changeSelectedSize('34'),
                      ),
                      Text('34'),
                      Checkbox(
                        value: selectedSizes.contains('36'),
                        onChanged: (value) => changeSelectedSize('36'),
                      ),
                      Text('36'),
                      Checkbox(
                        value: selectedSizes.contains('38'),
                        onChanged: (value) => changeSelectedSize('38'),
                      ),
                      Text('38'),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: selectedSizes.contains('40'),
                        onChanged: (value) => changeSelectedSize('40'),
                      ),
                      Text('40'),
                      Checkbox(
                        value: selectedSizes.contains('42'),
                        onChanged: (value) => changeSelectedSize('42'),
                      ),
                      Text('42'),
                      Checkbox(
                        value: selectedSizes.contains('44'),
                        onChanged: (value) => changeSelectedSize('44'),
                      ),
                      Text('44'),
                      Checkbox(
                        value: selectedSizes.contains('46'),
                        onChanged: (value) => changeSelectedSize('46'),
                      ),
                      Text('46'),
                      Checkbox(
                        value: selectedSizes.contains('48'),
                        onChanged: (value) => changeSelectedSize('48'),
                      ),
                      Text('48'),
                      Checkbox(
                        value: selectedSizes.contains('50'),
                        onChanged: (value) => changeSelectedSize('50'),
                      ),
                      Text('50'),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FlatButton(
                      onPressed: () async {
                        validateAndUpload(context);
                      },
                      child: Text('add product'),
                      textColor: white,
                      color: blue,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void validateAndUpload(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      if (_image1 != null && _image2 != null && _image3 != null) {
        if (selectedSizes.isNotEmpty) {
          String imageUrl1;
          String imageUrl2;
          String imageUrl3;

          final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
          final String picture1 =
              "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task1 =
              firebaseStorage.ref().child(picture1).putFile(_image1);
          final String picture2 =
              "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task2 =
              firebaseStorage.ref().child(picture2).putFile(_image2);
          final String picture3 =
              "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task3 =
              firebaseStorage.ref().child(picture3).putFile(_image3);
          StorageTaskSnapshot snapshot1 =
              await task1.onComplete.then((snapshot) => snapshot);
          StorageTaskSnapshot snapshot2 =
              await task2.onComplete.then((snapshot) => snapshot);

          task3.onComplete.then((snapshot3) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();
            imageUrl2 = await snapshot2.ref.getDownloadURL();
            imageUrl3 = await snapshot3.ref.getDownloadURL();
            List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];

            _productService.uploadProduct(
                productName: productNameController.text,
                price: double.parse(priceController.text),
                sizes: selectedSizes,
                images: imageList,
                brand: _currentBrand,
                category: _currentCategory,
                quantity: int.parse(quantityController.text));
            _formKey.currentState.reset();
            setState(() => isLoading = false);
            Fluttertoast.showToast(msg: 'Product added');
            Navigator.pop(context);
          });
        } else {
          setState(() => isLoading = false);
          Fluttertoast.showToast(msg: 'Select atleast one size');
        }
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: 'All the images must be provided');
      }
    }
  }

  void _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data['category'];
    });
  }

  void _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    setState(() {
      brands = data;
      brandsDropDown = getBrandsDropDown();
      _currentBrand = brands[0].data['brand'];
    });
  }

  changeSelectCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectBrand(String selectedBrand) {
    setState(() => _currentBrand = selectedBrand);
  }

  changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  //Get the file from the image picker and store it
  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        break;
      case 2:
        setState(() => _image2 = tempImg);
        break;
      case 3:
        setState(() => _image3 = tempImg);
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 60.0, 14.0, 60.0),
        child: Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 60.0, 14.0, 60.0),
        child: Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image2,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 60.0, 14.0, 60.0),
        child: Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image3,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }
}
