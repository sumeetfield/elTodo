import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_drawer');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreateDatabase);
    return database;
  }

  _onCreateDatabase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE categories(id Integer PRIMARY KEY,name TEXT,description TEXT)");
    await db.execute(
        "CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT, "
        "category TEXT, todoDate TEXT, isFinished INTEGER)");
  }
}
