class SharingModel {
  final String sproductName;
  final String sproductDescription;
  final int coinValue;
  final String sproductStartTime;

  SharingModel({
    required this.sproductName,
    required this.sproductDescription,
    required this.coinValue,
    required this.sproductStartTime,
  });

  // Convert JSON to SharingModel
  factory SharingModel.fromJson(Map<String, dynamic> json) {
    return SharingModel(
      sproductName: json['sproduct_name'],
      sproductDescription: json['sproduct_description'],
      coinValue: json['coin_value'],
      sproductStartTime: json['sproduct_start_time'],
    );
  }
}

