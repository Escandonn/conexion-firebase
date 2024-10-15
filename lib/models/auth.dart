class AuthModel {
  final String token;
  final int id;
  final String name;
  final String email;
  final String role;

  AuthModel({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      role: json['user']['role'],
    );
  }
}
