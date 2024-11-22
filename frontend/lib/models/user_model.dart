class UserModel {
  final int userId;
  final String userName;
  final String userSurname;
  final int userCardNum;
  final int coinsNum;
  final String userPicture;
  final int userRating;
  final String userLocation; // Nullable, as it's not required in the schema
  final int userGraduated;
  final String hash;
  final String salt;
  final int active;
  final int numRev;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userSurname,
    required this.userCardNum,
    required this.coinsNum,
    required this.userPicture,
    required this.userRating,
    required this.userLocation,
    required this.userGraduated,
    required this.hash,
    required this.salt,
    required this.active,
    required this.numRev,
  });

  // Factory constructor to parse JSON into a UserModel object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
    userId: json['user_id'],
    userName: json['user_name'] ?? '',
    userSurname: json['user_surname'] ?? '',
    userCardNum: json['user_cardnum'] ?? 0,
    coinsNum: json['coins_num'] ?? 0,
    userPicture: json['user_picture'] ?? '',
    userRating: json['user_rating'] ?? 0,
    userLocation: json['user_location'] ?? '', // Default to an empty string if null
    userGraduated: json['user_graduated'] ?? 0,
    hash: json['hash'] ?? '',
    salt: json['salt'] ?? '',
    active: json['active'] ?? 1,
    numRev: json['num_rev'] ?? 0,
  );
  }

  // Method to convert UserModel object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_surname': userSurname,
      'user_cardnum': userCardNum,
      'coins_num': coinsNum,
      'user_picture': userPicture,
      'user_rating': userRating,
      'user_location': userLocation,
      'user_graduated': userGraduated,
      'hash': hash,
      'salt': salt,
      'active': active,
      'num_rev': numRev,
    };
  }
}
