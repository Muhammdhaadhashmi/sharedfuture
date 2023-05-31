import 'package:get/get.dart';

import '../../../LocalDatabaseHelper/local_database_handler.dart';
import '../ApisServices/home_apis.dart';
import '../Models/banner_model.dart';

class HomeViewModel extends GetxController{
  LocalDatabaseHepler db = LocalDatabaseHepler();

  RxString searchRes = ''.obs;
  RxInt index = 0.obs;
  RxInt acountExit = 0.obs;
  RxList<BannerModel> bannerList = <BannerModel>[].obs;
  Future checkAcountExits() async{
   await db.checkDataExistenceByLength(table: "tbl_login").then((value) {
      print(value);
      acountExit.value = value;
    });
    print(acountExit.value);
  }
  getBanners() async {
    getBannersFromApis().then((value) {
      bannerList.value = BannerModel.jsonToListView(value);
    });
  }

}