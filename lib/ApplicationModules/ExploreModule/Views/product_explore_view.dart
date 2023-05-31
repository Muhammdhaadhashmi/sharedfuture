import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/text_view.dart';

import '../../ProductsModule/Models/product_model.dart';
import '../../ProductsModule/ViewModels/product_view_model.dart';
import '../../ProductsModule/Views/Components/product_list_item.dart';
import '../ViewModels/explore_view_model.dart';

class ProductExploreView extends StatefulWidget {
  const ProductExploreView({Key? key}) : super(key: key);

  @override
  State<ProductExploreView> createState() => _ProductExploreViewState();
}

class _ProductExploreViewState extends State<ProductExploreView> {
  ExploreViewModel exploreViewModel = Get.put(ExploreViewModel());
  RefreshController refreshController = RefreshController(initialRefresh: true);

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    exploreViewModel.getProducts();
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
    exploreViewModel.exploreIndex.value = 1;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    exploreViewModel.search.value.text = "";

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradientLight,
            AppColors.gradientDark,

          ],
          begin: Alignment.topCenter,
          end: Alignment. bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: SmartRefresher(
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: FutureBuilder(
                future: exploreViewModel.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
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
                        itemCount: exploreViewModel.productList.value.length,
                        itemBuilder: (context, index) {
                          var data = exploreViewModel.productList.value[index];
                          return ProductListItem(
                            productModel: ProductModel(
                              businessManID: data.businessManID,
                              id: data.id,
                              property: data.property,
                              unit: data.unit,
                              proName: data.proName,
                              businessID: data.businessID,
                              detail: data.detail,
                              proCat: data.proCat,
                              proDis: data.proDis,
                              costPrice: data.costPrice,
                              salePrice: data.salePrice,
                              discountPrice: data.discountPrice,
                              totalQty: data.totalQty,
                              saleQty: data.saleQty,
                              proImg: data.proImg,
                              proStatus: data.proStatus,
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
