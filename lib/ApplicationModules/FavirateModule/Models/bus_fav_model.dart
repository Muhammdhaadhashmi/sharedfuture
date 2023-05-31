

class BusFavirateModel {
  BusFavirateModel({
    this.id,
    required this.userId,
    required this.busId,
  });

  int? id;
  int userId;
  int busId;

  factory BusFavirateModel.fromJson(Map<String, dynamic> json) => BusFavirateModel(
    id: int.parse(json["id"]??"0"),
    userId: int.parse(json["user_id"]??"0"),
    busId: int.parse(json["business_id"]??"0"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "business_id": busId,
  };


  static List<BusFavirateModel> jsonToListView(List<dynamic> data) {
    return data.map((e) => BusFavirateModel.fromJson(e)).toList();
  }
}
