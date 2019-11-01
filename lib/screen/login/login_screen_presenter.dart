import 'package:todo_app/model/user.dart';
import 'package:todo_app/data/database_helper.dart';
import 'package:todo_app/data/rest_ds.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) async {
    api.login(username, password).then((User user) {
      processLoginSuccess(user);
    }).catchError((Object error) => _view.onLoginError(error.toString()));
  }

  void processLoginSuccess(User user) async {
      var db = new DatabaseHelper();
      await db.saveUser(user);
      _view.onLoginSuccess(user);
  }
}