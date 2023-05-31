class BannerModel {
  BannerModel({
    required this.bannerId,
    required this.bannerImg,
    required this.bannerStatus,
  });

  int bannerId;
  String bannerImg;
  String bannerStatus;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        bannerId: int.parse(json["banner_id"]??"0"),
        bannerImg: json["banner_img"]??"",
        bannerStatus: json["banner_status"]??"",
      );

  Map<String, dynamic> toJson() => {
        "banner_id": bannerId,
        "banner_img": bannerImg,
        "banner_status": bannerStatus,
      };

  static List<BannerModel> jsonToListView(List<dynamic> data) {
    return data.map((e) => BannerModel.fromJson(e)).toList();
  }
}
