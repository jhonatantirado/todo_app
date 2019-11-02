import 'package:sqflite/sqflite.dart';
import 'package:todo_app/assembler/user_assembler.dart';
import 'package:todo_app/model/user.dart';
import 'package:todo_app/data/database_helper.dart';
import 'package:todo_app/infraestructure/UserRepository.dart';

class SqfliteUserRepository implements UserRepository{
  final assembler = UserAssembler();

  DatabaseHelper databaseHelper;
  SqfliteUserRepository(this.databaseHelper);

  @override
  Future<int> insert(User user) async {
    final db = await databaseHelper.db;
    var id = await db.insert("User", user.toMap());
    return id;
  }

  @override
  Future<int> delete(User user) async{
    final db = await databaseHelper.db;
    var result = await db.delete("User", 
      where: "username=?", whereArgs: [user.username]);
    return result;
  }

  @override
  Future<int> update(User user) async{
    final db = await databaseHelper.db;
    var result = await db.update("User", user.toMap(),
      where: "username=?", whereArgs: [user.username]);
    return result;
  }

  @override
  Future<List<User>> getList() async{
    final db = await databaseHelper.db;
    var result = await db.rawQuery("SELECT * FROM User order by id ASC");
    List<User> users = assembler.fromList(result);
    return users;
  }

  Future<int> getCount() async{
    final db = await databaseHelper.db;
    var result = Sqflite.firstIntValue(
      await db.rawQuery("SELECT count(*) FROM User order"));
    return result;
  }

  // TODO: this should get the current user
  Future<User> getFirstUser() async{
    final db = await databaseHelper.db;
    List<Map> list = await db.rawQuery("SELECT * FROM User");
    if (list.isNotEmpty){
      var element = list.elementAt(0);
      return new User(element["username"],element["password"],element["email"]);
    } else{
      return null;
    }
  }

  Future<User> login(User user) async{
    final db = await databaseHelper.db;
    List<Map> result = await db.rawQuery("SELECT * FROM User where username=? and password=?",[user.username, user.password]);
    if (result.isNotEmpty){
      var element = result.elementAt(0);
      return new User(element["username"],element["password"],element["email"]);
    } else{
      return null;
    }
  }

}