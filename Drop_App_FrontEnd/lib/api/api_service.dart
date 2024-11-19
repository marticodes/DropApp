import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drop_app/models/sharing_post_model.dart';

class ApiService {
  // Update this URL to your backend's address
  static const String SERVER_URL = 'http://localhost:3001'; 

  // Function to fetch all active sharing posts
  static Future<List<SharingModel>> listActiveSharing() async {
    final response = await http.get(
      Uri.parse('http://143.248.198.76:3001/api/sharing/all/active'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => SharingModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load active sharing posts');
    }
  }
}

