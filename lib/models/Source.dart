import 'dart:convert';

List<Source> sourceFromJson(String str) => List<Source>.from(json.decode(str).map((x) => Source.fromJson(x)));

String sourceToJson(List<Source> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Source singleSourceFromJson(String str) => json.decode(str).map((x) => Source.fromJson(x));

String singleSourceToJson(Source data) => json.encode(data.toJson());

class Source {
  final int id;
  final String username;
  final String mail;
  final int status;

  const Source({
    required this.id,
    required this.username,
    required this.mail,
    required this.status,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      username: json['username'],
      mail: json['mail'],
      status: json['status'],
    );
  }

  factory Source.fromSingleJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      username: json['username'],
      mail: json['mail'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "mail": mail,
        "status": status,
      };
}
