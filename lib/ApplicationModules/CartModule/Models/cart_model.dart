class CartModel {
  final int? id;
  final int productId;
  final int businessId;
  final int businessManId;
  final String businessName;
  final String businessContact;
  final String businessAddress;
  final String productName;
  final int discountPrice;
  final int salePrice;
  final int saleQuantity;
  final int quantity;
  final String image;
  final String property;
  final String unit;
  final String des;
  final int Price;
  final int shippingCharges;

  CartModel({
    this.id,
    required this.productId,
    required this.property,
    required this.unit,
    required this.des,
    required this.businessManId,
    required this.businessId,
    required this.businessName,
    required this.businessContact,
    required this.businessAddress,
    required this.productName,
    required this.discountPrice,
    required this.salePrice,
    required this.saleQuantity,
    required this.quantity,
    required this.image,
    required this.Price,
    required this.shippingCharges,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "businessManId": businessManId,
        "productId": productId,
        "property": property,
        "unit": unit,
        "des": des,
        "businessId": businessId,
        "businessName": businessName,
        "businessContact": businessContact,
        "businessAddress": businessAddress,
        "productName": productName,
        "discountPrice": discountPrice,
        "salePrice": salePrice,
        "saleQuantity": saleQuantity,
        "quantity": quantity,
        "image": image,
        "Price": Price,
        "shipping_charges": shippingCharges,
      };

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        image: json['image'] ?? "",
        businessId: json['businessId'] ?? 0,
    property: json['property'] ?? 0,
    unit: json['unit'] ?? 0,
    des: json['des'] ?? 0,
        businessManId: json['businessManId'] ?? 0,
        businessName: json['businessName'] ?? 0,
        businessContact: json['businessContact'] ?? 0,
        businessAddress: json['businessAddress'] ?? 0,
        discountPrice: json['discountPrice'] ?? 0,
        quantity: json['quantity'] ?? 0,
        productId: json['productId'] ?? 0,
        productName: json['productName'] ?? "",
        salePrice: json['salePrice'] ?? 0,
        saleQuantity: json['saleQuantity'] ?? 0,
        id: json['id'] ?? 0,
        Price: json['Price'] ?? 0,
        shippingCharges: json['shipping_charges'] ?? 0,
      );

  static List<CartModel> localToListView(List<dynamic> data) {
    return data.map((e) => CartModel.fromJson(e)).toList();
  }
}
