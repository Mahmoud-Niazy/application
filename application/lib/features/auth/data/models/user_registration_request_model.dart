class UserRegistrationRequestModel {

  final String name;
  final String email;
  final String? password;


  UserRegistrationRequestModel({
    required this.name,
    required this.email,
    this.password,

  });

  factory UserRegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    return UserRegistrationRequestModel(
      name: json['user']['name'],
      email: json['user']['email'],
    );
  }

  Map<String,dynamic> toJson() {
    return {
      "name" : name,
      "email" : email,
      "password" : password,
      "password_confirmation" : password
    };
  }
}
