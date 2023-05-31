import 'package:flutter/material.dart';
import 'package:shared_future/ApplicationModules/FavirateModule/Views/product_favirate_view.dart';
import 'package:shared_future/ApplicationModules/FavirateModule/Views/business_favirate_view.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_view.dart';

class FavirateView extends StatefulWidget {
  const FavirateView({Key? key}) : super(key: key);

  @override
  State<FavirateView> createState() => _FavirateViewState();
}

class _FavirateViewState extends State<FavirateView>
    with TickerProviderStateMixin {
  TextEditingController search = TextEditingController();

  TabController? controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(

        height: Dimensions.screenHeight(context),
        width: Dimensions.screenWidth(context),
        color: AppColors.gradientLight,

        child: Column(
          children: [
            AddVerticalSpace(50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextView(
                text: "Favorite",
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            AddVerticalSpace(10),
            Container(
              color: AppColors.gradientLight,

              child: TabBar(
                controller: controller,
                indicatorColor: AppColors.white,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.white,
                tabs: [
                  Tab(child: TextView(text: "Business")),
                  Tab(child: TextView(text: "Products")),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: [
                  BusinessFavirateView(),
                  ProductFavirateView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
