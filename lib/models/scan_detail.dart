class ScanDetail {
  int id;
  int username;
  int mail;
  String status;
  DateTime? scannedDate;
  String userPic;
  ScanDetail({
    required this.id,
    required this.username,
    required this.mail,
    required this.status,
    required this.scannedDate,
    required this.userPic,
  });

  factory ScanDetail.fromJson(Map<String, dynamic> json) {
    return ScanDetail(
      id: json["id"],
      username: json["qr_id"],
      mail: json["user_id"],
      status: json["qr_title"],
      scannedDate: DateTime.tryParse(json["scanned_date"]),
      userPic: json["user_pic"],
    );
  }
}
