class AdminUserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}