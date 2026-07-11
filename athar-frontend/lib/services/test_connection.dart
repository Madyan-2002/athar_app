import "package:alkher/constants/api_constant.dart";
import "package:http/http.dart" as http;

class TestConnection {

  // method to test the connection to the server
  Future<void> testConnection() async {

    final response = await http.get(Uri.parse(ApiConstant.baseUrl));
    print(response.body);
  }
}
