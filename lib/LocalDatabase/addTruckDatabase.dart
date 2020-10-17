import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class FoodTruckDatabaseHelper {
  static final _databaseName = "FoodTruckDatabase.db";
  static final _databaseVersion = 1;
  static final offlineFoodTruck = 'offlineFoodTruck';

  static final colIndex = "colIndex";
  static final foodType = "foodType";
  static final foodDetails = "foodDetails";
  static final latitude = "latitude";
  static final longitude = "longitude";
  static final openTime = "openTime";
  static final closeTime = "closeTime";
  static final address = "address";

  // make this a singleton class
  FoodTruckDatabaseHelper._privateConstructor();
  static final FoodTruckDatabaseHelper instance = FoodTruckDatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE offlineFoodTruck (
        $colIndex INTEGER PRIMARY KEY AUTOINCREMENT,
        $foodType TEXT NOT NULL,
        $foodDetails TEXT,
        $latitude TEXT,
        $longitude TEXT,
        $openTime TEXT,
        $closeTime TEXT,
        $address TEXT
    )''');
  }

  //------------------  Food Truck  ------------------------------

  Future<int> insertFoodTruck(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(offlineFoodTruck, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsFoodTruck() async {
    Database db = await instance.database;
    return await db.query(offlineFoodTruck);
  }

  Future<int> queryRowCountFoodTruck() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $offlineFoodTruck'));
  }

  Future<int> updateFoodTruck(Map<String, dynamic> row, int colId) async {
    Database db = await instance.database;
    int id = row[colId];
    return await db.update(offlineFoodTruck, row, where: '$colId = ?', whereArgs: [id]);
  }

  Future<void> deleteRowFoodTruck(int colId) async {
    Database db = await instance.database;
    return await db.rawDelete('DELETE FROM $offlineFoodTruck WHERE $colIndex = ?', [colId]);
  }
}