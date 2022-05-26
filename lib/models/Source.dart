import 'dart:convert';

List<Source> sourceFromJson(String str) =>
    List<Source>.from(json.decode(str).map((x) => Source.fromJson(x)));

String sourceToJson(List<Source> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Source {
  final int id;
  final String name;
  final num price;
  final int volume;

  const Source({
    required this.id,
    required this.name,
    required this.price,
    required this.volume,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      volume: json['volume'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "volume": volume,
      };
}
