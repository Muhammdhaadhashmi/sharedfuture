import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/ProductsModule/ApiServices/product_apis.dart';

import '../Models/product_model.dart';

class ProductViewModel extends GetxController {
  RxList<ProductModel> productList = <ProductModel>[].obs;
  getProducts() async {
    productList.value.clear();
    getProductsFromApis().then((value) {
      productList.value = ProductModel.jsonToListView(value);
    });
  }


  getBussinessProducts({required int businessId}) async {
    productList.value.clear();
    getProductsFromApis().then((value) {
      productList.value = ProductModel.jsonToListView(value).where((element) => element.businessID==businessId).toList();
    });
  }
}
