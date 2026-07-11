import 'dart:convert';
import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/admin_user_model.dart';
import 'package:alkher/services/token_services.dart';
import 'package:http/http.dart' as http;

class AdminUserService {
  Future<List<AdminUserModel>> getAllUsers() async {
    final token = await TokenServices().getToken();

    final response = await http.get(
      Uri.parse("${ApiConstant.baseUrl}/users"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل المستخدمين');
    }

    final List data = jsonDecode(response.body);
    return data.map((u) => AdminUserModel.fromJson(u)).toList();
  }

  Future<bool> deleteUser(String id) async {
    final token = await TokenServices().getToken();

    final response = await http.delete(
      Uri.parse("${ApiConstant.baseUrl}/users/$id"),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}