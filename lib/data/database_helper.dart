import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static DatabaseHelper get = _instance;
  DatabaseHelper.internal();

  static Database _db;

  final List<String> initScripts = [
    '''
    CREATE TABLE User(
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      email TEXT NOT NULL
    );
    '''
  ];

  final List<String> initScriptsCourse = [
    '''
    CREATE TABLE courses(
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NULL,
      semester INTEGER NOT NULL,
      credits INTEGER NOT NULL,
      research INTEGER NOT NULL DEFAULT 0
    );
    '''
  ];

  List<String> migrationScripts = [];

  List<String> downgradeScripts = [];

  Future<Database> get db async{
    if (_db != null)
      return _db;
    
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    int version = migrationScripts.length <= 0 ? 1 : migrationScripts.length + 1;
    var theDb = await openDatabase(path, version: version, onCreate: _onCreate, 
    onUpgrade: _onUpgrade, onDowngrade: _onDowngrade);
    return theDb;
  }

  void _onCreate(Database db, int version) async{
    initScripts.forEach((script) async => await db.execute(script));
    initScriptsCourse.forEach((script) async => await db.execute(script));
    print("Created tables");
    await db.rawInsert('INSERT INTO User (username, password, email) VALUES("admin", "123456","admin@gmail.com")');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async{
    print('oldVersion: ' + oldVersion.toString());
    print('newVersion: ' + newVersion.toString());
    for (var i = oldVersion - 1; i< newVersion - 1; i++){
      print('migrationScripts[i] => ' + i.toString());
      await db.execute(migrationScripts[i]);
    }
  }

  void _onDowngrade(Database db, int currentVersion, int previousVersion) async{
    print('currentVersion: ' + currentVersion.toString());
    print('previousVersion: ' + previousVersion.toString());
    for (var i = currentVersion - 1; i> previousVersion - 1; i--){
      print('downgradeScripts[i] => ' + i.toString());
      await db.execute(downgradeScripts[i]);
    }
  }

}