class Hit {
  int id;
  int type;
  int status;
  String title;
  int qrId;
  String image;
  int total;
  Hit({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.qrId,
    required this.image,
    required this.total,
  });

  factory Hit.fromJson(Map<String, dynamic> json) {
    return Hit(
      id: json["id"],
      type: json["type"],
      status: json["status"],
      title: json["title"],
      qrId: json["qr_id"],
      image: json["image"],
      total: json["total"],
    );
  }
}
