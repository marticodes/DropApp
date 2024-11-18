class CategoriesModel {
  final String categoryName;

  CategoriesModel({
    required this.categoryName,
  });

  // Factory constructor to parse JSON into a CategoriesModel object
  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      categoryName: json['category_name'],
    );
  }

  // Method to convert CategoriesModel object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
    };
  }
}
