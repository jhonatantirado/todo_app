import 'package:flutter/material.dart';
import 'package:todo_app/model/user.dart';
import 'package:todo_app/screen/home/home_screen_presenter.dart';
import 'package:todo_app/common/app_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/screen/user/user_list_page.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> implements HomeScreenContract{
  HomeScreenPresenter _presenter;
  String _homeText;
  Widget content = UserListPage();

  HomeScreenState(){
    _presenter = new HomeScreenPresenter(this);
    _presenter.getUserInfo();
  }

  @override
  Widget build(BuildContext context){
    return  Scaffold(
      drawer: Drawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.preferredSize),
        child: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text( 
            _homeText !=null?_homeText:AppConstants.appBarTitle,
            style: TextStyle(
              fontSize: AppConstants.fontSize,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(FontAwesomeIcons.userCog, size: AppConstants.iconSize),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: <Widget>[
            InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(FontAwesomeIcons.solidBell,
                    size: AppConstants.iconSize, color: Colors.white),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body:  content
    );
  }

  @override
  void onDisplayUserInfo(User user){
    setState(() {
      _homeText = 'Hello ${user.username}';
    });
  }

  @override
  void onErrorUserInfo(){
    setState(() {
      _homeText = 'There was an error retrieving the information';
    });
  }


}