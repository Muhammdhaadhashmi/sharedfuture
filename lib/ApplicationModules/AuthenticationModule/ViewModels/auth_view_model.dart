import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/Models/user_model.dart';

import '../../../LocalDatabaseHelper/local_database_handler.dart';
import '../../../Utils/api_services.dart';
import '../../BusinessModule/Views/add_business_view.dart';
import '../../HomeModule/Views/app_route_view.dart';
import '../../VerificationModule/Views/verification_view.dart';
import '../ApiServices/auth_apis.dart';

class AuthViewModel extends GetxController {
  LocalDatabaseHepler db = LocalDatabaseHepler();
  RxList<UserModel> currentUserList = <UserModel>[].obs;
  RxList<UserModel> allUserList = <UserModel>[].obs;
  RxBool loading = false.obs;

  Future getUserEmail(
      {required String email, required String selectedType}) async {
    currentUserList.value.clear();
    getUserFromApis().then((value) {
      currentUserList.value = UserModel.jsonToListView(value)
          .where((element) => element.customerEmail == email)
          .toList();
      print(currentUserList.value[0].customerName);
      print(currentUserList.value[0].customerId);
      db.insertCustomer(
          userList: currentUserList.value, tableName: "tbl_users");
      db
          .insertCustomer(
              userList: currentUserList.value, tableName: "tbl_login")
          .then((value) {
        print("value");
        print(value);
        if (value > 0) {
          loading.value = false;
          if(selectedType == "Customer"){
            db
                .checkUserVarified(
              email: email,
            )
                .then((res) async {
              if (res != "0") {
                await db.insertUserForLogin(
                    email: email);
                Get.offAll(
                  AppRouteView(),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 600),
                );
              } else {
                Get.offAll(
                  VerificationView(
                      email: email, forget: false),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 600),
                );
              }
            });
          }else{
            Get.offAll(
              AddBusinessView(email: email),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 600),
            );
          }


        }
      });
    });
  }

  Future offlineAppUsers() async {
    allUserList.value.clear();
    getUserFromApis().then((value) {
      allUserList.value = UserModel.jsonToListView(value);

      db.insertCustomer(
          userList: allUserList.value, tableName: "tbl_users").then((value) {
              Get.off(
                AppRouteView(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: 600),
              );
      });

    });
  }


}
