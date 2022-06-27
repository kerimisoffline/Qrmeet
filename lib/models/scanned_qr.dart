class ScannedQr {
  int id;
  int qrId;
  int userId;
  String qrTitle;
  ScannedQr({
    required this.id,
    required this.qrId,
    required this.userId,
    required this.qrTitle,
  });

  factory ScannedQr.fromJson(Map<String, dynamic> json) {
    return ScannedQr(
      id: json["id"],
      qrId: json["qr_id"],
      userId: json["user_id"],
      qrTitle: json["qr_title"],
    );
  }
}
