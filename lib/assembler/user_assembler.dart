import 'package:todo_app/assembler/assembler.dart';
import 'package:todo_app/model/user.dart';

class UserAssembler implements Assembler<User>{
  final tableName= 'User';
  final columnId = 'id';
  final columnName = 'username';
  final columnPassword = 'password';

  @override
  User fromMap(Map<String, dynamic > query) {
    User user = User(query[columnName],query[columnPassword]);
    return user;
  }

  @override
  Map<String, dynamic> toMap(User user) {
    return <String, dynamic>{
      columnName: user.username,
      columnPassword: user.password
    };
  }

  User fromDbRow(dynamic row){
    return User.withId(row[columnId],row[columnName],row[columnPassword]);
  }

  @override
  List<User> fromList(result) {
    List<User> users = List<User>();
    var count = result.length;
    for (int i=0; i<count;i++){
      users.add(fromDbRow(result[i]));
    }
    return users;
  }
}