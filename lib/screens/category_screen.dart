import 'package:flutter/material.dart';
import 'package:sidedrawer/models/category.dart';
import 'package:sidedrawer/screens/home_screen.dart';
import 'package:sidedrawer/services/category_service.dart'; //namespace

class Categoryscreen extends StatefulWidget {
  @override
  _CategoryscreenState createState() => _CategoryscreenState();
}

List<Category> _categoryList = List<Category>();

class _CategoryscreenState extends State<Categoryscreen> {
  var _categoryName = TextEditingController();
  var _categoryDescription = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  var _editcategoryName = TextEditingController();

  var _editcategoryDescription = TextEditingController();

  var category;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.getCategory();
    // loop through the variables using foreach
    categories.forEach((category) {
      setState(() {
        var model = Category();
        model.id = category['id'];
        model.description = category['description'];
        model.name = category['name'];
        _categoryList.add(model);
      });

      // sqlite insert and show data in map format
    });
  }

  _showforminDailog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (params) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                textColor: Colors.redAccent,
                onPressed: () {
                  _categoryName.text = '';
                  _categoryDescription.text = '';

                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              FlatButton(
                textColor: Colors.redAccent,
                onPressed: () async {
                  // print('Category Name : ${_categoryName.text}');
                  // print('Category Desciption : ${_categoryDescription.text}');
                  _category.name = _categoryName.text;
                  _category.description = _categoryDescription.text;
                  var result = await _categoryService.saveCategory(_category);
                  print(result);
                  _categoryName.text = '';
                  _categoryDescription.text = '';
                  if (result > 0) {
                    Navigator.pop(context);
                  }
                },
                child: Text("Save"),
              ),
            ],
            title: Text("Category form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryName,
                    decoration: InputDecoration(
                        labelText: 'Name', hintText: 'Write Category Name'),
                  ),
                  TextField(
                    controller: _categoryDescription,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Write Category Description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editCategoryDailog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (params) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                textColor: Colors.redAccent,
                onPressed: () {
                  _categoryName.text = '';
                  _categoryDescription.text = '';

                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              FlatButton(
                textColor: Colors.redAccent,
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _editcategoryName.text ?? 'No Name';
                  _category.description =
                      _editcategoryDescription.text ?? 'No description';
                  await _categoryService.updateCategory(_category);

                  Navigator.pop(context);
                  getAllCategories();
                  _showSnackbarBar(Text('Successfully Updated'));
                  _categoryName.text = '';
                  _categoryDescription.text = '';
                },
                child: Text("Update"),
              ),
            ],
            title: Text("Category Edit form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editcategoryName,
                    decoration: InputDecoration(
                        labelText: 'Name', hintText: 'Write Category Name'),
                  ),
                  TextField(
                    controller: _editcategoryDescription,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Write Category Description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // getting the category data and assigning the data to category dialog
  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.getCategoryById(categoryId);
    setState(() {
      _editcategoryName.text = category[0]['name'] ?? 'No name';
      _editcategoryDescription.text =
          category[0]['description'] ?? 'No Description';
    });

    _editCategoryDailog(context);
  }

  _showSnackbarBar(message) {
    var _snackbar = SnackBar(
      content: message,
    );
    _scaffoldkey.currentState.showSnackBar(_snackbar);
  }

  _deleteCategoryDailog(BuildContext context,categoryid) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (params) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
                color: Colors.greenAccent,
                
              ),
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () async {
                 await _categoryService.deleteCategory(categoryid);
                 Navigator.pop(context);
                  getAllCategories();
                  _showSnackbarBar(Text('Successfully Deleted'));
                },
                child: Text("Delete"),
              ),
            ],
            title: Text("Are you sure , you want to delete"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homescreen()),
            );
          },
          elevation: 0.0,
          color: Colors.red,
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text("Todo app"),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: IconButton(
                onPressed: () {
                  _editCategory(context, _categoryList[index].id);
                },
                icon: Icon(Icons.edit),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_categoryList[index].name),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteCategoryDailog(context,_categoryList[index].id);
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showforminDailog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
