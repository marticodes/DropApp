import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sharing_post_model.dart'; 
import '../models/donation_post_model.dart';
import '../models/message_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import '../models/user_categories_model.dart';
import '../models/chat_model.dart';

class ApiService {
  static const String _baseUrl = 'http://143.248.77.98:3001';

  //SHARING
  static Future<List<SharingModel>> listAllSharing() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/sharing/all/active'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => SharingModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load active sharing posts');
    }
  }

  static Future<int> insertSharing(sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, status) async {
    final url = Uri.parse('$_baseUrl/api/sharing/insert');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sproduct_name': sproduct_name,
          'sproduct_category': sproduct_category,
          'sproduct_description': sproduct_description,
          'sproduct_start_time': sproduct_start_time,
          'sproduct_end_time': sproduct_end_time,
          'borrower_id': borrower_id,
          'status': status,
        })
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['product_id']; // Assuming the backend response includes 'product_id'.
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access');
      } else {
        final errorText = response.body;
        print('Error status: ${response.statusCode}, message: $errorText');
        throw Exception('Failed to insert sharing: $errorText');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
  

  
  //DONATION
  static Future<List<DonationModel>> fetchActiveDonationPosts() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/donations/all/active'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => DonationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load active donation posts');
    }
  }

  static Future<int> insertDonation(product_name, product_description, product_category, product_picture, donor_id, status) async {
    final url = Uri.parse('$_baseUrl/api/donation/insert');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'product_name': product_name,
          'product_description': product_description,
          'product_category': product_category,
          'product_picture': product_picture,
          'donor_id': donor_id,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['product_id'] != null) {
          return data['product_id'];
        } else {
          throw Exception('Invalid response format: Missing "product_id".');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access');
      } else {
        final errorText = response.body;
        print('Error status: ${response.statusCode}, message: $errorText');
        throw Exception('Failed to insert donation: $errorText');
      }
    } catch (e) {
      print('Error occurred while inserting donation: $e');
      rethrow;
    }
  }

  // CHATS
  Future<List<Map<String, dynamic>>> fetchAllChatsForUser(int userId1, int userId2) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/api/chat/all/$userId1/$userId2'),
  );
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to load chats');
  }
}
Future<int> insertChat(userID1, userID2, product_id, type, sproduct_id) async {
    final url = Uri.parse('$_baseUrl/api/chats/insert');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
        'userID1': userID1,
        'userID2': userID2,
        'product_id': product_id,
        'type': type,
        'sproduct_id': sproduct_id,
      }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['chat_id'] != null) {
          return data['chat_id'];
        } else {
          throw Exception('Invalid response format: Missing "chat_id".');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access');
      } else {
        final errorText = response.body;
        print('Error status: ${response.statusCode}, message: $errorText');
        throw Exception('Failed to insert chat: $errorText');
      }
    } catch (e) {
      print('Error occurred while inserting chat: $e');
      rethrow;
    }
  }

  
  // MESSAGES
  static Future<List<MessageModel>> fetchMessagesByChatId(int chatId) async {
    final response = await http.get(Uri.parse('$_baseUrl/api/messages/$chatId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages for chat $chatId');
    }
  }

  Future<int> insertMessage({
    required int chatId,
    required String content,
    required String image,
    required int senderId,
    required String messageTime, // Add the message_time parameter here
  }) async {
    final url = Uri.parse('$_baseUrl/api/messages/insert');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chat_id': chatId,
          'message_time': messageTime,
          'content': content,
          'image': image,
          'sender_id': senderId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['message_id'] != null) {
          return data['message_id']; // Return the message_id received from backend
        } else {
          throw Exception('Invalid response format: Missing "message_id"');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access');
      } else {
        final errorText = response.body;
        print('Error status: ${response.statusCode}, message: $errorText');
        throw Exception('Failed to insert message: $errorText');
      }
    } catch (e) {
      print('Error occurred while inserting message: $e');
      rethrow;
    }
  }




  // USER
  static Future<UserModel> fetchUserById(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/api/info/$userId'));

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user $userId');
    }
  }

    Future<UserModel> insertUser({
    required String userName,
    required String userSurname,
    required String userCardnum,
    required String userPicture,
    required String userLocation,
  }) async {
    final url = Uri.parse('$_baseUrl/api/user/insert');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_name': userName,
          'user_surname': userSurname,
          'user_cardnum': userCardnum,
          'user_picture': userPicture,
          'user_location': userLocation,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data); // Convert the response to UserModel
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access');
      } else {
        final errorText = response.body;
        print('Error status: ${response.statusCode}, message: $errorText');
        throw Exception('Failed to insert user: $errorText');
      }
    } catch (e) {
      print('Error occurred while inserting user: $e');
      rethrow;
    }
  }




  // USER CATS
  static Future<List<UserCategoriesModel>> fetchUserCategories(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/api/user_categories/all/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserCategoriesModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories for user $userId');
    }
  }


  // Function to insert a user category and return true if successful
  Future<bool> insertUserCategory(UserCategoriesModel uc) async {
    final url = Uri.parse('$_baseUrl/api/user_categories/insert');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(uc.toJson()),
      );

      if (response.statusCode == 200) {
        // Assuming the backend returns a success response
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return true;
        } else {
          return false;
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access');
      } else {
        final errorText = response.body;
        print('Error status: ${response.statusCode}, message: $errorText');
        throw Exception('Failed to insert user category: $errorText');
      }
    } catch (e) {
      print('Error occurred while inserting user category: $e');
      rethrow;
    }
  }

  // CATS
  static Future<List<CategoriesModel>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/categories/list'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CategoriesModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

}

