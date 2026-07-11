import 'dart:convert';
import 'dart:io';
import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/product_model.dart';
import 'package:alkher/services/token_services.dart';
import 'package:http/http.dart' as http;

class ProductServices {
  Future<List<ProductModel>> getProducts({
    String? type,
    bool mine = false,
  }) async {
    final token = await TokenServices().getToken();

    final queryParams = <String, String>{};
    if (type != null) queryParams['type'] = type;
    if (mine) queryParams['mine'] = 'true';

    final uri = Uri.parse(
      "${ApiConstant.baseUrl}/products",
    ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل الإعلانات');
    }

    final decoded = jsonDecode(response.body);
    final List data = decoded as List;
    return data.map((p) => ProductModel.fromJson(p)).toList();
  }

  Future<bool> createProduct({
    required String title,
    required String description,
    required String type,
    String? categoryId,
    double? price,
    int? stock,
    double? targetAmount,
    DateTime? deadline,
    double? salary,
    String? location,
    required String contactNumber,
    required File image,
  }) async {
    final token = await TokenServices().getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse("${ApiConstant.baseUrl}/products"),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['type'] = type;

    if (categoryId != null) request.fields['category'] = categoryId;
    if (price != null) request.fields['price'] = price.toString();
    if (stock != null) request.fields['stock'] = stock.toString();
    if (targetAmount != null) {
      request.fields['targetAmount'] = targetAmount.toString();
    }
    if (deadline != null) {
      request.fields['deadline'] = deadline.toIso8601String();
    }
    if (salary != null) request.fields['salary'] = salary.toString();
    if (location != null) request.fields['location'] = location;

    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();
    print("Create status: ${response.statusCode}");
    print("Create body: $body");
    

    return response.statusCode == 201;
  }

  Future<bool> updateProduct({
    required String id,
    required String title,
    required String description,
    double? price,
    int? stock,
    String? categoryId,
    double? targetAmount,
    DateTime? deadline,
    double? salary,
    String? location,
    required String contactNumber,
  }) async {
    final token = await TokenServices().getToken();

    final body = <String, dynamic>{
      'title': title,
      'description': description,
      if (price != null) 'price': price,
      if (stock != null) 'stock': stock,
      if (categoryId != null) 'category': categoryId,
      if (targetAmount != null) 'targetAmount': targetAmount,
      if (deadline != null) 'deadline': deadline.toIso8601String(),
      if (salary != null) 'salary': salary,
      if (location != null) 'location': location,
    };

    final response = await http.put(
      Uri.parse("${ApiConstant.baseUrl}/products/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteProduct(String id) async {
    final token = await TokenServices().getToken();

    final response = await http.delete(
      Uri.parse("${ApiConstant.baseUrl}/products/$id"),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}
