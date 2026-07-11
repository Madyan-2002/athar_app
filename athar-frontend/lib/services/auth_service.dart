import 'dart:convert';
import 'dart:io';
import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/login_response.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstant.baseUrl}/users/login'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'فشل تسجيل الدخول');
    }

    return LoginResponse.fromJson(data);
  }

  Future<LoginResponse> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstant.baseUrl}/users/register'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    final data = jsonDecode(response.body);
    return LoginResponse.fromJson(data);
  }

  // ── جديد: تحديث الملف الشخصي (اسم/إيميل/صورة اختيارية) ──
  Future<LoginResponse> updateProfile({
    required String token,
    required String name,
    required String email,
    String? password,
    File? imageFile,
  }) async {
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiConstant.baseUrl}/users/update-profile'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['email'] = email;
    if (password != null && password.isNotEmpty) {
      request.fields['password'] = password;
    }
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'فشل تحديث الملف الشخصي');
    }

    // السيرفر ما بيرجع token جديد هون، فبنحافظ على القديم
    return LoginResponse(
      token: token,
      name: data['name'] ?? name,
      email: data['email'] ?? email,
      role: data['role'] ?? '',
      image: data['image'] ?? '',
    );
  }
}