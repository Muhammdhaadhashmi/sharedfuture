import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/AccountModule/Views/account_view.dart';
import 'package:shared_future/ApplicationModules/CartModule/Views/cart_view.dart';
import 'package:shared_future/ApplicationModules/ExploreModule/Views/explore_view.dart';
import 'package:shared_future/ApplicationModules/HomeModule/ViewModels/home_view_model.dart';

import '../../../LocalDatabaseHelper/local_database_handler.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/text_view.dart';
import '../../BusinessModule/ViewModels/business_view_model.dart';
import '../../CartModule/ViewModels/cart_view_model.dart';
import '../../FavirateModule/Views/favirate_view.dart';
import '../../ProfileModule/ViewModels/profile_view_model.dart';
import 'home_view.dart';

class AppRouteView extends StatefulWidget {
  const AppRouteView({Key? key}) : super(key: key);

  @override
  State<AppRouteView> createState() => _AppRouteViewState();
}

class _AppRouteViewState extends State<AppRouteView> {
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());
  BusinessViewModel businessViewModel = Get.put(BusinessViewModel());
  CartViewModel cartViewModel = Get.put(CartViewModel());

  List selectedIcons = [];
  List noAccountselectedIcons = [];
  List unselectedIcons = [];
  List noAccountunselectedIcons = [];

  List label = [];
  List noAcountlabel = [];

  List ViewList = [];
  List noAccountViewList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartViewModel.getCartCount();
    homeViewModel.checkAcountExits().then((value) {
      if (homeViewModel.acountExit == 1) {
        profileViewModel.getCurrentUser().then((value) {
          businessViewModel.getCurrentBusiness(
              userId:
                  profileViewModel.localCurrentUserList.value[0].customerId!);
        });
      }
    });

    noAcountlabel = [
      "Home",
      "Explore",
      "Cart",
      "Account",
    ];
    label = [
      "Home",
      "Explore",
      "Cart",
      "Favorite",
      "Account",
    ];
    noAccountunselectedIcons = [
      Icon(Icons.home_outlined),
      Icon(Icons.search_outlined),
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.shopping_cart_outlined,
              // color: AppColors.mainColor,
            ),
          ),
          cartViewModel.cartCount.value != 0
              ? Positioned(
                  top: 0,
                  right: 2,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Obx(() => TextView(
                            // text: "10",
                            text: "${cartViewModel.cartCount.value}",
                            fontSize: 10,
                            color: AppColors.white,
                          )),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      Icon(Icons.account_circle_outlined),
    ];
    unselectedIcons = [
      Icon(Icons.home_outlined),
      Icon(Icons.search_outlined),
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.shopping_cart_outlined,
              // color: AppColors.mainColor,
            ),
          ),
          cartViewModel.cartCount.value != 0
              ? Positioned(
            top: 0,
            right: 2,
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Obx(() => TextView(
                  // text: "10",
                  text: "${cartViewModel.cartCount.value}",
                  fontSize: 10,
                  color: AppColors.white,
                )),
              ),
            ),
          )
              : SizedBox(),
        ],
      ),

      Icon(Icons.favorite_border),
      Icon(Icons.account_circle_outlined),
    ];

    selectedIcons = [
      Icon(Icons.home),
      Icon(Icons.search),
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.shopping_cart,
              color: AppColors.mainColor,
            ),
          ),
          cartViewModel.cartCount.value != 0
              ? Positioned(
                  top: 0,
                  right: 2,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Obx(() => TextView(
                            text: "${cartViewModel.cartCount.value}",
                            fontSize: 10,
                            color: AppColors.white,
                          )),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      Icon(Icons.favorite),
      Icon(Icons.account_circle),
    ];
    noAccountselectedIcons = [
      Icon(Icons.home),
      Icon(Icons.search),
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.shopping_cart_outlined,
              // color: AppColors.mainColor,
            ),
          ),
          cartViewModel.cartCount.value != 0
              ? Positioned(
                  top: 0,
                  right: 2,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Obx(() => TextView(
                            // text: "10",
                            text: "${cartViewModel.cartCount.value}",
                            fontSize: 10,
                            color: AppColors.white,
                          )),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      Icon(Icons.account_circle),
    ];
    noAccountViewList = [
      HomeView(),
      ExploreView(),
      CartView(),
      AccountView(),
    ];
    ViewList = [
      HomeView(),
      ExploreView(),
      CartView(),
      FavirateView(),
      AccountView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () {
            if (homeViewModel.index.value != 0) {
              homeViewModel.index.value = 0;
              return Future(() => false);
            } else {
              SystemNavigator.pop();
              return Future(() => true);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: homeViewModel.acountExit.value == 1
                ? ViewList.elementAt(homeViewModel.index.value)
                : noAccountViewList.elementAt(homeViewModel.index.value),
            bottomNavigationBar: homeViewModel.acountExit.value == 1
                ? BottomNavigationBar(
                    unselectedItemColor: AppColors.grey,
                    selectedItemColor: AppColors.mainColor,
                    currentIndex: homeViewModel.index.value,
                    onTap: (value) {
                      homeViewModel.index.value = value;
                      print(value);
                    },
                    items: [
                      for (int i = 0; i < selectedIcons.length; i++)
                        BottomNavigationBarItem(
                          icon: homeViewModel.index.value == i
                              ? selectedIcons[i]
                              : unselectedIcons[i],
                          label: "${label[i]}",
                          tooltip: "${label[i]}",
                        ),
                    ],
                  )
                : BottomNavigationBar(
                    // backgroundColor: AppColors.gradientDark,
                    unselectedItemColor: AppColors.grey,
                    selectedItemColor: AppColors.mainColor,
                    currentIndex: homeViewModel.index.value,
                    onTap: (value) {
                      setState(() {
                        homeViewModel.index.value = value;
                      });
                    },
                    items: [
                      for (int i = 0; i < noAccountselectedIcons.length; i++)
                        BottomNavigationBarItem(
                          icon: homeViewModel.index.value == i
                              ? noAccountselectedIcons[i]
                              : noAccountunselectedIcons[i],
                          label: "${noAcountlabel[i]}",
                          tooltip: "${noAcountlabel[i]}",
                        ),
                    ],
                  ),
          ),
        ));
  }
}
