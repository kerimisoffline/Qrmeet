class User {
  int id;
  String username;
  String mail;
  String password;
  int status;
  DateTime? createdTime;
  DateTime? lastOnline;
  String userPic;

  User({
    required this.id, 
    required this.username, 
    required this.mail, 
    required this.password, 
    required this.status,
    required this.createdTime, 
    required this.lastOnline, 
    required this.userPic
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"], 
      username: json["username"], 
      mail: json["mail"],
      password: json["password"],
      status: json["status"],
      createdTime: DateTime.tryParse(json["created_time"]),
      lastOnline: DateTime.tryParse(json["last_online"]),
      userPic: json["user_pic"],
    );}
}
