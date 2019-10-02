import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/db/category.dart';
import 'package:e_commerce_admin/db/brand.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;

  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];

  String _currentCategory = "test";
  String _currentBrand;

  @override
  void initState() {
    _getCategories();
//    _getBrands();
    categoriesDropDown = getCategoriesDropDown();
    if (_currentCategory.isEmpty) {
      _currentCategory = categoriesDropDown[0].value;
    }
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      items.insert(
        0,
        DropdownMenuItem(
          child: Text(categories[i]['category']),
          value: categories[i]['category'],
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: Icon(
          Icons.close,
          color: black,
        ),
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
                            const EdgeInsets.fromLTRB(14.0, 40.0, 14.0, 40.0),
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
                            const EdgeInsets.fromLTRB(14.0, 40.0, 14.0, 40.0),
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
                            const EdgeInsets.fromLTRB(14.0, 40.0, 14.0, 40.0),
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
            Expanded(
              child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(categories[index]['category']),
                    );
                  }),
            ),

//            Center(
//              child: DropdownButton(
//                items: categoriesDropDown,
//                onChanged: changeSelectCategory,
//                value: _currentCategory,
//              ),
//            ),
          ],
        ),
      ),
    );
  }

  void _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
    });
  }

  changeSelectCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }
}
