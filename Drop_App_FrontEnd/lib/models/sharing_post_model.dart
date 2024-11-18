class SharingModel {
  final String sproductId;
  final String sproductName;
  final String sproductCategory;
  final String sproductDescription;
  final String sproductStartTime;
  final String sproductEndTime;
  final int borrowerID;
  final int coinValue;
  final bool active;
  final String postingTime;
  final int status;

  SharingModel({
    required this.sproductId,
    required this.sproductName,
    required this.sproductCategory,
    required this.sproductDescription,
    required this.sproductStartTime,
    required this.sproductEndTime,
    required this.borrowerID,
    required this.coinValue,
    required this.active,
    required this.postingTime,
    required this.status,
  });

  // Factory constructor to parse JSON into a SharingPost object
  factory SharingModel.fromJson(Map<String, dynamic> json) {
    return SharingModel(
      sproductId: json['sproduct_id'],
      sproductName: json['sproduct_name'],
      sproductCategory: json['sproduct_category'],
      sproductDescription: json['sproduct_description'],
      sproductStartTime: json['sproduct_start_time'],
      sproductEndTime: json['sproduct_end_time'],
      borrowerID: json['borrower_id'],
      coinValue: json['coin_value'],
      active: json['active'],
      postingTime: json['posting_time'],
      status: json['status'],
    );
  }

  // Method to convert SharingPost object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'sproduct_id': sproductId,
      'sproduct_name': sproductName,
      'sproduct_category': sproductCategory,
      'sproduct_description': sproductDescription,
      'sproduct_start_time': sproductStartTime,
      'sproduct_end_time': sproductEndTime,
      'borrower_id': borrowerID,
      'coin_value': coinValue,
      'active': active,
      'posting_time': postingTime,
      'status': status,
    };
  }
}

