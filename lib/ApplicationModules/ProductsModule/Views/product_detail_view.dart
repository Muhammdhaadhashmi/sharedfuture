import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/ViewModels/business_view_model.dart';
import 'package:shared_future/ApplicationModules/CartModule/Models/cart_model.dart';
import 'package:shared_future/ApplicationModules/CartModule/ViewModels/cart_view_model.dart';
import 'package:shared_future/ApplicationModules/CartModule/Views/cart_view.dart';
import 'package:shared_future/ApplicationModules/ProductsModule/Views/edit_product_view.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/Views/edit_profile_view.dart';
import 'package:shared_future/LocalDatabaseHelper/local_database_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_future/Utils/toast.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/btn.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_view.dart';
import '../../../Utils/token.dart';
import '../../AuthenticationModule/Views/sign_in_view.dart';
import '../../BusinessModule/Models/business_model.dart';
import '../../HomeModule/ViewModels/home_view_model.dart';
import '../../HomeModule/Views/Components/image_list_item.dart';
import '../../ProfileModule/ViewModels/profile_view_model.dart';
import '../Models/product_model.dart';
import '../ViewModels/product_view_model.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductModel productModel;

  const ProductDetailsView({
    super.key,
    required this.productModel,
  });

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  bool loading = true;
  bool favirate = false;
  BusinessViewModel businessViewModel = Get.put(BusinessViewModel());
  CartViewModel cartViewModel = Get.put(CartViewModel());

  LocalDatabaseHepler db = LocalDatabaseHepler();

  List proid = [];

  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.productModel.businessManID);
    cartViewModel.getCartFromLocal();
    for (final val in cartViewModel.carList.value) {
      proid.add(val.productId);
    }
    cartViewModel.getCartCount();
    if (profileViewModel.localCurrentUserList.value.length != 0) {
      profileViewModel.getProFavirateFromApis();
      for (final value in profileViewModel.profavirateList.value) {
        if (value.userId ==
                profileViewModel.localCurrentUserList.value[0].customerId &&
            value.proId == widget.productModel.id) {
          setState(() {
            favirate = true;
          });
        }
      }
    }
  }

  getBusinessDetails() {
    setState(() {
      loading = true;
    });
    businessViewModel.getBusiness();
    print(businessViewModel.businessList.value.toList());
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddVerticalSpace(50),
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
                                  text: "${widget.productModel.proName}",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: AppColors.white,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        businessViewModel.businessId.value ==
                                widget.productModel.businessID
                            ? InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {
                                  Get.to(
                                    EditProductView(
                                        BusinessID:
                                            widget.productModel.businessID,
                                        productModel: widget.productModel),
                                    transition: Transition.rightToLeft,
                                    duration: Duration(milliseconds: 600),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.edit_note,
                                    color: AppColors.white,
                                  ),
                                ),
                              )
                            : InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {
                                  Get.to(
                                    CartView(),
                                    transition: Transition.rightToLeft,
                                    duration: Duration(milliseconds: 600),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: AppColors.white,
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
                                                child: TextView(
                                                  text:
                                                      "${cartViewModel.cartCount.value}",
                                                  fontSize: 10,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  AddVerticalSpace(30),
                  Container(
                    height: Dimensions.screenWidth(context) - 150,
                    width: Dimensions.screenWidth(context),
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                    ),
                    child: ImageSlideshow(
                      children: ["${widget.productModel.proImg}"]
                          .map(
                            (e) => ImageListItem(image: e, radius: 0),
                          )
                          .toList(),
                      initialPage: 0,
                      indicatorColor: AppColors.mainColor,
                      indicatorBackgroundColor: AppColors.white,
                      autoPlayInterval: 6000,
                      isLoop: true,
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
                            text: "${widget.productModel.proName}",
                            fontSize: 20,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              favirate = !favirate;
                            });
                            profileViewModel.getProFavirateFromApis();
                            for (final value
                                in profileViewModel.profavirateList.value) {
                              if (value.userId ==
                                      profileViewModel.localCurrentUserList
                                          .value[0].customerId &&
                                  value.proId == widget.productModel.id) {
                                setState(() {
                                  favirate = true;
                                });
                              }
                            }
                            if (favirate) {
                              await http.post(
                                Uri.parse("${Token.apiHeader}addFvrt"),
                                body: {
                                  "user_id":
                                      "${profileViewModel.localCurrentUserList.value[0].customerId}",
                                  "pro_id": "${widget.productModel.id}",
                                },
                              ).then((value) {
                                print(value.body);
                              });
                            } else {
                              await http
                                  .delete(
                                Uri.parse("${Token.apiHeader}deleteFvrt/25}"),
                                // Uri.parse("${Token.apiHeader}deleteFvrt/${profileViewModel.localCurrentUserList.value[0].customerId}"),
                              )
                                  .then((value) {
                                print(value.body);
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              favirate ? Icons.favorite : Icons.favorite_border,
                              color: favirate ? AppColors.red : AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // AddVerticalSpace(10),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  //   child: Row(
                  //     children: List.generate(
                  //       5,
                  //       (index) => Icon(
                  //         Icons.star,
                  //         color: AppColors.yellow,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  AddVerticalSpace(10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView(
                              text: widget.productModel.discountPrice == 0
                                  ? "${Token.curency}${widget.productModel.salePrice}"
                                  : "${Token.curency}${(widget.productModel.salePrice) - (widget.productModel.discountPrice)}",
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.white,
                            ),
                            AddVerticalSpace(5),
                            TextView(
                              decoration: TextDecoration.lineThrough,
                              text: widget.productModel.discountPrice != 0
                                  ? "${Token.curency}${widget.productModel.salePrice}"
                                  : "",
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextView(
                              text: "${widget.productModel.property}",
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.white,
                            ),
                            AddVerticalSpace(5),
                            TextView(
                              text: "Unit ${widget.productModel.unit}",
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TextView(
                        //   text: "Category",
                        //   fontSize: 18,
                        //   fontWeight: FontWeight.w600,
                        // ),
                        // AddVerticalSpace(10),
                        // TextView(
                        //   text: "${widget.productModel.proCat}",
                        //   fontSize: 16,
                        //   fontWeight: FontWeight.normal,
                        //   color: AppColors.grey,
                        //   textAlign: TextAlign.start,
                        // ),
                        AddVerticalSpace(10),

                        Divider(
                          thickness: 2,
                          color: AppColors.white,
                        ),
                        AddVerticalSpace(10),
                        TextView(
                          text: "Description",
                          fontSize: 18,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        AddVerticalSpace(10),

                        TextView(
                          text: "${widget.productModel.proDis}",
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColors.white,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  AddVerticalSpace(20),

                  businessViewModel.businessId.value ==
                          widget.productModel.businessID
                      ? Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          width: Dimensions.screenWidth(context),
                          // height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text: "Pieces",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                  TextView(
                                    text: "${widget.productModel.property}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              AddVerticalSpace(16),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text: "Unit",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                  TextView(
                                    text: "${widget.productModel.unit}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              AddVerticalSpace(16),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text: "Total Items",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                  TextView(
                                    text: "${widget.productModel.totalQty}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              AddVerticalSpace(16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text: "Sold Items",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                  TextView(
                                    text: "${widget.productModel.saleQty}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              AddVerticalSpace(16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text: "Cost Price",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                  TextView(
                                    text:
                                        "${Token.curency}${widget.productModel.costPrice}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              AddVerticalSpace(16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text: "Sale Price",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                  TextView(
                                    text:
                                        "${Token.curency}${widget.productModel.salePrice}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              AddVerticalSpace(16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text: "Discount Price",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                  TextView(
                                    text:
                                        "${Token.curency}${widget.productModel.discountPrice}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              // AddVerticalSpace(16),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: cartViewModel.cartCount.value < 10
              ? businessViewModel.businessId.value !=
                      widget.productModel.businessID
                  ? Container(
                      color: AppColors.gradientDark,
                      padding: EdgeInsets.all(15),
                      child: BTN(
                        color: AppColors.mainColor,
                        textColor: AppColors.white,
                        title: proid.contains(widget.productModel.id!)
                            ? "Product Already Exist"
                            : "Add to cart",
                        onPressed: () {
                          List<BusinessModel> shipping = businessViewModel
                              .businessList
                              .where((ele) =>
                                  ele.businessId ==
                                  widget.productModel.businessID)
                              .toList();
                          if (proid.contains(widget.productModel.id!)) {
                            FlutterErrorToast(error: "Product already in cart");
                          } else {
                            proid.add(widget.productModel.id!);
                            db.addCart(
                              cartModel: CartModel(
                                property: widget.productModel.property,
                                unit: widget.productModel.unit,
                                des: widget.productModel.proDis,
                                shippingCharges: shipping[0].shippingCharges,
                                productId: widget.productModel.id!,
                                Price: widget.productModel.salePrice -
                                    widget.productModel.discountPrice,
                                businessId: widget.productModel.businessID,
                                productName: widget.productModel.proName,
                                discountPrice:
                                    widget.productModel.discountPrice,
                                salePrice: widget.productModel.salePrice,
                                saleQuantity: widget.productModel.totalQty,
                                quantity: 1,
                                image: widget.productModel.proImg,
                                businessName: businessViewModel
                                    .businessList.value
                                    .where((element) =>
                                        element.businessId ==
                                        widget.productModel.businessID)
                                    .toList()[0]
                                    .businessName,
                                businessContact: businessViewModel
                                    .businessList.value
                                    .where((element) =>
                                        element.businessId ==
                                        widget.productModel.businessID)
                                    .toList()[0]
                                    .businessNumber,
                                businessAddress: businessViewModel
                                    .businessList.value
                                    .where((element) =>
                                        element.businessId ==
                                        widget.productModel.businessID)
                                    .toList()[0]
                                    .businessAddress,
                                businessManId:
                                    widget.productModel.businessManID,
                              ),
                            );

                            cartViewModel.getCartCount();
                          }
                        },
                        width: Dimensions.screenWidth(context),
                      ),
                    )
                  : SizedBox()
              : SizedBox(),
        ));
  }
}
