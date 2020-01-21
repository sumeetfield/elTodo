import 'package:flutter/material.dart';
import 'package:sidedrawer/models/todo.dart';
import 'package:sidedrawer/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:sidedrawer/services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen({Key key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var todoTitle = TextEditingController();

  var todoDescription = TextEditingController();

  var todoDate = TextEditingController();

  var _categories = List<DropdownMenuItem>();

  var _todoService = TodoService();

  var _selectedValue;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.getCategory();
    categories.forEach((category) {
      _categories.add(DropdownMenuItem(
        child: Text(category['name']),
        value: category['id'],
      ));
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectTodoDate(BuildContext context) async {
    var pickeddate = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        initialDate: _dateTime,
        lastDate: DateTime(2099));
    if (pickeddate != null) {
      setState(() {
        _dateTime = pickeddate;
        todoDate.text = DateFormat('yyyy-MM-dd').format(pickeddate);
      });
    }
    return pickeddate;
  }

  _showSnackbarBar(message) async {
    var _snackbar = SnackBar(
      content: message,
    );
    _scaffoldkey.currentState.showSnackBar(_snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: todoTitle,
              decoration: InputDecoration(
                  hintText: 'Enter Todo Title', labelText: 'Cook Food'),
            ),
            TextField(
              maxLines: 3,
              controller: todoDescription,
              decoration: InputDecoration(
                  hintText: 'Enter Todo Description', labelText: 'Before am'),
            ),
            TextField(
              controller: todoDate,
              decoration: InputDecoration(
                hintText: 'YY-MM-DD',
                labelText: 'YY-MM-DD',
                prefixIcon: InkWell(
                  onTap: () {
                    _selectTodoDate(context);
                  },
                  child: Icon(Icons.calendar_today),
                ),
              ),
            ),
            DropdownButtonFormField(
              value: _selectedValue,
              hint: Text('Select One Category'),
              items: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            FlatButton(
              child: Text('Save'),
              onPressed: () async {
                var todoObj = Todo();
                todoObj.title = todoTitle.text;
                todoObj.description = todoDescription.text;
                todoObj.todoDate = todoDate.text;
                todoObj.category = _selectedValue.text;
                todoObj.isFinished = 0;
                var result = await _todoService.saveTodo(todoObj);
                print(result);
                if (result > 0) {
                  _showSnackbarBar('Success');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
