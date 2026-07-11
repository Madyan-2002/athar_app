class LoginResponse {
  final String token;
  final String name;
  final String role;
  final String email;
  final String image;

  LoginResponse({
    required this.token,
    required this.name,
    required this.role,
    required this.email,
    this.image = '',
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      name: json['name'] ?? json['username'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
    );
  }
}