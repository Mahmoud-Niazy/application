import 'package:test/features/home/data/models/user_type_enum.dart';


class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? emailVerifiedAt;
  final bool isVerified;
  //////////////////////////////////
  final UserType roleType;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isVerified,
    this.emailVerifiedAt,
    required this.roleType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isVerified: json['is_verified'] as bool,
      emailVerifiedAt: json['email_verified_at'],
      roleType: json['role'] == 'manager'
          ? UserType.manager
          : json['role'] == 'admin'
          ? UserType.adimn
          : UserType.user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'is_verified': isVerified,
      'email_verified_at': emailVerifiedAt,
    };
  }
}
