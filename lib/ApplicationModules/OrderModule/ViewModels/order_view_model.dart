import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/OrderModule/Models/order_detail_model.dart';
import 'package:shared_future/ApplicationModules/ProductsModule/Models/product_model.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/ViewModels/profile_view_model.dart';

import '../../../Utils/api_services.dart';
import '../../ProductsModule/ApiServices/product_apis.dart';
import '../../ProfileModule/Models/user_model.dart';
import '../Models/order_model.dart';

class OrderViewModel extends GetxController {
  RxList<OrderModel> orderList = <OrderModel>[].obs;
  RxList<OrderModel> ordehistoryrList = <OrderModel>[].obs;
  RxList<OrderDetailModel> orderdetailList = <OrderDetailModel>[].obs;
  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<ProductModel> orderPorList = <ProductModel>[].obs;
  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  getOrders() async {
    orderList.value.clear();
    print( "profileViewModel.localCurrentUserList.value[0].customerId");
    print( profileViewModel.localCurrentUserList.value[0].customerId);
    getOrdersFromAPIS(
            id: profileViewModel.localCurrentUserList.value[0].customerId!)
        .then((value) {
      orderList.value = OrderModel.jsonToListView(value).where((element) => element.orderStatus=="pending").toList();
    });
  }

  getDetailOrders({required int id}) async {
    orderdetailList.value.clear();
    orderPorList.value.clear();
    getOrdersDetailsFromAPIS(id: id).then((value) {
      orderdetailList.value = OrderDetailModel.jsonToListView(value);
      print(orderdetailList.value.length);

      List proid = [];
      for (final val in orderdetailList.value) {
        proid.add(val.productId);
      }
      getProductsFromApis().then((value) {
        orderPorList.value = ProductModel.jsonToListView(value)
            .where((element) => proid.contains(element.id))
            .toList();
      });
      print(orderPorList.value.length);
    });
  }

  getOrdersHistory() async {
    ordehistoryrList.value.clear();
    getOrdersFromAPIS(
            id: profileViewModel.localCurrentUserList.value[0].customerId!)
        .then((value) {
      ordehistoryrList.value = OrderModel.jsonToListView(value)
          .where((element) => element.orderStatus == "success")
          .toList();
    });
  }

  getCustomerOnId({required int id}) {
    userList.value.clear();
    getUserFromApis().then((value) {
      userList.value = UserModel.jsonToListView(value)
          .where((element) => element.customerId == id)
          .toList();
    });
  }
}
