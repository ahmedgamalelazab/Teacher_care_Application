// this file will record the auth data in the internal storage of our application

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

//section of internalStorage database mapping

Map<String, String> internalStorageMap = {
  'authDataBase': 'authDB.db',
  'authTable': 'AuthTable',
  'authTableId': 'id',
  'authUserId': 'userId',
  'authUserToken': 'userToken',
  'user_role': 'user_role',
  'onBoardTable': 'onBoardTable',
  'onBoardTable_id': 'id',
  'onBoardTable_onBoard': 'onBoard',
};

//this internal storage database will be connected with somehow with repository to allow me to use this database from whole entire application
class AuthInternalStorageDataBaseHelper {
  //the constructor will generate the initial state for this helper
  Database? db;

  Future<void> openDataBase() async {
    try {
      final applicationInternalStoragePath = await getDatabasesPath();
      final authInternalStorageDB = path.join(applicationInternalStoragePath,
          internalStorageMap['authDataBase'].toString());
      db = await openDatabase(authInternalStorageDB, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        //this pattern will create double tables in the same code
        await db.execute('''
        create table ${internalStorageMap['authTable']} ( 
          ${internalStorageMap['authTableId']} integer primary key autoincrement, 
          ${internalStorageMap['authUserId']} text not null,
          ${internalStorageMap['authUserToken']} text not null,
          ${internalStorageMap['user_role']} text not null)
      ''');
        await db.execute('''
        create table ${internalStorageMap['onBoardTable']} ( 
          ${internalStorageMap['onBoardTable_id']} integer primary key autoincrement, 
          ${internalStorageMap['onBoardTable_onBoard']} integer not null)       
      ''');
      });
      //if all run well i should see the code below
      print('data base Opened Successfully');
    } catch (error) {
      print(error);
      print('data base error');
    }
  }

  //section of api
  //this will expect data like the user id , and the user_token and it will try to fill the database with it
  Future<Map<String, dynamic>> insertInDB(Map<String, dynamic> data) async {
    try {
      final response =
          await db!.insert(internalStorageMap['authTable'].toString(), {
        internalStorageMap['authUserId'].toString(): data['user_id'],
        internalStorageMap['authUserToken'].toString(): data['user_token'],
        internalStorageMap['user_role'].toString(): data['user_role'],
      });
      //if all are ok
      return {"success": true, "data": response};
    } catch (error) {
      print(error);
      return {"success": false, "data": 'error in the data base or system!'};
    }
  }

  ///this function will initialize onBoard autoMatically
  Future<Map<String, dynamic>> initializeOnBoard() async {
    try {
      final internalResponse =
          await db!.insert(internalStorageMap['onBoardTable'].toString(), {
        internalStorageMap['onBoardTable_onBoard'].toString(): 1,
      });
      return {
        "success": true,
        "data": internalResponse,
      };
    } catch (error) {
      print(error);
      return {
        "success": false,
        "data": "error in internal data base while initializing the onBoard",
      };
    }
  }

  Future<dynamic> fetchOnBoardState() async {
    try {
      final response = await db!.query(
        internalStorageMap['onBoardTable'].toString(), // table
        columns: [
          internalStorageMap['onBoardTable_onBoard'].toString(),
        ],
      );
      return response;
    } catch (error) {
      print(error);
      return 'error in the local data base while fetching onBoardState';
    }
  }

  //this will close the db
  Future<void> closeDB() async {
    await db!.close();
  }

  Future<dynamic> fetchLocallyUserId(String userId) async {
    try {
      final response = await db!.query(
        internalStorageMap['authTable'].toString(), // table
        columns: [
          internalStorageMap['authUserId'].toString(),
          internalStorageMap['authUserToken'].toString(),
          internalStorageMap['user_role'].toString()
        ],
        where: '${internalStorageMap['authUserId']} = ?',
        whereArgs: [userId],
      );
      return response;
    } catch (error) {
      print(error);
      return 'error in the local data base while fetching the user token';
    }
  }
}
