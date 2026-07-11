import 'dart:convert';
import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/product_model.dart';
import 'package:alkher/services/token_services.dart';
import 'package:http/http.dart' as http;

class FavoriteService {
  Future<bool> toggle(String productId) async {
    final token = await TokenServices().getToken();

    final response = await http.post(
      Uri.parse("${ApiConstant.baseUrl}/favorites/$productId"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تحديث المفضلة');
    }

    final data = jsonDecode(response.body);
    return data['isFavorite'] as bool;
  }

  Future<List<String>> getFavoriteIds() async {
    final token = await TokenServices().getToken();

    final response = await http.get(
      Uri.parse("${ApiConstant.baseUrl}/favorites/ids"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل المفضلة');
    }

    final List data = jsonDecode(response.body);
    return data.map((id) => id.toString()).toList();
  }

  Future<List<ProductModel>> getFavoriteProducts() async {
    final token = await TokenServices().getToken();

    final response = await http.get(
      Uri.parse("${ApiConstant.baseUrl}/favorites"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل المنتجات المفضلة');
    }

    final List data = jsonDecode(response.body);
    return data.map((p) => ProductModel.fromJson(p)).toList();
  }

  Future<void> clearAllFavorites() async {
    final token = await TokenServices().getToken();

    final response = await http.delete(
      Uri.parse("${ApiConstant.baseUrl}/favorites"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('فشل حذف جميع العناصر من السيرفر');
    }
  }
} 