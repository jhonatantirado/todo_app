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
  var _currentIndex = 0;

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
      body:  content,
      bottomNavigationBar: _indexBottom()
    );
  }

  Widget _indexBottom() => BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.graduationCap),
            title: Text('Cursos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userTie),
            title: Text('Docentes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userGraduate),
            title: Text('Estudiantes'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            switch (_currentIndex) {
              case 0:
                content = UserListPage();
                break;
              case 1:
                content = Container(
                  alignment: Alignment.center,
                  child: Text("Docentes"),
                );
                break;
              case 2:
                content = Container(
                  alignment: Alignment.center,
                  child: Text("Estudiantes"),
                );
                break;
            }
          });
        },
      );

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