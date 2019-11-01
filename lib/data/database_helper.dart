import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:todo_app/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();

  static Database _db;

  final List<String> initScripts = [
    '''
    CREATE TABLE users(
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL
    );
    '''
  ];

  List<String> migrationScripts = [];

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
    var theDb = await openDatabase(path, version: version, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }

  void _onCreate(Database db, int version) async{
    initScripts.forEach((script) async => await db.execute(script));
    // await db.execute("CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)");
    print("Created tables");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async{
    print('oldVersion: ' + oldVersion.toString());
    print('newVersion: ' + newVersion.toString());
    for (var i = oldVersion - 1; i< newVersion - 1; i++){
      print('migrationScripts[i] => ' + i.toString());
      await db.execute(migrationScripts[i]);
    }
  }

  Future<int> saveUser(User user) async{
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<User> getFirstUser() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM User");
    if (list.isNotEmpty){
      var element = list.elementAt(0);
      return new User(element["username"],element["password"]);
    } else{
      return null;
    }
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0 ? true: false;
  }

}