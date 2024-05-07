import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseConnection{
  Future<Database> setDatabase() async {
    var databaseDirectory = await getApplicationDocumentsDirectory();
    var path=join(databaseDirectory.path,'taskmaster.db');
    var database= await openDatabase(path,version: 1,onCreate: _createDatabase);
    return database;
  }
  Future<void> _createDatabase(Database database,int version)async{
   String sql=" CREATE TABLE Tasks ( id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT NOT NULL,description TEXT,dateTime TEXT,priority TEXT )";
   await database.execute(sql);
  }
}