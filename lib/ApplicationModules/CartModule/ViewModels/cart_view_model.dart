import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/CartModule/Models/cart_model.dart';

import '../../../LocalDatabaseHelper/local_database_handler.dart';

class CartViewModel extends GetxController {
  LocalDatabaseHepler db = LocalDatabaseHepler();
  RxList<CartModel> carList = <CartModel>[].obs;

  RxInt quantity = 1.obs;
  RxInt singleProductPrice = 1.obs;
  RxInt total = 0.obs;
  RxInt cartCount = 0.obs;
  RxInt shipping = 0.obs;
  RxInt businessId = 0.obs;

  getCartCount() {
    db.checkDataExistenceByLength(table: "tbl_cart").then((value) {
      cartCount.value = value;
    });
  }



  getCartFromLocal() {
    db.fetchCart().then((value) {
      carList.value = value;
      if(carList.value.length!=0){
        shipping.value = carList.value[0].shippingCharges;
        businessId.value = carList.value[0].businessId;
        total.value = 0;
        for(int i=0;i<value.length;i++){
          total.value += value[i].Price;
        }
      }

    });
  }
}
