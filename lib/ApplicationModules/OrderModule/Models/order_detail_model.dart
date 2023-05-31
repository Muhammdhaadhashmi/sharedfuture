
class OrderDetailModel {
  OrderDetailModel({
    required this.detailId,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  int detailId;
  int orderId;
  int productId;
  int quantity;
  int price;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        detailId: int.parse(json["detail_id"]),
        orderId: int.parse(json["order_id"]),
        productId: int.parse(json["product_id"]),
        quantity:int.parse( json["quantity"]),
        price:int.parse(json["price"]) ,
      );

  Map<String, dynamic> toJson() => {
        "detail_id": detailId,
        "order_id": orderId,
        "product_id": productId,
        "quantity": quantity,
        "price": price,
      };
  static List<OrderDetailModel> jsonToListView(List<dynamic> data) {
    return data.map((e) => OrderDetailModel.fromJson(e)).toList();
  }
}
