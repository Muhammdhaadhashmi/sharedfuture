import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Models/business_model.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Views/add_business_view.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Views/business_detail_view.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';
import 'package:shared_future/ApplicationModules/HomeModule/Views/app_route_view.dart';
import 'package:shared_future/ApplicationModules/OrderModule/Views/order_list_view.dart';
import 'package:shared_future/LocalDatabaseHelper/local_database_handler.dart';
import 'package:shared_future/Utils/dimensions.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:shared_future/Utils/text_view.dart';

import '../../../Utils/app_colors.dart';
import '../../AuthenticationModule/Views/sign_in_view.dart';
import '../../BusinessModule/ViewModels/business_view_model.dart';
import '../../CategoryModule/ViewModels/category_view_model.dart';
import '../../HomeModule/ViewModels/home_view_model.dart';
import '../../OrderModule/Views/order_history_view.dart';
import '../../ProfileModule/ViewModels/profile_view_model.dart';
import '../../ProfileModule/Views/profile_view.dart';
import 'Components/account_list_item.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  List accountList = [];
  List noAccountList = [];
  List customerAccountList = [];

  // ProfileViewModel profileViewModel = Get.put(ProfileViewModel());
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  BusinessViewModel businessViewModel = Get.put(BusinessViewModel());
  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    noAccountList = [
      {
        "title": "Sign in",
        "image": Icons.login,
        "onTap": SignInView(),
      },
    ];

    customerAccountList = [
      {
        "title": "Profile",
        "image": Icons.person_outline_outlined,
        "onTap": ProfileView(),
      },
      {
        "title": "Orders",
        "image": Icons.shopping_basket_outlined,
        "onTap": OrderListView(),
      },
      {
        "title": "Order History",
        "image": Icons.history_edu_outlined,
        "onTap": OrderHistoryView(),
      },
      {
        "title": "Log out",
        "image": Icons.logout_outlined,
        "onTap": AppRouteView(),
      },
    ];
    accountList = [
      {
        "title": "Profile",
        "image": Icons.person_outline_outlined,
        "onTap": ProfileView(),
      },
      {
        "title": businessViewModel.businessName.value != ""
            ? "Business"
            : "Add Business",
        "image": Icons.business_outlined,
        "onTap": BusinessDetailsView(
          isMY: true,
          businessModel: BusinessModel(
            shippingCharges: businessViewModel.shipping.value,
            businessId: businessViewModel.businessId.value,
            businessName: businessViewModel.businessName.value,
            user_id: businessViewModel.user_id.value,
            businessNumber: businessViewModel.businessNumber.value,
            businessCategory: businessViewModel.businessCategory.value,
            businessAddress: businessViewModel.businessAddress.value,
            businessDescription: businessViewModel.businessDescription.value,
            businessImage: businessViewModel.businessImage.value,
            businessLocationLat: businessViewModel.businessLocationLat.value,
            businessLocationLng: businessViewModel.businessLocationLng.value,
            businessStatus: businessViewModel.businessStatus.value,
          ),
        ),
      },
      {
        "title": "Orders",
        "image": Icons.shopping_basket_outlined,
        "onTap": OrderListView(),
      },
      {
        "title": "Order History",
        "image": Icons.history_edu_outlined,
        "onTap": OrderHistoryView(),
      },
      {
        "title": "Log out",
        "image": Icons.logout_outlined,
        "onTap": AppRouteView(),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.screenHeight(context),
        width: Dimensions.screenWidth(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientLight,
              AppColors.gradientDark,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddVerticalSpace(50),
              TextView(
                text: "Account",
                fontSize: 20,
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
              Container(
                height: Dimensions.screenHeight(context) - 130,
                width: Dimensions.screenWidth(context),
                // color: AppColors.pink,
                child: Obx(() => ListView.builder(
                      itemCount: homeViewModel.acountExit == 1
                          ? profileViewModel.localCurrentUserList.value[0]
                                      .customer_type ==
                                  "Business"
                              ? accountList.length
                              : customerAccountList.length
                          : noAccountList.length,
                      itemBuilder: (context, index) {
                        return AccountListItem(
                          listItem: homeViewModel.acountExit == 1
                              ? profileViewModel.localCurrentUserList.value[0]
                                          .customer_type ==
                                      "Business"
                                  ? accountList[index]
                                  : customerAccountList[index]
                              : noAccountList[index],
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
