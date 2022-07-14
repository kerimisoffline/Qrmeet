class ScannedQr {
  int id;
  int qrId;
  int userId;
  String qrTitle;
  DateTime? scannedDate;
  String qrLink;
  ScannedQr({
    required this.id,
    required this.qrId,
    required this.userId,
    required this.qrTitle,
    required this.scannedDate,
    required this.qrLink,
  });

  factory ScannedQr.fromJson(Map<String, dynamic> json) {
    return ScannedQr(
      id: json["id"],
      qrId: json["qr_id"],
      userId: json["user_id"],
      qrTitle: json["qr_title"],
      scannedDate: DateTime.tryParse(json["scanned_date"]),
      qrLink: json["qr_link"],
    );
  }
}
