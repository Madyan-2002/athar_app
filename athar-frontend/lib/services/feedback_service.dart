import 'dart:convert';
import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/feedback_model.dart';
import 'package:alkher/services/token_services.dart';
import 'package:http/http.dart' as http;

class FeedbackService {
  Future<List<FeedbackModel>> getAllFeedbacks() async {
    final token = await TokenServices().getToken();

    final response = await http.get(
      Uri.parse("${ApiConstant.baseUrl}/feedbacks"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل الملاحظات');
    }

    final List data = jsonDecode(response.body);
    return data.map((f) => FeedbackModel.fromJson(f)).toList();
  }

  Future<bool> deleteFeedback(String id) async {
    final token = await TokenServices().getToken();

    final response = await http.delete(
      Uri.parse("${ApiConstant.baseUrl}/feedbacks/$id"),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  Future<bool> sendFeedback({
  required String message,
  int? rating,
}) async {
  final token = await TokenServices().getToken();

  final response = await http.post(
    Uri.parse("${ApiConstant.baseUrl}/feedbacks"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "message": message,
      "rating": rating,
    }),
  );

  return response.statusCode == 201;
}
}

