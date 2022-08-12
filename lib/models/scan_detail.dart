class ScanDetail {
  int id;
  String username;
  String mail;
  int status;
  DateTime? scannedDate;
  DateTime? lastOnline;
  String userPic;
  ScanDetail({
    required this.id,
    required this.username,
    required this.mail,
    required this.status,
    required this.scannedDate,
    required this.lastOnline,
    required this.userPic,
  });

  factory ScanDetail.fromJson(Map<String, dynamic> json) {
    return ScanDetail(
      id: json["id"],
      username: json["username"],
      mail: json["mail"],
      status: json["status"],
      scannedDate: DateTime.tryParse(json["scanned_date"]),
      lastOnline: DateTime.tryParse(json["last_online"]),
      userPic: json["user_pic"],
    );
  }
}
