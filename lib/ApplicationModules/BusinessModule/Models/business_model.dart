class BusinessModel {
  BusinessModel({
    this.businessId,
    required this.businessName,
    required this.user_id,
    required this.businessNumber,
    required this.businessCategory,
    required this.businessAddress,
    required this.shippingCharges,
    required this.businessDescription,
    required this.businessImage,
    required this.businessLocationLat,
    required this.businessLocationLng,
    required this.businessStatus,
  });

  int? businessId;
  String businessName;
  String businessNumber;
  int businessCategory;
  int user_id;
  int shippingCharges;
  String businessAddress;
  String businessDescription;
  String businessImage;
  double businessLocationLat;
  double businessLocationLng;
  String businessStatus;

  factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
    businessId: int.parse(json["business_id"]??"0"),
    businessName: json["business_name"]??"",
    user_id: int.parse(json["user_id"]??"0"),
    shippingCharges: int.parse(json["shipping_charges"]??"0"),
    businessNumber: json["business_number"]??"",
    businessCategory: int.parse(json["business_category"]??"0"),
    businessAddress: json["business_address"]??"",
    businessDescription: json["business_description"]??"",
    businessImage: json["business_image"]??"",
    businessLocationLat: double.parse(json["business_location_lat"]??"0.0"),
    businessLocationLng:double.parse( json["business_location_lng"]??"0.0"),
    businessStatus: json["business_status"]??"",
  );

  Map<String, dynamic> toJson() => {
    "business_id": businessId,
    "business_name": businessName,
    "business_number": businessNumber,
    "business_category": businessCategory,
    "business_address": businessAddress,
    "business_description": businessDescription,
    "business_image": businessImage,
    "business_location_lat": businessLocationLat,
    "business_location_lng": businessLocationLng,
    "business_status": businessStatus,
    "user_id": user_id,
    "shipping_charges": shippingCharges,
  };

  static List<BusinessModel> jsonToListView(List<dynamic> data) {
    return data.map((e) => BusinessModel.fromJson(e)).toList();
  }
}
