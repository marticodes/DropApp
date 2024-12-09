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
  static const String _baseUrl = 'https://dropapp-eq8l.onrender.com';

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

Future<List<SharingModel>> filterSharingByCategory(List<String> categories) async {
  try {
    // Construct the query string
    final queryString = categories.map((category) => 'categories=$category').join('&');

    // Make the GET request
    final response = await http.get(Uri.parse('$_baseUrl/api/sharing?$queryString'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> data = json.decode(response.body);

      // Convert JSON to a list of SharingModel objects
      return data.map((json) => SharingModel.fromJson(json)).toList();
    } else {
      throw Exception('Must select a category to filter!');
    }
  } catch (e) {
    throw Exception('Must select a category to filter!');
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

      if (response.statusCode == 201) {
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
/*

    Future<List<DonationModel>> filterDonationsByCategory(List<String> categories) async {
    try {
      final queryString = categories.map((category) => 'categories=$category').join('&');

      final response = await http.get(Uri.parse('$_baseUrl/api/donations?$queryString'));

      if (response.statusCode == 200) {  //check code 
        final List<dynamic> data = json.decode(response.body);

        return data.map((json) => DonationModel.fromJson(json)).toList();
      } else {
        throw Exception('Must select a category to filter!');
      }
    } catch (e) {
      throw Exception('FE: Error filtering donations by categories: $e');
    }
  }

  static Future<List<DonationModel>> filterDonationsByCoin(int min, int max) async {
    try {
      final url = Uri.parse('$_baseUrl/api/donations/$min/$max');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> donationsJson = json.decode(response.body);

        return donationsJson.map((d) => DonationModel.fromJson(d)).toList();
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('FE: Error filtering by coins: $e');
    }
  }
*/

  Future<List<DonationModel>> filterDonations(int min, int max, List<String> categories) async {
    final queryString = categories.map((c) => 'categories=${Uri.encodeComponent(c)}').join('&');
    final url = Uri.parse('$_baseUrl/api/$min/$max/donations?$queryString');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => DonationModel.fromJson(json)).toList();
    } else {
      throw Exception('Error filtering donations: ${response.statusCode}');
    }
  }

  // CHATS

  static Future<List<ChatModel>> fetchAllChatsForUser(int userId1) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/api/chat/all/$userId1'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => ChatModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load chats');
  }
}


static Future<int> insertChat(userID1, userID2, product_id, type, sproduct_id) async {
    final url = Uri.parse('$_baseUrl/api/chats/insert');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
        'user_id_1': userID1,
        'user_id_2': userID2,
        'product_id': product_id,
        'type': type,
        'sproduct_id': sproduct_id,
      }),
      );
      if (response.statusCode == 201) {
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

  static Future<Map<String, dynamic>> getChatProduct(int chatId) async {
  final url = '$_baseUrl/api/chat/$chatId/product';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final chatJson = json.decode(response.body);
    final productId = chatJson[0];
    final sProductId = chatJson[1];
    return {
      'product_id': productId,
      'sproduct_id': sProductId,
    };
  } else {
    throw Exception('FE: Error getting chat product');
  }
}

  
  // MESSAGES
  static Future<List<MessageModel>> fetchMessagesByChatId(int chatId) async {
    final response = await http.get(Uri.parse('$_baseUrl/api/chats/messages/$chatId'));

    if (response.statusCode == 200) {
      if (json.decode(response.body) == false ) {
      // Return an empty list if no messages were found
      return [];
    }
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages for chat $chatId');
    }
  }

  static Future<int> insertMessage({
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

      if (response.statusCode == 201) {
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

static Future<int> insertUser({
  required String userName,
  required String userSurname,
  required String userCardnum,
  required String userLocation,
  required String hash, 
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
        'user_location': userLocation,
        'hash': hash, 
      }),
    );

    if (response.statusCode == 201) {
      // Decode the response into a Map and then convert to UserModel
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['user_id'];
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

//LOGIN
  Future<int?> logIn(String userCardNum, String hash) async {

  try {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/$userCardNum/$hash'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Parse the JSON response
      // Handle the response as needed
      //print(res);
    } else {
      throw Exception('FE: Error logging in');
    }
  } catch (e) {
    // Handle errors
    print('Error: $e');
    throw Exception('FE: Error logging in');
  }
}


//COINS

  static Future<int> donationCoinExchange(int productId, int coinValue, int userId) async {

    final response = await http.post(
      Uri.parse('$_baseUrl/api/donation/coins'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'product_id': productId,
        'coin_value': coinValue,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['product_id']; // Adjust based on the actual response
    } else {
      final String errorText = response.body;
      throw Exception(
          'FE: Error status: ${response.statusCode}, message: $errorText');
    }
  }

  static Future<String> sharingCoinExchange(sproductId, coinValue, userId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/sharing/coins'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sproduct_id': sproductId,
          'coin_value': coinValue,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['product_id']; // Adjust based on actual response data
      } else {
        final String errorText = response.body;
        throw Exception(
            'FE: Error status: ${response.statusCode}, message: $errorText');
      }
    } catch (error) {
      print(error.toString());
      rethrow; // Rethrow the caught error
    }
  }


  //INACTIVE POSTS
  static Future<void> inactiveDonation(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/donation/inactive'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'product_id': productId}),
      );

      if (response.statusCode == 200) {
        // return json.decode(response.body); // Return the response as a Map
      }  else {
        final String errorText = response.body;
        throw Exception(
            'FE: Error status: ${response.statusCode}, message: $errorText');
      }
    } catch (error) {
      print(error.toString());
      rethrow; // Rethrow the caught error
    }
  }

static Future<void> inactiveSharing(String sproductId,) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/sharing/inactive'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'sproduct_id': sproductId}),
      );

      if (response.statusCode == 200) {
        // return json.decode(response.body); // Return the response as a Map
      } else {
        final String errorText = response.body;
        throw Exception(
            'FE: Error status: ${response.statusCode}, message: $errorText');
      }
    } catch (error) {
      print(error.toString());
      rethrow; // Rethrow the caught error
    }
  }




}