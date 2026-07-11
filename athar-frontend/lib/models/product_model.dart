class ProductModel {
  final String id;
  final String title;
  final String description;
  final String type;

  final double? price;
  final int? stock;
  final String? categoryId;
  final String? categoryName;

  final double? targetAmount;
  final DateTime? deadline;

  final double? salary;
  final String? location;

  final List<String> images;
  final String createdById;
  final String? createdByName;
  final String contactNumber;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.price,
    this.stock,
    this.categoryId,
    this.categoryName,
    this.targetAmount,
    this.deadline,
    this.salary,
    this.location,
    required this.images,
    required this.createdById,
    this.createdByName,
    required this.contactNumber
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final categoryField = json['category'];
    final createdByField = json['createdBy'];

    return ProductModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'other',
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      stock: json['stock'] != null ? (json['stock'] as num).toInt() : null,
      categoryId: categoryField is Map ? categoryField['_id'] : categoryField,
      categoryName: categoryField is Map ? categoryField['name'] : null,
      targetAmount: json['targetAmount'] != null
          ? (json['targetAmount'] as num).toDouble()
          : null,
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'])
          : null,
      salary: json['salary'] != null ? (json['salary'] as num).toDouble() : null,
      location: json['location'],
      images: json['image'] != null ? List<String>.from(json['image']) : [],
      createdById: createdByField is Map
          ? (createdByField['_id'] ?? '')
          : (createdByField ?? ''),
      createdByName: createdByField is Map ? createdByField['name'] : null,
      contactNumber: json['contactNumber'] ?? '',
    );
  }
}