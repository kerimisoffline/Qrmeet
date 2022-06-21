class User {
  int? id;
  String? username;
  String? mail;
  String? password;
  int? status;
  DateTime? createdTime;
  DateTime? lastOnline;
  String? userPic;

  User({
    this.id, 
    this.username, 
    this.mail, 
    this.password, 
    this.status,
    this.createdTime, 
    this.lastOnline, 
    this.userPic
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
