class User{
  int id;
  String username;
  String password;
  String email;
  User(this.username,this.password,this.email);
  User.withId(this.id,this.username,this.password,this.email);

  User.map(dynamic obj){
    this.id = obj["id"];
    this.username = obj["username"];
    this.password = obj["password"];
    this.email =  obj["email"];
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic> ();
    map["id"] = id;
    map["username"] = username;
    map["password"] = password;
    map["email"] = email;

    return map;
  }
}