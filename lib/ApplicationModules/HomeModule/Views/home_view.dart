import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_future/ApplicationModules/AuthenticationModule/Views/sign_in_view.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Models/business_model.dart';
import 'package:shared_future/ApplicationModules/CartModule/ViewModels/cart_view_model.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Views/category_list_view.dart';
import 'package:shared_future/ApplicationModules/HomeModule/ViewModels/home_view_model.dart';
import 'package:shared_future/Utils/location_service.dart';
import 'package:shared_future/Utils/text_view.dart';

import '../../../LocalDatabaseHelper/local_database_handler.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/search_text_field.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/token.dart';
import '../../BusinessModule/ViewModels/business_view_model.dart';
import '../../BusinessModule/Views/Components/business_list_item.dart';
import '../../CategoryModule/ViewModels/category_view_model.dart';
import '../../CategoryModule/Views/Components/home_category_list_item.dart';
import 'Components/image_list_item.dart';

class HomeView extends StatefulWidget {
   HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController search = TextEditingController();
  LocalDatabaseHepler db = LocalDatabaseHepler();


  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  BusinessViewModel businessViewModel = Get.put(BusinessViewModel());
  CategoryViewModel categoryViewModel = Get.put(CategoryViewModel());
  CartViewModel cartViewModel = Get.put(CartViewModel());

