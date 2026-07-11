import 'dart:convert';
import 'dart:io';
import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/services/token_services.dart';
import 'package:http/http.dart' as http;

class ImageService {
  Future<String> uploadImage(File image) async {
    final token = await TokenServices().getToken();
    var request = http.MultipartRequest(
      "POST",
      Uri.parse('${ApiConstant.baseUrl}/uploads'),  // Products/uploads
    );
    request.headers['Authroization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath("image", image.path));

    final response = await request.send();
    final bodyJson = await response.stream.bytesToString();
    final data = await jsonDecode(bodyJson);
    return data['image'];
  }
}
