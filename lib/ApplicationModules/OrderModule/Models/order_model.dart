class OrderModel {
  OrderModel({
    required this.orderId,
    required this.customerId,
    required this.orderNo,
    required this.businessId,
    required this.business_mid,
    required this.businessName,
    required this.businessContact,
    required this.businessAddress,
    required this.dateTime,
    required this.orderStatus,
    required this.totalItemPrice,
    required this.shippingOrder,
    required this.totalItems,
    required this.shippingDate,
    required this.totalAmount,
  });

  int orderId;
  int customerId;
  String orderNo;
  int businessId;
  int business_mid;
  String businessName;
  String businessContact;
  String businessAddress;
  String dateTime;
  String orderStatus;
  int totalItemPrice;
  String shippingOrder;
  int totalItems;
  String shippingDate;
  int totalAmount;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: int.parse(json["order_id"] ?? "0"),
        customerId: int.parse(json["customer_id"] ?? "0"),
        orderNo: json["order_no"] ?? "",
        businessId: int.parse(json["business_id"] ?? "0"),
        business_mid: int.parse(json["business_mid"] ?? "0"),
        businessName: json["business_name"] ?? "",
        businessContact: json["business_contact"] ?? "",
        businessAddress: json["business_address"] ?? "",
        dateTime: json["date_time"] ?? "",
        orderStatus: json["order_status"] ?? "",
        totalItemPrice: int.parse(json["total_item_price"] ?? "0"),
        shippingOrder: json["shipping_order"] ?? "",
        totalItems: int.parse(json["total_items"] ?? "0"),
        shippingDate: json["shipping_date"] ?? "",
        totalAmount: int.parse(json["total_amount"] ?? "0"),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "customer_id": customerId,
        "business_mid": business_mid,
        "order_no": orderNo,
        "business_id": businessId,
        "business_name": businessName,
        "business_contact": businessContact,
        "business_address": businessAddress,
        "date_time": dateTime,
        "order_status": orderStatus,
        "total_item_price": totalItemPrice,
        "shipping_order": shippingOrder,
        "total_items": totalItems,
        "shipping_date": shippingDate,
        "total_amount": totalAmount,
      };

  static List<OrderModel> jsonToListView(List<dynamic> data) {
    return data.map((e) => OrderModel.fromJson(e)).toList();
  }
}
