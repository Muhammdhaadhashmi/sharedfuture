

class ProFavirateModel {
  ProFavirateModel({
    this.id,
    required this.userId,
    required this.proId,
  });

  int? id;
  int userId;
  int proId;

  factory ProFavirateModel.fromJson(Map<String, dynamic> json) => ProFavirateModel(
    id: int.parse(json["id"]??"0"),
    userId: int.parse(json["user_id"]??"0"),
    proId: int.parse(json["pro_id"]??"0"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "pro_id": proId,
  };


  static List<ProFavirateModel> jsonToListView(List<dynamic> data) {
    return data.map((e) => ProFavirateModel.fromJson(e)).toList();
  }
}
