import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/text_view.dart';

import '../../../Utils/dimensions.dart';
import '../../BusinessModule/Models/business_model.dart';
import '../../BusinessModule/ViewModels/business_view_model.dart';
import '../../BusinessModule/Views/Components/business_list_item.dart';
import '../ViewModels/explore_view_model.dart';

class BusinessExploreView extends StatefulWidget {
  const BusinessExploreView({Key? key}) : super(key: key);

  @override
  State<BusinessExploreView> createState() => _BusinessExploreViewState();
}

class _BusinessExploreViewState extends State<BusinessExploreView> {
  ExploreViewModel exploreViewModel = Get.put(ExploreViewModel());

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    exploreViewModel.getBusiness();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    exploreViewModel.exploreIndex.value = 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    exploreViewModel.search.value.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: Dimensions.screenHeight(context),
        // width: Dimensions.screenWidth(context),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: SmartRefresher(
            enablePullDown: true,
            physics: BouncingScrollPhysics(),
            controller: refreshController,
            header: ClassicHeader(
              refreshingIcon: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              ),
              refreshingText: "Loading...",
              releaseIcon: Icon(
                Icons.keyboard_arrow_up_outlined,
                color: AppColors.white,
              ),
              completeText: "Done",
              completeIcon: Icon(
                Icons.done,
                color: AppColors.white,
              ),
              textStyle: TextStyle(
                color: AppColors.white,
              ),
              idleIcon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.white,
              ),
            ),
            onRefresh: onRefresh,
            onLoading: onLoading,
            child: FutureBuilder(
                future: exploreViewModel.getBusiness(),
                builder: (context, snapshot) {
                  return Obx(() => GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 00,
                          mainAxisSpacing: 0,
                          childAspectRatio: 0.8,
                          // mainAxisExtent: 150,
                        ),
                        itemCount: exploreViewModel.businessList.value.length,
                        itemBuilder: (context, index) {
                          var data = exploreViewModel.businessList.value[index];
                          return BusinessListItem(
                            businessModel: BusinessModel(
                              businessId: data.businessId,
                              shippingCharges: data.shippingCharges,
                              businessName: data.businessName,
                              user_id: data.user_id,
                              businessNumber: data.businessNumber,
                              businessCategory: data.businessCategory,
                              businessAddress: data.businessAddress,
                              businessDescription: data.businessDescription,
                              businessImage: data.businessImage,
                              businessLocationLat: data.businessLocationLat,
                              businessLocationLng: data.businessLocationLng,
                              businessStatus: data.businessStatus,
                            ),
                          );
                        },
                      ));
                }),
          ),
        ),
      ),
    );
  }
}
