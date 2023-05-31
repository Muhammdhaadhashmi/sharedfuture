import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/ApisServices/business_apis.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Models/business_model.dart';

import '../../ProductsModule/ApiServices/product_apis.dart';
import '../../ProductsModule/Models/product_model.dart';
import '../../ProfileModule/ViewModels/profile_view_model.dart';

class FavirateViewModel extends GetxController {
  RxList<ProductModel> favproductList = <ProductModel>[].obs;
  RxList<BusinessModel> favbusinessList = <BusinessModel>[].obs;
  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  getProducts() async {
    favproductList.value.clear();
    print("object");
    profileViewModel.getProFavirateFromApis();
    getProductsFromApis().then((value) {
      for (final fav in profileViewModel.profavirateList.value) {
        // favproductList.value = ProductModel.jsonToListView(value)
        //     .where(
        //       (element) => element.id == fav.proId
        //     )
        //     .toList();
        favproductList.addAll(ProductModel.jsonToListView(value)
            .where((element) => element.id == fav.proId).toList());
      }
    });
  }

  getFavBusiness() async {
    favbusinessList.value.clear();
    profileViewModel.getBusinessFavirateFromApis();
    getBusinessFromApis().then((value) {
      for (final fav in profileViewModel.busfavirateList.value) {
        // favproductList.value = ProductModel.jsonToListView(value)
        //     .where(
        //       (element) => element.id == fav.proId
        //     )
        //     .toList();
        favbusinessList.addAll(BusinessModel.jsonToListView(value)
            .where((element) => element.businessId == fav.busId).toList());
      }
    });
  }
}
