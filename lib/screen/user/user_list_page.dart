import 'package:flutter/material.dart';
import 'package:todo_app/infraestructure/Sqflite_UserRepository.dart';
import 'package:todo_app/data/database_helper.dart';
import 'package:todo_app/model/user.dart';
import 'package:todo_app/screen/user/user_detail_page.dart';

class UserListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  SqfliteUserRepository userRepository = SqfliteUserRepository(DatabaseHelper.get);
  List<User> users;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (users == null) {
      users = List<User>();
      getData();
    }
    return Scaffold(
      body: userListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          navigateToDetail(User('','',''));
        }
        ,
        tooltip: "Add new User",
        child: new Icon(Icons.add),
      ),
    );
  }
  
  ListView userListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child:Text(this.users[position].id.toString()),
            ),
          title: Text(this.users[position].username),
          subtitle: Text(this.users[position].email.toString()),
          onTap: () {
            debugPrint("Tapped on " + this.users[position].id.toString());
            navigateToDetail(this.users[position]);
          },
          ),
        );
      },
    );
  }
  
  void getData() {
      print('Main Thread getData');
      final usersFuture = userRepository.getList();
      print('Main Thread getList ' + usersFuture.toString());
      usersFuture.then((userList) {
        print('Main Thread getList .then');
        setState(() {
          users = userList;
          count = userList.length;
        });
        debugPrint("Main Thread - Items: " + count.toString());
      });
  }

  void navigateToDetail(User user) async {
    bool result = await Navigator.push(context, 
        MaterialPageRoute(builder: (context) => UserDetailPage(user)),
    );
    if (result == true) {
      getData();
    }
  } 
}