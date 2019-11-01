import 'package:todo_app/model/user.dart';
import 'package:todo_app/data/database_helper.dart';

abstract class HomeScreenContract {
  void onDisplayUserInfo(User user);
  void onErrorUserInfo();
}

class HomeScreenPresenter{
  HomeScreenContract _view;
  DatabaseHelper databaseHelper = DatabaseHelper();

  HomeScreenPresenter(this._view);

  getUserInfo(){
    databaseHelper.getFirstUser().then((User user)
    {
      _view.onDisplayUserInfo(user);
    }).catchError((Object error) {
      _view.onErrorUserInfo();
    });
    }
}