  Future? getBussinessCategories;
  Future? getNearByBusiness;
  Future? getBusiness;
  Future? getBanners;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    getBusiness = businessViewModel.getBusiness();
    getNearByBusiness = businessViewModel.getNearByBusiness();
    getBussinessCategories = categoryViewModel.getBussinessCategories();
    getBanners = homeViewModel.getBanners();
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Token.ImageDir");
    print(Token.ImageDir);
    getBusiness = businessViewModel.getBusiness();
    getNearByBusiness = businessViewModel.getNearByBusiness();
    getBussinessCategories = categoryViewModel.getBussinessCategories();
    getBanners = homeViewModel.getBanners();
    cartViewModel.getCartCount();
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
            children: [
              AddVerticalSpace(50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SearchTextField(
                      readOnly: true,
                      onTap: () {
                        homeViewModel.index.value = 1;
                      },
                      width: homeViewModel.acountExit == 1
                          ? Dimensions.screenWidth(context) - 90
                          : Dimensions.screenWidth(context) - 115,
                      // width: Dimensions.screenWidth(context) - 115,
                      hintText: "Search",
                      textEditingController: search,
                      prefixIcon: Icon(Icons.search),
                      onChanged: (value) {},
                    ),
                    // AddHorizontalSpace(5),
                    homeViewModel.acountExit == 1
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  homeViewModel.index.value = 3;
                                },
                                child: Icon(
                                  Icons.favorite,
                                  color: AppColors.white,
                                ),
                              ),
                              AddHorizontalSpace(10),
                              // GestureDetector(
                              //   onTap: () {},
                              //   child: Icon(
                              //     Icons.notifications_active_outlined,
                              //     color: AppColors.grey,
                              //   ),
                              // ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              Get.to(
                                SignInView(),
                                transition: Transition.rightToLeft,
                                duration: Duration(milliseconds: 600),
                              );
                            },
                            child: Container(
                              // height: 40,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(children: [
                                Icon(
                                  Icons.power_settings_new,
                                  color: AppColors.white,
                                ),
                                AddHorizontalSpace(2),
                                TextView(
                                  text: "Sign In",
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ]),
                            ),
                          ),
                    // AddHorizontalSpace(10),
                  ],
                ),
              ),
              AddVerticalSpace(10),
              Divider(thickness: 2, color: AppColors.white),
              Container(
                height: Dimensions.screenHeight(context) - 168,
                // height: Dimensions.screenHeight(context) - 200,
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
                        AddVerticalSpace(16),
                        FutureBuilder(
                            future: getBanners,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Obx(() => Container(
                                      height:
                                          Dimensions.screenWidth(context) - 180,
                                      width: Dimensions.screenWidth(context),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: homeViewModel
                                                  .bannerList.value.length !=
                                              0
                                          ? ImageSlideshow(
                                              children:
                                                  homeViewModel.bannerList.value
                                                      .map(
                                                        (e) => ImageListItem(
                                                            image: e.bannerImg,
                                                            radius: 5),
                                                      )
                                                      .toList(),
                                              // initialPage: 0,
                                              indicatorColor:
                                                  AppColors.mainColor,
                                              indicatorBackgroundColor:
                                                  AppColors.grey,
                                              autoPlayInterval: 6000,
                                              isLoop: true,
                                            )
                                          : Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.mainColor,
                                              ),
                                            ),
                                    ));
                              }
                            }),
                        AddVerticalSpace(10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextView(
                                text: "Category",
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(
                                    CategoryListView(),
                                    transition: Transition.rightToLeft,
                                    duration: Duration(milliseconds: 600),
                                  );
                                },
                                child: TextView(
                                  text: "See all",
                                  color: AppColors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        AddVerticalSpace(10),
                        Container(
                          height: 110,
                          width: Dimensions.screenWidth(context),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: FutureBuilder(
                              future: getBussinessCategories,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  print("object");
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                    ),
                                  );
                                } else {
                                  return Obx(() => ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: categoryViewModel
                                            .bussinessCategoryList.value.length,
                                        itemBuilder: (context, index) {
                                          var data = categoryViewModel
                                              .bussinessCategoryList
                                              .value[index];
                                          return HomeCategoryListItem(
                                            categoryModel: CategoryModel(
                                              category_type: data.category_type,
                                              categoryId: data.categoryId,
                                              categoryName: data.categoryName,
                                              categoryImage: data.categoryImage,
                                              categoryStatus:
                                                  data.categoryStatus,
                                            ),
                                          );
                                        },
                                      ));
                                }
                              }),
                        ),
                        AddVerticalSpace(20),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       TextView(
                        //         text: "Vendors",
                        //         color: AppColors.black,
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w700,
                        //       ),
                        //       InkWell(
                        //         onTap: () {
                        //           // Navigator.push(
                        //           //   context,
                        //           //   PageTransition(
                        //           //     type: PageTransitionType.rightToLeft,
                        //           //     duration: Duration(milliseconds: 400),
                        //           //     alignment: Alignment.bottomCenter,
                        //           //     child: CategoryListView(images: images),
                        //           //   ),
                        //           // );
                        //         },
                        //         child: TextView(
                        //           text: "See More",
                        //           color: AppColors.mainColor,
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // AddVerticalSpace(10),
                        // Container(
                        //   height: 240,
                        //   width: Dimensions.screenWidth(context),
                        //   padding: EdgeInsets.only(left: 6, right: 16),
                        //   child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: images.length,
                        //     itemBuilder: (context, index) {
                        //       return VendorListItem(
                        //         image: images[index],
                        //       );
                        //     },
                        //   ),
                        // ),
                        // AddVerticalSpace(20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextView(
                                text: "Near By",
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: AppColors.white,
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     // Navigator.push(
                              //     //   context,
                              //     //   PageTransition(
                              //     //     type: PageTransitionType.rightToLeft,
                              //     //     duration: Duration(milliseconds: 400),
                              //     //     alignment: Alignment.bottomCenter,
                              //     //     child: CategoryListView(images: images),
                              //     //   ),
                              //     // );
                              //   },
                              //   child: TextView(
                              //     text: "See More",
                              //     color: AppColors.mainColor,
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        AddVerticalSpace(10),
                        Container(
                          height: 240,
                          padding: EdgeInsets.only(left: 6, right: 16),
                          child: FutureBuilder(
                              future: getNearByBusiness,
                              builder: (context, snapshot) {
                                return Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: businessViewModel
                                          .nearByBusinessList.value.length,
                                      itemBuilder: (context, index) {
                                        var data = businessViewModel
                                            .nearByBusinessList.value[index];
                                        return BusinessListItem(
                                          businessModel: BusinessModel(
                                            businessId: data.businessId,
                                            shippingCharges:
                                                data.shippingCharges,
                                            user_id: data.user_id,
                                            businessName: data.businessName,
                                            businessNumber: data.businessNumber,
                                            businessCategory:
                                                data.businessCategory,
                                            businessAddress:
                                                data.businessAddress,
                                            businessDescription:
                                                data.businessDescription,
                                            businessImage: data.businessImage,
                                            businessLocationLat:
                                                data.businessLocationLat,
                                            businessLocationLng:
                                                data.businessLocationLng,
                                            businessStatus: data.businessStatus,
                                          ),
                                        );
                                      },
                                    ));
                              }),
                        ),
                        AddVerticalSpace(20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextView(
                                text: "All Vendors",
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     // Navigator.push(
                              //     //   context,
                              //     //   PageTransition(
                              //     //     type: PageTransitionType.rightToLeft,
                              //     //     duration: Duration(milliseconds: 400),
                              //     //     alignment: Alignment.bottomCenter,
                              //     //     child: CategoryListView(images: images),
                              //     //   ),
                              //     // );
                              //   },
                              //   child: TextView(
                              //     text: "See More",
                              //     color: AppColors.mainColor,
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        // AddVerticalSpace(10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: FutureBuilder(
                              future: getBusiness,
                              builder: (context, snapshot) {
                                return Obx(() => GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 00,
                                        mainAxisSpacing: 0,
                                        childAspectRatio: 0.8,
                                        // mainAxisExtent: 150,
                                      ),
                                      itemCount: businessViewModel
                                          .businessList.value.length,
                                      itemBuilder: (context, index) {
                                        var data = businessViewModel
                                            .businessList.value[index];
                                        return BusinessListItem(
                                          businessModel: BusinessModel(
                                            businessId: data.businessId,
                                            shippingCharges:
                                                data.shippingCharges,
                                            user_id: data.user_id,
                                            businessName: data.businessName,
                                            businessNumber: data.businessNumber,
                                            businessCategory:
                                                data.businessCategory,
                                            businessAddress:
                                                data.businessAddress,
                                            businessDescription:
                                                data.businessDescription,
                                            businessImage: data.businessImage,
                                            businessLocationLat:
                                                data.businessLocationLat,
                                            businessLocationLng:
                                                data.businessLocationLng,
                                            businessStatus: data.businessStatus,
                                          ),
                                        );
                                      },
                                    ));
                              }),
                        ),
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
    );
  }
}
