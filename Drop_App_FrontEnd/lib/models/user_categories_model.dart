class UserCategoriesModel {
  final int userId;
  final String categoryName;

  UserCategoriesModel({
    required this.userId,
    required this.categoryName,
  });

  // Factory constructor to parse JSON into a UserCategoriesModel object
  factory UserCategoriesModel.fromJson(Map<String, dynamic> json) {
    return UserCategoriesModel(
      userId: json['user_id'],
      categoryName: json['category_name'],
    );
  }

  // Method to convert UserCategoriesModel object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'category_name': categoryName,
    };
  }
}
