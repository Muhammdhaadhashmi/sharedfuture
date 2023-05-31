import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_future/ApplicationModules/AuthenticationModule/Views/sign_in_view.dart';
import 'package:shared_future/ApplicationModules/HomeModule/Views/app_route_view.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:shared_future/Utils/text_view.dart';
import 'package:http/http.dart' as http;

import 'ApplicationModules/AuthenticationModule/ViewModels/auth_view_model.dart';
import 'ApplicationModules/CartModule/ViewModels/cart_view_model.dart';
import 'LocalDatabaseHelper/local_database_handler.dart';
import 'Utils/dimensions.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  LocalDatabaseHepler db = LocalDatabaseHepler();
  AuthViewModel authViewModel = Get.put(AuthViewModel());
  CartViewModel cartViewModel = Get.put(CartViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createLocalDB();
    cartViewModel.getCartCount();

    // Timer(Duration(seconds: 3), () {
    //   Get.off(
    //     SelectionView(),
    //     transition: Transition.rightToLeft,
    //     duration: Duration(milliseconds: 600),
    //   );
    // });
    getApiHeader();
  }

  getApiHeader() async {
    await http
        .get(Uri.parse("https://www.new.reedspak.org/api/getdirectory"))
        .then((value) {
      // print(value.body);
      print(jsonDecode(value.body));

      String apiHeader = jsonDecode(value.body)[0]["dir_name"];
      String ImageDir = jsonDecode(value.body)[1]["dir_name"];
      GetStorage().write("apiHeader", apiHeader);
      GetStorage().write("ImageDir", ImageDir);
      db.deleteTable(tableName: "tbl_users");
      authViewModel.offlineAppUsers();
    });
  }

  void createLocalDB() async {
    if (await db.databaseExists()) {
      print("exists");
    } else {
      await db.initLocalDatabase();
      print("creating");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        height: Dimensions.screenHeight(context),
        width: Dimensions.screenWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AddVerticalSpace(1),
            Image.asset(
              "assets/Images/logo.jpg",
              width: Dimensions.screenWidth(context) - 100,
            ),
            Column(
              children: [
                CircularProgressIndicator(),
                AddVerticalSpace(20),
                TextView(
                  text: "Loading...",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
