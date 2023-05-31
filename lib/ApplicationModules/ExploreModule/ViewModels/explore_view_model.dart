import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';

import '../../BusinessModule/ApisServices/business_apis.dart';
import '../../BusinessModule/Models/business_model.dart';
import '../../BusinessModule/ViewModels/business_view_model.dart';
import '../../CategoryModule/ApiServices/category_apis.dart';
import '../../ProductsModule/ApiServices/product_apis.dart';
import '../../ProductsModule/Models/product_model.dart';

class ExploreViewModel extends GetxController {
  RxList<BusinessModel> businessList = <BusinessModel>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  Rx<TextEditingController> search = TextEditingController().obs;

  BusinessViewModel businessViewModel = Get.put(BusinessViewModel());

  RxList<String> LocationList = <String>[
    "Lahore",
    "Karachi",
    "Islamabad",
    "Faisalabad",
    "Sialkot",
    "Rahim Yar Khan",
    "Hyderabad",
    "Multan",
    "Khanpur",
    "Bahawalpur",
  ].obs;

  RxList<String> selectedLocation = <String>[].obs;
  RxList<int> selectedCat = <int>[].obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;

  // RxString searchRes = "".obs;
  RxInt exploreIndex = 0.obs;
  RxDouble toPrice = 0.0.obs;
  RxDouble fromPrice = 0.0.obs;

  getBusiness() async {
    businessList.value.clear();
    getBusinessFromApis().then((value) {
      businessList.value = BusinessModel.jsonToListView(value)
          .where((element) =>
              // selectedCat.value.contains(element.businessCategory) ||
              // businessViewModel.currentBusinessList.value.length != 0
              //     ? element.businessId !=
              //         businessViewModel.currentBusinessList.value[0].businessId
              //     : true &&
              element.businessName
                  .toLowerCase()
                  .contains(search.value.text.toLowerCase()) ||
              element.businessAddress
                  .toLowerCase()
                  .contains(search.value.text.toLowerCase()) ||
              element.businessStatus
                  .toLowerCase()
                  .contains(search.value.text.toLowerCase()) ||
              element.businessNumber
                  .toLowerCase()
                  .contains(search.value.text.toLowerCase()))
          .toList();
    });
    // selectedCat.value.clear();
  }

  getFilterBusiness() async {
    businessList.value.clear();
    getBusinessFromApis().then((value) {
      businessList.value = BusinessModel.jsonToListView(value)
          .where((element) =>
              selectedCat.value.contains(element.businessCategory) ||
              selectedLocation.contains(element.businessAddress))
          .toList();
    });
    // selectedCat.value.clear();
  }

  getProducts() async {
    productList.value.clear();
    getProductsFromApis().then((value) {
      productList.value = ProductModel.jsonToListView(value)
          .where((element) =>
              // businessViewModel.currentBusinessList.value.length != 0
              //     ? element.businessID !=
              //         businessViewModel.currentBusinessList.value[0].businessId
              //     : true &&
              element.proName
                  .toLowerCase()
                  .contains(search.value.text.toLowerCase()) ||
              element.proStatus
                  .toLowerCase()
                  .contains(search.value.text.toLowerCase()))
          .toList();
    });
  }

  getCatProducts() async {
    productList.value.clear();
    getProductsFromApis().then((value) {
      productList.value = ProductModel.jsonToListView(value)
          .where((element) =>
              selectedLocation.value.contains(element.proCat) ||
              (element.salePrice >= fromPrice.value &&
                  element.salePrice <= toPrice.value))
          .toList();
    });
  }

  getAllCategories() async {
    await getCategoriesFromApis().then((value) {
      categoryList.value = CategoryModel.jsonToListView(value)
          .where((element) => element.category_type == exploreIndex.value)
          .toList();
    });
  }

  // getaccountData() async {
  //   productList.value.clear();
  //   getProductsFromApis().then((value) {
  //     productList.value = ProductModel.jsonToListView(value)
  //         .where((element) =>
  //     // businessViewModel.currentBusinessList.value.length != 0
  //     //     ? element.businessID !=
  //     //         businessViewModel.currentBusinessList.value[0].businessId
  //     //     : true &&
  //     element.proName
  //         .toLowerCase()
  //         .contains(search.value.text.toLowerCase()) ||
  //         element.proStatus
  //             .toLowerCase()
  //             .contains(search.value.text.toLowerCase()))
  //         .toList();
  //   });

}
