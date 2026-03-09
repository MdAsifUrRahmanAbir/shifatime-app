class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstname;
  final String lastname;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstname: json['name'] != null ? json['name']['firstname'] ?? '' : '',
      lastname: json['name'] != null ? json['name']['lastname'] ?? '' : '',
    );
  }
}
