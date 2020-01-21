import 'package:flutter/material.dart';
import 'package:sidedrawer/screens/category_screen.dart';
import 'package:sidedrawer/screens/home_screen.dart';

class NavigationMenu extends StatefulWidget {
  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.85,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Todo app"),
            accountEmail: Text("Category & Priority based todo app"),
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homescreen()),
              );
            },
          ),
          ListTile(
            title: Text("Category"),
            leading: Icon(Icons.category),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Categoryscreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
