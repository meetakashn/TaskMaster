import 'package:sqflite/sqflite.dart';

import '../db_helper/database_connection.dart';

class Repository{
  late DatabaseConnection _databaseConnection;
  Repository(){
    _databaseConnection =DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async{
         if(_database!=null){
               return _database;
         }
         else{
           _database=await _databaseConnection.setDatabase();
           return _database;
         }
  }
  insertData(table,data)async{
    var connection=await database;
    return await connection?.insert(table, data);
  }
  readData(table)async{
    var connection=await database;
    return await connection?.query(table);
  }
  // read single data by id
  readDataById(table,userId)async{
    var connection=await database;
    return await connection?.query(table,where: 'id=?',whereArgs: [userId]);
  }
  //update
  updateData(table,data)async{
    var connection=await database;
    return await connection?.update(table ,data, where: 'id=?',whereArgs: [data['id']]);
  }
  // delete by id
  deleteDataById(table,itemId)async{
    var connection=await database;
    return await connection?.rawDelete('delete from $table where id=$itemId');
  }
  deleteData(table)async{
    var connection=await database;
    return await connection?.delete(table);
  }


}