import 'package:grocify/utils/utils.dart';

class UserModel {
  final String? uid;
  final String? name;
  final String? surname;
  final String? email;
  final String? password;
  final String? profilePic;
  String? role;

  UserModel({
    this.uid,
    this.name,
    this.surname,
    this.email,
    this.password,
    this.profilePic,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: Utils.capitalizeFirstLetter(json['name']),
      surname: json['surname'],
      email: json['email'],
      password: json['password'],
      profilePic: json['profilePic'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': Utils.capitalizeFirstLetter(name as String),
      'surname': surname,
      'email': email,
      'password': password,
      'profilePic': profilePic,
      'role': role,
    };
  }
}
