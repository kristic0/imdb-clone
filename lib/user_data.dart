import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    required this.name,
    required this.profilePicture,
    required this.birthday,
    required this.about,
  });

  String name;
  String profilePicture;
  DateTime birthday;
  String about;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        name: json["name"],
        profilePicture: json["profile_picture"],
        birthday: DateTime.parse(json["birthday"]),
        about: json["about"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "profile_picture": profilePicture,
        "birthday":
            "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "about": about,
      };
}
