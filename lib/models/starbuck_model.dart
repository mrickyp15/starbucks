class Starbuck {
  Starbuck({
    required this.minumman,
    required this.harga,
    required this.id,
  });

  String minumman;
  String harga;
  String id;

  factory Starbuck.fromJson(Map<String, dynamic> json) => Starbuck(
    minumman: json["minumman"],
    harga: json["harga"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "minumman": minumman,
    "harga": harga,
    "id": id,
  };
}