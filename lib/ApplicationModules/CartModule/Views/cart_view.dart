import 'dart:convert';
import 'dart:ui';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/CartModule/Models/cart_model.dart';
import 'package:shared_future/ApplicationModules/CartModule/ViewModels/cart_view_model.dart';
import 'package:shared_future/ApplicationModules/CartModule/Views/Components/cart_list_item.dart';
import 'package:shared_future/Utils/btn.dart';
import 'package:shared_future/Utils/text_edit_field.dart';
import 'package:shared_future/Utils/text_view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_future/Utils/token.dart';
import '../../../LocalDatabaseHelper/local_database_handler.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../HomeModule/ViewModels/home_view_model.dart';
import '../../ProfileModule/Models/user_model.dart';
import '../../ProfileModule/ViewModels/profile_view_model.dart';
import 'order_success_view.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  CartViewModel cartViewModel = Get.put(CartViewModel());
  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());
  LocalDatabaseHepler db = LocalDatabaseHepler();
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController address = TextEditingController();

  bool emailValid = false;
  bool nameValid = false;
  bool numberValid = false;
  bool addressValid = false;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: ImageFiltered(
            imageFilter: ImageFilter.blur(
                sigmaX: loading ? 5 : 0, sigmaY: loading ? 5 : 0),
            child: Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddVerticalSpace(50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextView(
                        text: "Your Cart",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white),
                  ),
                  AddVerticalSpace(16),
                  Divider(thickness: 2, color: AppColors.white),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          FutureBuilder(
                              future: cartViewModel.getCartFromLocal(),
                              builder: (context, snapshot) {
                                return Obx(() => ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          cartViewModel.carList.value.length,
                                      itemBuilder: (context, index) {
                                        var data =
                                            cartViewModel.carList.value[index];
                                        // cartViewModel.total.value = data.Price;
                                        return CartListItem(
                                          index: index,
                                          cartModel: CartModel(
                                            property: data.property,
                                            unit: data.unit,
                                            des: data.des,
                                            businessManId: data.businessManId,
                                            shippingCharges:
                                                data.shippingCharges,
                                            id: data.id,
                                            productId: data.productId,
                                            businessId: data.businessId,
                                            productName: data.productName,
                                            discountPrice: data.discountPrice,
                                            salePrice: data.salePrice,
                                            saleQuantity: data.saleQuantity,
                                            quantity: data.quantity,
                                            image: data.image,
                                            Price: data.Price,
                                            businessName: data.businessName,
                                            businessContact:
                                                data.businessContact,
                                            businessAddress:
                                                data.businessAddress,
                                          ),
                                        );
                                      },
                                    ));
                              }),
                          Obx(() => cartViewModel.cartCount.value != 0
                              ? Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.all(16),
                                      height: 170,
                                      width: Dimensions.screenWidth(context),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextView(
                                                text:
                                                    "Items (${cartViewModel.cartCount.value})",
                                                color: AppColors.black,
                                              ),
                                              TextView(
                                                text:
                                                    "${Token.curency}${cartViewModel.total.value}",
                                                color: AppColors.black,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextView(
                                                text: "Shipping",
                                                color: AppColors.black,
                                              ),
                                              TextView(
                                                text:
                                                    "${Token.curency}${cartViewModel.shipping.value}",
                                                color: AppColors.black,
                                              ),
                                            ],
                                          ),
                                          DottedLine(
                                              dashColor: AppColors.black),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextView(
                                                text: "Total Price",
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              TextView(
                                                text:
                                                    "${Token.curency}${cartViewModel.total.value + cartViewModel.shipping.value}",
                                                color: AppColors.mainColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: BTN(
                                        color: AppColors.mainColor,
                                        textColor: AppColors.white,
                                        title: "Check Out",
                                        onPressed: () async {
                                          if (homeViewModel.acountExit.value ==
                                              0) {
                                            Get.defaultDialog(
                                              title: "Check Out",
                                              titleStyle: TextStyle(
                                                color: AppColors.white,
                                              ),
                                              backgroundColor:
                                                  AppColors.gradientLight,
                                              titlePadding:
                                                  EdgeInsets.only(top: 20),
                                              contentPadding:
                                                  EdgeInsets.all(20),
                                              content: Stack(
                                                children: [
                                                  ImageFiltered(
                                                    imageFilter:
                                                        ImageFilter.blur(
                                                            sigmaX:
                                                                loading ? 5 : 0,
                                                            sigmaY: loading
                                                                ? 5
                                                                : 0),
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          TextEditField(
                                                            hintText: "Name",
                                                            textEditingController:
                                                                name,
                                                            width: Dimensions
                                                                .screenWidth(
                                                              context,
                                                            ),
                                                            errorText: nameValid
                                                                ? "Enter Email"
                                                                : null,
                                                            preffixIcon: Icon(
                                                                Icons.person),
                                                          ),
                                                          AddVerticalSpace(10),
                                                          TextEditField(
                                                            hintText: "Email",
                                                            textEditingController:
                                                            email,
                                                            width: Dimensions
                                                                .screenWidth(
                                                              context,
                                                            ),
                                                            inputType: TextInputType.emailAddress,
                                                            errorText: emailValid
                                                                ? "Enter Email"
                                                                : null,
                                                            preffixIcon: Icon(
                                                                Icons.phone),
                                                          ),
                                                          AddVerticalSpace(10),
                                                          TextEditField(
                                                            hintText: "Number",
                                                            textEditingController:
                                                                number,
                                                            width: Dimensions
                                                                .screenWidth(
                                                              context,
                                                            ),
                                                            inputType: TextInputType.number,
                                                            errorText: numberValid
                                                                ? "Enter Email"
                                                                : null,
                                                            preffixIcon: Icon(
                                                                Icons.phone),
                                                          ),
                                                          AddVerticalSpace(10),
                                                          TextEditField(
                                                            hintText: "Address",
                                                            textEditingController:
                                                                address,
                                                            width: Dimensions
                                                                .screenWidth(
                                                              context,
                                                            ),
                                                            errorText: addressValid
                                                                ? "Enter Email"
                                                                : null,
                                                            preffixIcon: Icon(
                                                                Icons
                                                                    .location_on),
                                                          ),
                                                          AddVerticalSpace(20),
                                                          BTN(
                                                            title: "Done",
                                                            color: AppColors
                                                                .mainColor,
                                                            textColor:
                                                                AppColors.white,
                                                            width: Dimensions
                                                                .screenWidth(
                                                                    context),
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                if (name.text
                                                                    .isEmpty) {
                                                                  nameValid =
                                                                      true;
                                                                } else if (number
                                                                    .text
                                                                    .isEmpty) {
                                                                  numberValid =
                                                                      true;
                                                                } else if (address
                                                                    .text
                                                                    .isEmpty) {
                                                                  addressValid =
                                                                      true;
                                                                }
                                                              });

                                                              if (name.text
                                                                      .isNotEmpty &&
                                                                  number.text
                                                                      .isNotEmpty &&
                                                                  address.text
                                                                      .isNotEmpty) {
                                                                Get.back();
                                                                setState(() {
                                                                  loading =
                                                                      true;
                                                                });
                                                                int time = DateTime
                                                                        .now()
                                                                    .microsecondsSinceEpoch;
                                                                print(
                                                                    "value.body");

                                                                await http.post(
                                                                  Uri.parse(
                                                                      "${Token.apiHeader}addGuest"),
                                                                  body: {
                                                                    "id":
                                                                        "${time}",
                                                                    "customer_name": name.text,
                                                                    "customer_email": email.text,
                                                                    "customer_phone":
                                                                        number
                                                                            .text,
                                                                    "customer_address":
                                                                        address
                                                                            .text,
                                                                    "customer_type":
                                                                        "Guest",
                                                                  },
                                                                ).then((value) {
                                                                  print(
                                                                      "value.body");
                                                                  print(value
                                                                      .body);
                                                                  if (value
                                                                          .statusCode ==
                                                                      200) {
                                                                    checkOut(
                                                                        customer_id:
                                                                            "${time}");
                                                                  }
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  loading
                                                      ? Container(
                                                          height: Dimensions
                                                              .screenHeight(
                                                                  context),
                                                          width: Dimensions
                                                              .screenWidth(
                                                                  context),
                                                          color: AppColors
                                                              .transparent,
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              loading = true;
                                            });
                                            print("loading");
                                            print(loading);
                                            checkOut(
                                                customer_id:
                                                    "${profileViewModel.localCurrentUserList.value[0].customerId}");
                                          }
                                        },
                                        width: Dimensions.screenWidth(context),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  height:
                                      Dimensions.screenHeight(context) - 200,
                                  child: Center(
                                    child: TextView(
                                      text: "No Cart",
                                      color: AppColors.white,
                                    ),
                                  ),
                                )),
                          AddVerticalSpace(20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        loading
            ? Container(
                height: Dimensions.screenHeight(context),
                width: Dimensions.screenWidth(context),
                color: AppColors.transparent,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  checkOut({required String customer_id}) async {
    List pro_id = [];
    List quantityList = [];
    List price = [];
    int busineddId = 0;
    for (int i = 0; i < cartViewModel.carList.value.length; i++) {
      busineddId = cartViewModel.carList.value[i].businessId;
      pro_id.add("${cartViewModel.carList.value[i].productId}");
      quantityList.add("${cartViewModel.carList.value[i].quantity}");
      price.add(
          "${cartViewModel.carList.value[i].salePrice - cartViewModel.carList.value[i].discountPrice}");
    }
    print(price);
    await http.post(
      Uri.parse("${Token.apiHeader}insertOrder"),
      body: {
        "order_no": "SFO" + DateTime.now().millisecondsSinceEpoch.toString(),
        "product_id": "${pro_id}",
        "quantity": "${quantityList}",
        "price": "${price}",
        "business_id": "${busineddId}",
        "customer_id": customer_id,
        // "date_time": "",
        "date_time": "${DateTime.now()}",
        "order_status": "pending",
        "business_mid": cartViewModel.carList.value[0].businessManId.toString(),
        "business_name": cartViewModel.carList.value[0].businessName,
        "business_contact": cartViewModel.carList.value[0].businessContact,
        "business_address": cartViewModel.carList.value[0].businessAddress,
        "total_item_price": "${cartViewModel.total.value}",
        "shipping_order": "${cartViewModel.carList.value[0].shippingCharges}",
        "total_items": "${cartViewModel.carList.value.length}",
        "shipping_date": "${DateTime.now().add(Duration(days: 2))}",
        "total_amount":
            "${cartViewModel.total.value + cartViewModel.carList.value[0].shippingCharges}",
      },
    ).then((value) {
      print(value.statusCode);
      print(value.body);
      // print(jsonDecode(value.body));
      if (value.statusCode == 200) {
        db.deleteTable(tableName: "tbl_cart");
        cartViewModel.getCartCount();
        cartViewModel.getCartFromLocal();
        Get.offAll(
          OrderSuccessView(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 600),
        );
      }
    });
  }
}
