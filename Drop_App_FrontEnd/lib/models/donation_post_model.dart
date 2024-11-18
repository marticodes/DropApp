class DonationModel {
  final String productId;
  final String productName;
  final String productCategory;
  final String productDescription;
  final String productPicture;
  final int donorId;
  final int coinValue;
  final bool active;
  final String postingTime;
  final int status;

  DonationModel({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productDescription,
    required this.productPicture,
    required this.donorId,
    required this.coinValue,
    required this.active,
    required this.postingTime,
    required this.status,
  });

  // Factory constructor to parse JSON into a SharingPost object
  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      productId: json['product_id'],
      productName: json['product_name'],
      productCategory: json['product_category'],
      productDescription: json['product_description'],
      productPicture: json['product_picture'],
      donorId: json['donor_id'],
      coinValue: json['coin_value'],
      active: json['active'],
      postingTime: json['posting_time'],
      status: json['status'],
    );
  }

  // Method to convert SharingPost object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_category': productCategory,
      'product_description': productDescription,
      'product_picture': productPicture,
      'donor_id': donorId,
      'coin_value': coinValue,
      'active': active,
      'posting_time': postingTime,
      'status': status,
    };
  }
}

