import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_future/Utils/token.dart';
import '../../../LocalDatabaseHelper/local_database_handler.dart';
import '../../../Utils/api_services.dart';
import '../../AuthenticationModule/ApiServices/auth_apis.dart';
import '../../FavirateModule/Models/bus_fav_model.dart';
import '../../FavirateModule/Models/pro_favirate_model.dart';
import '../Models/user_model.dart';

class ProfileViewModel extends GetxController {
  RxList<UserModel> localCurrentUserList = <UserModel>[].obs;
  RxList<UserModel> currentUserList = <UserModel>[].obs;
  RxList<ProFavirateModel> profavirateList = <ProFavirateModel>[].obs;
  RxList<BusFavirateModel> busfavirateList = <BusFavirateModel>[].obs;
  LocalDatabaseHepler db = LocalDatabaseHepler();
  RxList profileList = [].obs;
  RxBool loading = false.obs;


  getProFavirateFromApis(){
    http.get(Uri.parse("${Token.apiHeader}getProductFvrt/${localCurrentUserList.value[0].customerId}")).then((value) {
      profavirateList.value =  ProFavirateModel.jsonToListView(jsonDecode(value.body));
    });
  }

  getBusinessFavirateFromApis(){
    http.get(Uri.parse("${Token.apiHeader}getBusinessFvrt/${localCurrentUserList.value[0].customerId}")).then((value) {
      busfavirateList.value =  BusFavirateModel.jsonToListView(jsonDecode(value.body));
    });
  }

  getImageFromApis({required int id}) {
    getUserFromApis().then((value) {
      currentUserList.value = UserModel.jsonToListView(value)
          .where((element) => element.customerId == id)
          .toList();

      UserModel model = UserModel(
        customerId: id,
        customerName: currentUserList.value[0].customerName,
        is_verified: currentUserList.value[0].is_verified,
        customerPhone: currentUserList.value[0].customerPhone,
        customerEmail: currentUserList.value[0].customerEmail,
        customerPassword: currentUserList.value[0].customerPassword,
        customerAddress: currentUserList.value[0].customerAddress,
        customerStatus: currentUserList.value[0].customerStatus,
        customerImage: currentUserList.value[0].customerImage,
        customer_type: currentUserList.value[0].customer_type,
        customerLocationLat: currentUserList.value[0].customerLocationLat,
        customerLocationLng: currentUserList.value[0].customerLocationLng,
      );

      db.updateProfile(
        userModel: model,
        tableName: "tbl_login",
      );
      db.updateProfile(
        userModel: model,
        tableName: "tbl_users",
      );
      getCurrentUser();
      Get.back();
    });
  }

  Future getCurrentUser() async {
    await db.fetchCurrentUser().then((value) {
      localCurrentUserList.value = value;
      loading.value = false;
    });

    profileList.value = [
      {
        "title": "Email",
        "data": "${localCurrentUserList.value[0].customerEmail}",
        "icon": Icons.email_outlined,
      },
      {
        "title": "Phone Number",
        "data": "${localCurrentUserList.value[0].customerPhone}",
        "icon": Icons.phone_android,
      },
      {
        "title": "Address",
        "data": "${localCurrentUserList.value[0].customerAddress}",
        "icon": Icons.location_on_outlined,
      },
      {
        "title": "Change Password",
        "data": "******",
        "icon": Icons.lock_outline,
      },
    ];
  }
}
