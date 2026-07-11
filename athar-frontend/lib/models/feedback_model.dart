class FeedbackModel {
  final String id;
  final String message;
  final int? rating;
  final String senderName;
  final String senderEmail;
  final String senderRole;
  final DateTime? createdAt;

  FeedbackModel({
    required this.id,
    required this.message,
    this.rating,
    required this.senderName,
    required this.senderEmail,
    required this.senderRole,
    this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    final createdByField = json['createdBy'];

    return FeedbackModel(
      id: json['_id'] ?? '',
      message: json['message'] ?? '',
      rating: json['rating'],
      senderName: createdByField is Map ? (createdByField['name'] ?? 'مستخدم') : 'مستخدم',
      senderEmail: createdByField is Map ? (createdByField['email'] ?? '') : '',
      senderRole: createdByField is Map ? (createdByField['role'] ?? '') : '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}