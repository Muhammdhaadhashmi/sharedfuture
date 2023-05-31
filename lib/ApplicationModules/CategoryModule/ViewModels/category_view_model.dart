import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';

import '../../BusinessModule/ApisServices/business_apis.dart';
import '../../BusinessModule/Models/business_model.dart';
import '../ApiServices/category_apis.dart';

class CategoryViewModel extends GetxController {
  RxList<CategoryModel> bussinessCategoryList = <CategoryModel>[].obs;
  RxList<CategoryModel> bussinessCatList = <CategoryModel>[].obs;
  RxList<CategoryModel> productCategoryList = <CategoryModel>[].obs;

  RxList<BusinessModel> catBusinessList = <BusinessModel>[].obs;

  getCAtegoryBusiness({required int cat}) async {
    catBusinessList.value.clear();
    getBusinessFromApis().then((value) {
      catBusinessList.value = BusinessModel.jsonToListView(value).where((element) => element.businessCategory==cat).toList();
    });
  }
  getBussinessCategories() async {
    bussinessCategoryList.value.clear();
    getCategoriesFromApis().then((value) {
      bussinessCategoryList.value = CategoryModel.jsonToListView(value)
          .where((element) => element.category_type == 0)
          .toList();
    });
  }

  Future getProductCategories() async {
    productCategoryList.value.clear();
    getCategoriesFromApis().then((value) {
      productCategoryList.value = CategoryModel.jsonToListView(value)
          .where((element) => element.category_type == 1)
          .toList();
      print(productCategoryList.value.length);
    });
  }
}
