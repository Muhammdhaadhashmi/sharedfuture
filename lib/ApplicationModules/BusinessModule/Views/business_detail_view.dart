import 'dart:async';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Models/business_model.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/ViewModels/category_view_model.dart';
import 'package:shared_future/ApplicationModules/HomeModule/ViewModels/home_view_model.dart';
import 'package:shared_future/ApplicationModules/ProductsModule/Models/product_model.dart';
import 'package:shared_future/Utils/token.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/btn.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_view.dart';
import '../../HomeModule/Views/Components/image_list_item.dart';
import '../../ProductsModule/ViewModels/product_view_model.dart';
import '../../ProductsModule/Views/Components/product_list_item.dart';
import '../../ProductsModule/Views/add_product_view.dart';
import 'edit_business_view.dart';

class BusinessDetailsView extends StatefulWidget {
  final BusinessModel businessModel;
  final bool isMY;

  const BusinessDetailsView({
    super.key,
    required this.businessModel,
    required this.isMY,
  });

  @override
  State<BusinessDetailsView> createState() => _BusinessDetailsViewState();
}

class _BusinessDetailsViewState extends State<BusinessDetailsView>
    with TickerProviderStateMixin {
  bool loading = true;
  bool favirate = false;

  ProductViewModel productViewModel = Get.put(ProductViewModel());
  CategoryViewModel categoryViewModel = Get.put(CategoryViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryViewModel.getProductCategories();
    // controller = TabController(
    //     length: categoryViewModel.productCategoryList.value.length,
    //     vsync: this);
  }

  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  RefreshController refreshController = RefreshController(initialRefresh: true);

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    productViewModel.getBussinessProducts(
        businessId: widget.businessModel.businessId!);
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    // await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
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
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddVerticalSpace(45),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.chevron_left,
                            color: AppColors.white,
                          ),
                          Container(
                            width: Dimensions.screenWidth(context) - 200,
                            child: TextView(
                              text: widget.isMY
                                  ? "Business"
                                  : "${widget.businessModel.businessName}",
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              textOverflow: TextOverflow.ellipsis,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        if (widget.isMY) {
                          Get.to(
                            EditBusinessView(
                              businessModel: widget.businessModel,
                            ),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 600),
                          );
                        } else {
                          Navigator.pop(context);
                          homeViewModel.index.value = 1;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          widget.isMY ? Icons.edit_note : Icons.search,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: Dimensions.screenHeight(context) - 168,
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddVerticalSpace(20),
                        Container(
                          color: AppColors.white,
                          child: OptimizedCacheImage(
                            height: Dimensions.screenWidth(context) - 150,
                            width: Dimensions.screenWidth(context),
                            imageUrl:
                                "${Token.ImageDir}${widget.businessModel.businessImage}",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: AppColors.mainColor,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.error,
                              color: AppColors.red,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        AddVerticalSpace(30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Dimensions.screenWidth(context) - 80,
                                child: TextView(
                                  text: "${widget.businessModel.businessName}",
                                  fontSize: 20,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Icon(
                                Icons.favorite_border,
                                color: AppColors.white,
                              )
                            ],
                          ),
                        ),
                        AddVerticalSpace(10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextView(
                            text: "${widget.businessModel.businessAddress}",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        ),
                        AddVerticalSpace(10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: AppColors.white, thickness: 2),
                        ),
                        AddVerticalSpace(10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextView(
                            text: "Products",
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                        ),
                        // FutureBuilder(
                        //     future: categoryViewModel.getProductCategories(),
                        //     builder: (context, snapshot) {
                        //       if (snapshot.hasData) {
                        //         return Obx(() => Container(
                        //           height: 100,
                        //           child: DefaultTabController(
                        //                 length: categoryViewModel
                        //                     .productCategoryList.value.length,
                        //                 // length: categoryViewModel.productCategoryList.value.length,
                        //                 child: Column(
                        //                   children: [
                        //                     Container(
                        //                       height: 50,
                        //                       width:
                        //                           Dimensions.screenWidth(context),
                        //                       child: TabBar(
                        //                         indicatorColor:
                        //                             AppColors.mainColor,
                        //                         labelColor: AppColors.mainColor,
                        //                         unselectedLabelColor:
                        //                             AppColors.grey,
                        //                         tabs: categoryViewModel
                        //                             .productCategoryList.value
                        //                             .map((e) => Tab(
                        //                                   child: TextView(
                        //                                       text:
                        //                                           e.categoryName),
                        //                                 ))
                        //                             .toList(),
                        //                       ),
                        //                     ),
                        //                     Container(
                        //                       height: 200,
                        //                       width:
                        //                           Dimensions.screenWidth(context),
                        //                       color: Colors.amber,
                        //                       child: TabBarView(
                        //                         children: [
                        //                           Center(
                        //                             child: TextView(text: "1"),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //         ));
                        //       } else {
                        //         return SizedBox();
                        //       }
                        //     }),
                        Container(
                            height: Dimensions.screenHeight(context) - 200,
                            child: FutureBuilder(
                                future: productViewModel.getBussinessProducts(
                                    businessId:
                                        widget.businessModel.businessId!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Obx(() =>
                                        productViewModel.productList.length != 0
                                            ? GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 00,
                                                  mainAxisSpacing: 0,
                                                  childAspectRatio: 0.8,
                                                ),
                                                itemCount: productViewModel
                                                    .productList.value.length,
                                                itemBuilder: (context, index) {
                                                  var data = productViewModel
                                                      .productList.value[index];
                                                  return ProductListItem(
                                                    productModel: ProductModel(
                                                      property: data.property,
                                                      unit: data.unit,
                                                      id: data.id,
                                                      businessManID:
                                                          data.businessManID,
                                                      businessID:
                                                          data.businessID,
                                                      proName: data.proName,
                                                      detail: data.detail,
                                                      proCat: data.proCat,
                                                      proDis: data.proDis,
                                                      costPrice: data.costPrice,
                                                      salePrice: data.salePrice,
                                                      discountPrice:
                                                          data.discountPrice,
                                                      totalQty: data.totalQty,
                                                      saleQty: data.saleQty,
                                                      proImg: data.proImg,
                                                      proStatus: data.proStatus,
                                                    ),
                                                  );
                                                },
                                              )
                                            : SizedBox());
                                  }
                                })),
                        AddVerticalSpace(10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.isMY
          ? FloatingActionButton(
              backgroundColor: AppColors.white,
              child: Icon(
                Icons.add_business,
                color: AppColors.mainColor,
              ),
              onPressed: () {
                Get.to(
                  AddProductView(businessModel: widget.businessModel),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 600),
                );
              },
            )
          : SizedBox(),
    );
  }
}
