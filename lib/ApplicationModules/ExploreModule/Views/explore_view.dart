import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/ExploreModule/ViewModels/explore_view_model.dart';
import 'package:shared_future/ApplicationModules/ExploreModule/Views/product_explore_view.dart';
import 'package:shared_future/ApplicationModules/ExploreModule/Views/business_explore_view.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/search_text_field.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_view.dart';
import '../../CartModule/Views/cart_view.dart';
import '../../HomeModule/Views/home_view.dart';
import 'Components/filter_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView>
    with TickerProviderStateMixin {
  ExploreViewModel exploreViewModel = Get.put(ExploreViewModel());

  TabController? controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.screenHeight(context),
        width: Dimensions.screenWidth(context),
        color: AppColors.gradientLight,
        child: Column(
          children: [
            AddVerticalSpace(50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => SearchTextField(
                        // width: Dimensions.screenWidth(context)-40,
                        width: Dimensions.screenWidth(context) - 85,
                        hintText: "Search",
                        textEditingController: exploreViewModel.search.value,
                        prefixIcon: Icon(Icons.search),
                        onFieldSubmitted: (value) {
                          // exploreViewModel.searchRes.value = value;
                          exploreViewModel.getBusiness();
                          exploreViewModel.getProducts();
                        },
                      )),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: AppColors.transparent,
                        builder: (BuildContext context) {
                          return FilterView();
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.filter_alt_rounded,
                        color: AppColors.white,
                      ),
                    ),
                  )
                ],
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
              // height: Dimensions.screenHeight(context) - 209,
              child: TabBarView(
                controller: controller,
                children: [
                  BusinessExploreView(),
                  ProductExploreView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
