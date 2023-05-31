class UserModel {
  UserModel({
    this.customerId,
    required this.customerName,
    required this.is_verified,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerPassword,
    required this.customerAddress,
    required this.customerStatus,
    required this.customerImage,
    required this.customer_type,
    required this.customerLocationLat,
    required this.customerLocationLng,
  });

  int? customerId;
  String customerName;
  int is_verified;
  String customerPhone;
  String customerEmail;
  String customerPassword;
  String customerAddress;
  String customerStatus;
  String customerImage;
  String customer_type;
  double customerLocationLat;
  double customerLocationLng;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        customerId: json["id"] ?? 0,
        customerName: json["customer_name"] ?? "",
        is_verified: int.parse(json["is_verified"] ?? "0"),
        customerPhone: json["customer_phone"] ?? "",
        customerEmail: json["customer_email"] ?? "",
        customerPassword: json["customer_password"] ?? "",
        customerAddress: json["customer_address"] ?? "",
        customerStatus: json["customer_status"] ?? '',
        customer_type: json["customer_type"] ?? '',
        customerImage: json["customer_image"] ?? "",
        customerLocationLat:
            double.parse(json["customer_location_lat"] ?? "0.0"),
        customerLocationLng:
            double.parse(json["customer_location_lng"] ?? "0.0"),
      );

  Map<String, dynamic> toJson() => {
        "id": customerId,
        "customer_name": customerName,
        "is_verified": is_verified,
        "customer_phone": customerPhone,
        "customer_email": customerEmail,
        "customer_password": customerPassword,
        "customer_address": customerAddress,
        "customer_status": customerStatus,
        "customer_type": customer_type,
        "customer_image": customerImage,
        "customer_location_lat": customerLocationLat,
        "customer_location_lng": customerLocationLng,
      };

  static List<UserModel> jsonToListView(List<dynamic> data) {
    return data.map((e) => UserModel.fromJson(e)).toList();
  }
}
