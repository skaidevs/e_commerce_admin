import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/db/category.dart';
import 'package:e_commerce_admin/db/brand.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';

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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  List<String> selectedSizes = <String>[];

  String _currentCategory;
  String _currentBrand;

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
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      onPressed: () {},
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.8), width: 1.0),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(14.0, 60.0, 14.0, 60.0),
                        child: Icon(
                          Icons.add,
                          color: grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      onPressed: () {},
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.8), width: 1.0),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(14.0, 60.0, 14.0, 60.0),
                        child: Icon(
                          Icons.add,
                          color: grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      onPressed: () {},
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.8), width: 1.0),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(14.0, 60.0, 14.0, 60.0),
                        child: Icon(
                          Icons.add,
                          color: grey,
                        ),
                      ),
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
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(hintText: 'Product name'),
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
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: productNameController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Quantity'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "You must enter the product name";
                  }
                  return null;
                },
              ),
            ),
            Text('Available Sizes'),
            Row(
              children: <Widget>[
                Checkbox(
                  value: selectedSizes.contains('XS'),
                ),
                Text('XS'),
                Checkbox(value: false, onChanged: null),
                Text('S'),
                Checkbox(value: false, onChanged: null),
                Text('M'),
                Checkbox(value: false, onChanged: null),
                Text('L'),
                Checkbox(value: false, onChanged: null),
                Text('XL'),
                Checkbox(value: false, onChanged: null),
                Text('XXL'),
              ],
            ),

            Row(
              children: <Widget>[
                Checkbox(value: false, onChanged: null),
                Text('28'),
                Checkbox(value: false, onChanged: null),
                Text('30'),
                Checkbox(value: false, onChanged: null),
                Text('32'),
                Checkbox(value: false, onChanged: null),
                Text('34'),
                Checkbox(value: false, onChanged: null),
                Text('36'),
                Checkbox(value: false, onChanged: null),
                Text('38'),
              ],
            ),

            Row(
              children: <Widget>[
                Checkbox(value: false, onChanged: null),
                Text('40'),
                Checkbox(value: false, onChanged: null),
                Text('42'),
                Checkbox(value: false, onChanged: null),
                Text('44'),
                Checkbox(value: false, onChanged: null),
                Text('46'),
                Checkbox(value: false, onChanged: null),
                Text('50'),
                Checkbox(value: false, onChanged: null),
                Text('51'),
              ],
            ),

            FlatButton(
              onPressed: () {},
              child: Text('add product'),
              textColor: white,
              color: blue,
            ),
          ],
        ),
      ),
    );
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

  void changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      selectedSizes.remove(size);
    } else {
      selectedSizes.add(size);
    }
  }
}
