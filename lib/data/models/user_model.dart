import 'dart:convert';

List<User> userFromJson(dynamic json) =>
    List<User>.from(json.map((x) => User.fromJson(x)));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.name,
    required this.username,
    this.phoneNumber,
    required this.image,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  int id;
  String name;
  String username;
  String? phoneNumber;
  String image;
  int isAdmin;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        phoneNumber: json["phone_number"],
        image: json["image"],
        isAdmin: json["is_admin"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.tryParse(json["deleted_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "phone_number": phoneNumber,
        "image": image,
        "is_admin": isAdmin,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
      };
}
