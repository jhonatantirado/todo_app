class User{
  int _id;
  String _username;
  String _password;
  User(this._username,this._password);
  User.withId(this._id,this._username,this._password);

  User.map(dynamic obj){
    this._id = obj["id"];
    this._username = obj["username"];
    this._password = obj["password"];
  }

  int get id => _id;
  String get username => _username;
  String get password => _password;

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic> ();
    map["id"] = _id;
    map["username"] = _username;
    map["password"] = _password;

    return map;
  }
}