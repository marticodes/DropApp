class IdModel {
  final int productId;
  final int sproductId;

  IdModel({
    required this.productId,
    required this.sproductId
  });

  // Factory constructor to parse JSON into a SharingPost object
  factory IdModel.fromJson(Map<String, dynamic> json) {
    return IdModel(
      productId: json['product_id'],
      sproductId: json['sproduct_id'],
    );
  }

  // Method to convert SharingPost object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'sproduct_id': sproductId,
    };
  }
}

