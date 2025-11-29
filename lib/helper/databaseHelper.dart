import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> getDatabase() async {
    _database ??= await initDb();

    return _database!;
  }

  Future<Database> initDb() async {
    var databasedirectory = await getDatabasesPath();
    var dbPath = join(databasedirectory, "expencedb.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) async {
      },
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE salesitems (id INTEGER PRIMARY KEY AUTOINCREMENT, sales_id INTEGER, productid INTEGER, quantity INTEGER, name TEXT, unitprice REAL, total REAL)"
        );
        await db.execute(
          "CREATE TABLE sales (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, complete_total REAL)",
        );
         db.execute(
          "CREATE TABLE inventory (id INTEGER PRIMARY KEY AUTOINCREMENT, productid INTEGER, quantity INTEGER)",
        );
        await db.execute(
          "CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY AUTOINCREMENT, icon TEXT, name TEXT, unitcost REAL, category TEXT, suplierdetails TEXT, description TEXT)",
        );
        await db.execute(
          "CREATE TABLE account (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT)",
        );
      },
    );
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    var db = await getDatabase();
    await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> selectWhere(
    String table,
    Map<String, dynamic> where,
  ) async {
    var db = await getDatabase();

    String whereClause = "";

    for (var key in where.keys) {
      whereClause += "$key = ? AND ";
    }

    whereClause = whereClause.substring(0, whereClause.length - 4);

    var data = await db.query(
      table,
      where: whereClause,
      whereArgs: where.values.toList(),
    );
    return data;
  }

  Future<List<Map<String, dynamic>>> select(String table) async {
    var db = await getDatabase();
    var data = await db.query(table);
    return data;
  }

  Future<String> getlastindex()async{
    var db = await getDatabase();
    var data = await db.rawQuery("SELECT last_insert_rowid()");
    return data.first["last_insert_rowid()"].toString();
  }

  Future<void> update(String table, Map<String, dynamic> values,
      Map<String, dynamic> where) async {
    var db = await getDatabase();
    String whereClause = "";

    for (var key in where.keys) {
      whereClause += "$key = ? AND ";
    }

    whereClause = whereClause.substring(0, whereClause.length - 4);

    await db.update(
      table, 
      values,
      where: whereClause, 
      whereArgs: where.values.toList());
  }


}
