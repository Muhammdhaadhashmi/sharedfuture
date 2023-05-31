import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/HomeModule/Views/app_route_view.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/btn.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_view.dart';

class OrderSuccessView extends StatefulWidget {
  const OrderSuccessView({Key? key}) : super(key: key);

  @override
  State<OrderSuccessView> createState() => _OrderSuccessViewState();
}

class _OrderSuccessViewState extends State<OrderSuccessView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Container(
        height: Dimensions.screenHeight(context),
        width: Dimensions.screenWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_done_outlined,
              size: 130,
              color: AppColors.white,
            ),
            TextView(
              text: "Success!",
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            AddVerticalSpace(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextView(
                text: "Your order has been successfully Placed!",
                textAlign: TextAlign.center,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BTN(
          title: "Back to Home",
          color: AppColors.white,
          textColor: AppColors.green,
          onPressed: () {
            Get.offAll(
              AppRouteView(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 600),
            );
          },
          width: Dimensions.screenWidth(context),
        ),
      ),
    );
  }
}