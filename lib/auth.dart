import 'package:todo_app/data/database_helper.dart';

import 'infraestructure/Sqflite_UserRepository.dart';

enum AuthState { LOGGED_IN, LOGGED_OUT}

abstract class AuthStateListener{
  void onAuthStateChanged(AuthState state);
}

class AuthStateProvider{
  static final AuthStateProvider _instance = new AuthStateProvider.internal();

  SqfliteUserRepository userRepository = SqfliteUserRepository(DatabaseHelper.get);

  List<AuthStateListener> _subscribers;

  factory AuthStateProvider() => _instance;

  AuthStateProvider.internal(){
    _subscribers = new List<AuthStateListener>();
    initState();
  }

  void initState() async{
    print("InitState AuthStateProvider");
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthStateListener listener){
    for (var l in _subscribers){
      if (l == listener)
        _subscribers.remove(l);
    }
  }

  void notify(AuthState state){
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }
}