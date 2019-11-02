import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/infraestructure/Sqflite_UserRepository.dart';
import 'package:todo_app/data/database_helper.dart';
import 'package:todo_app/model/user.dart';

SqfliteUserRepository userRepository =
    SqfliteUserRepository(DatabaseHelper.get);
final List<String> choices = const <String>[
  'Save User & Back',
  'Delete User',
  'Back to List'
];

const mnuSave = 'Save User & Back';
const mnuDelete = 'Delete User';
const mnuBack = 'Back to List';

class UserDetailPage extends StatefulWidget {
  final User user;
  UserDetailPage(this.user);

  @override
  State<StatefulWidget> createState() => UserDetailPageState(user);
}

class UserDetailPageState extends State<UserDetailPage> {
  final _formKey = GlobalKey<FormState>();
  User user;
  UserDetailPageState(this.user);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(this.user.username),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _showNameInput(textStyle, this.user.username),
                    _showEmailInput(textStyle, this.user.email),
                    _showPasswordInput(textStyle, this.user.password)
                  ],
                ))));
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        submit();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (user.id == null) {
          return;
        }
        result = await userRepository.delete(user);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete User"),
            content: Text("The User has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      save();
    }
  }

  void save() {
    if (user.id != null) {
      debugPrint('update');
      userRepository.update(user);
    } else {
      debugPrint('insert');
      userRepository.insert(user);
    }
    Navigator.pop(context, true);
  }

  Widget _showEmailInput(TextStyle textStyle, String initialValue) {
    return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: TextFormField(
          style: textStyle,
          initialValue: initialValue,
          keyboardType: TextInputType.emailAddress,
          onSaved: (val) => user.email = val,
          validator: (val) => !EmailValidator.validate(val) ? 'This is an Invalid Email' : null,
          decoration: InputDecoration(
              labelText: "Email",
              labelStyle: textStyle,
              hintText: 'Enter a valid email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              )),
        ));
  }

  Widget _showNameInput(TextStyle textStyle, String initialValue) {
    return TextFormField(
      style: textStyle,
      initialValue: initialValue,
      onSaved: (val) => user.username = val,
      validator: (val) => val.length < 1 ? 'Username too short' : null,
      decoration: InputDecoration(
          labelText: "Name",
          labelStyle: textStyle,
          hintText: 'Enter name, min length 1',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          )),
    );
  }

    Widget _showPasswordInput(TextStyle textStyle, String initialValue) {
    return TextFormField(
      style: textStyle,
      initialValue: initialValue,
      onSaved: (val) => user.password = val,
      validator: (val) => val.length < 1 ? 'Password too short' : null,
      decoration: InputDecoration(
          labelText: "Password",
          labelStyle: textStyle,
          hintText: 'Enter password, min length 1',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          )),
    );
  }
}
