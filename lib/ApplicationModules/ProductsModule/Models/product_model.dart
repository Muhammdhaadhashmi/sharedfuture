// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    required this.proName,
    required this.businessID,
    required this.businessManID,
    required this.detail,
    required this.proCat,
    required this.proDis,
    required this.costPrice,
    required this.salePrice,
    required this.discountPrice,
    required this.totalQty,
    required this.saleQty,
    required this.proImg,
    required this.proStatus,
    required this.property,
    required this.unit,
  });

  int? id;
  int businessID;
  int businessManID;
  String proName;
  String property;
  String unit;
  String detail;
  int proCat;
  String proDis;
  int costPrice;
  int salePrice;
  int discountPrice;
  int totalQty;
  int saleQty;
  String proImg;
  String proStatus;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"] ?? 0,
        businessManID: int.parse(json["business_mid"] ?? "0"),
        proName: json["pro_name"] ?? "",
        detail: json["detail"] ?? "",
        proCat: int.parse(json["pro_cat"] ?? "0"),
        proDis: json["pro_dis"] ?? "",
        unit: json["unit"] ?? "",
        property: json["property"] ?? "",
        costPrice: int.parse(json["cost_price"] ?? "0"),
        salePrice: int.parse(json["sale_price"] ?? "0"),
        discountPrice: int.parse(json["discount_price"] ?? "0"),
        totalQty: int.parse(json["total_qty"] ?? "0"),
        saleQty: int.parse(json["sale_qty"] ?? "0"),
        proImg: json["pro_img"] ?? "",
        proStatus: json["pro_status"] ?? "",
        businessID: int.parse(json["business_id"] ?? "0"),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pro_name": proName,
        "business_mid": businessManID,
        "detail": detail,
        "property": property,
        "unit": unit,
        "pro_cat": proCat,
        "pro_dis": proDis,
        "cost_price": costPrice,
        "sale_price": salePrice,
        "discount_price": discountPrice,
        "total_qty": totalQty,
        "sale_qty": saleQty,
        "pro_img": proImg,
        "pro_status": proStatus,
        "business_id": businessID,
      };

  static List<ProductModel> jsonToListView(List<dynamic> data) {
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
