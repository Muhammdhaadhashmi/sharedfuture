class CategoryModel {
  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.category_type,
    required this.categoryImage,
    required this.categoryStatus,
  });

  int categoryId;
  String categoryName;
  int category_type;
  String categoryImage;
  String categoryStatus;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryId: int.parse(json["category_id"] ?? 0),
        category_type: int.parse(json["category_type"] ?? "0"),
        categoryName: json["category_name"] ?? "",
        categoryImage: json["category_img"] ?? "",
        categoryStatus: json["category_status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_img": categoryImage,
        "category_status": categoryStatus,
      };

  static List<CategoryModel> jsonToListView(List<dynamic> data) {
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }
}
