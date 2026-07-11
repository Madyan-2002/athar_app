import 'dart:convert';
import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/category_model.dart';
import 'package:alkher/services/token_services.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse("${ApiConstant.baseUrl}/categories"),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل التصنيفات');
    }

    final List data = jsonDecode(response.body);
    return data.map((c) => CategoryModel.fromJson(c)).toList();
  }

  Future<bool> createCategory(String name) async {
    final token = await TokenServices().getToken();

    final response = await http.post(
      Uri.parse("${ApiConstant.baseUrl}/categories"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    return response.statusCode == 201;
  }
}