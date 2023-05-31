import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_future/ApplicationModules/OrderModule/Views/Components/order_list_item.dart';
import 'package:shared_future/ApplicationModules/ProductsModule/Models/product_model.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/ViewModels/profile_view_model.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/Views/edit_profile_view.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/dimensions.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/text_view.dart';
import '../../../Utils/token.dart';
import '../../ProductsModule/Views/Components/product_list_item.dart';
import '../ViewModels/order_view_model.dart';
import 'Components/order_product_list_item.dart';
import 'Components/step_indicator.dart';

class OrderDetailView extends StatefulWidget {
  final int index;

  const OrderDetailView({super.key, required this.index});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  OrderViewModel orderViewModel = Get.put(OrderViewModel());
  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());
  Future? getDetails;
  bool delevired = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileViewModel.getCurrentUser();
    // Future.delayed(Duration(seconds: 2),(){

    orderViewModel.getCustomerOnId(
        id: orderViewModel.orderList.value[widget.index].customerId);
    getDetails = orderViewModel.getDetailOrders(
        id: orderViewModel.orderList.value[widget.index].orderId);
    if (orderViewModel.orderList.value[widget.index].orderStatus == "success") {
      setState(() {
        delevired = true;
      });
    }
    print("delevired");
    print(delevired);
    // });
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    orderViewModel.getOrders();
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
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddVerticalSpace(45),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.chevron_left,
                                color: AppColors.white,
                              ),
                              AddHorizontalSpace(5),
                              TextView(
                                text: "Orders Details",
                                fontSize: 20,
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                        !delevired
                            ? profileViewModel.localCurrentUserList.value[0]
                                        .customerId !=
                                    orderViewModel.orderList.value[widget.index]
                                        .customerId
                                ? GestureDetector(
                                    onTap: () async {
                                      await http
                                          .get(Uri.parse(
                                              "${Token.apiHeader}updateStatus/${orderViewModel.orderList.value[widget.index].orderId}"))
                                          .then((value) {
                                        print(value.statusCode);
                                        if (value.statusCode == 200) {
                                          setState(() {
                                            delevired = true;
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                      // height: 40,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 8),
                                      decoration: BoxDecoration(
                                          color: AppColors.mainColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(children: [
                                        Icon(
                                          Icons.done,
                                          color: AppColors.white,
                                        ),
                                        AddHorizontalSpace(2),
                                        TextView(
                                          text: "Mark as Delivered",
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ]),
                                    ),
                                  )
                                : SizedBox()
                            : SizedBox(),
                      ],
                    ),
                  ),
                  AddVerticalSpace(20),
                  Divider(
                    height: 1,
                    color: AppColors.white,
                    thickness: 2,
                  ),
                  Container(
                    width: Dimensions.screenWidth(context),
                    height: Dimensions.screenHeight(context) - 100,
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
                            AddVerticalSpace(30),
                            Container(
                              height: 70,
                              width: Dimensions.screenWidth(context),
                              child: Column(
                                children: [StepIndicator(done: delevired)],
                              ),
                            ),
                            AddVerticalSpace(20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextView(
                                text: "Products Details",
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            AddVerticalSpace(10),
                            orderViewModel.orderPorList.value.length != 0
                                ? Container(
                                    // height: 240,
                                    child: FutureBuilder(
                                        future: getDetails,
                                        builder: (context, snapshot) {
                                          return Obx(() => ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: orderViewModel
                                                    .orderPorList.value.length,
                                                itemBuilder: (context, index) {
                                                  var data = orderViewModel
                                                      .orderPorList
                                                      .value[index];
                                                  return OrderProductListItem(
                                                    quantity: orderViewModel
                                                        .orderdetailList
                                                        .value[index]
                                                        .quantity,
                                                    productModel: ProductModel(
                                                      proName: data.proName,
                                                      property: data.property,
                                                      unit: data.unit,
                                                      businessManID:
                                                          data.businessManID,
                                                      businessID:
                                                          data.businessID,
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
                                              ));
                                        }),
                                  )
                                : SizedBox(),
                            AddVerticalSpace(20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextView(
                                text: "Business Details",
                                fontSize: 16,
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            AddVerticalSpace(16),
                            Container(
                              // height: 300,
                              margin: EdgeInsets.only(right: 16, left: 16),
                              width: Dimensions.screenWidth(context),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextView(
                                        text: "Business Name",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      TextView(
                                        text:
                                            "${orderViewModel.orderList.value[widget.index].businessName}",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextView(
                                        text: "Business Contact",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      TextView(
                                        text:
                                            "${orderViewModel.orderList.value[widget.index].businessContact}",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextView(
                                        text: "business Address",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      Container(
                                        width: 100,
                                        child: TextView(
                                          text:
                                              "${orderViewModel.orderList.value[widget.index].businessAddress}",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            AddVerticalSpace(16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextView(
                                text: "Shipping Details",
                                fontSize: 16,
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            AddVerticalSpace(16),
                            Container(
                              // height: 300,
                              margin: EdgeInsets.only(right: 16, left: 16),
                              width: Dimensions.screenWidth(context),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextView(
                                        text: "Shipping",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      TextView(
                                        text:
                                            "${orderViewModel.orderList.value[widget.index].shippingDate}"
                                                .substring(0, 10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextView(
                                        text: "No of Items",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      TextView(
                                        text:
                                            "${orderViewModel.orderList.value[widget.index].totalItems} Items purchased",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextView(
                                        text: "Order No",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      TextView(
                                        text:
                                            "${orderViewModel.orderList.value[widget.index].orderNo}",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextView(
                                        text: "Name",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      Container(
                                        width: 100,
                                        child: TextView(
                                          text: orderViewModel
                                                      .userList.value.length !=
                                                  0
                                              ? "${orderViewModel.userList.value[0].customerName}"
                                              : "",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black,
                                          textAlign: TextAlign.right,
                                          textOverflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                  AddVerticalSpace(16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextView(
                                        text: "Contact",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      Container(
                                        width: 100,
                                        child: TextView(
                                          text: orderViewModel
                                                      .userList.value.length !=
                                                  0
                                              ? "${orderViewModel.userList.value[0].customerPhone}"
                                              : "",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black,
                                          textAlign: TextAlign.right,
                                          textOverflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                  AddVerticalSpace(16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextView(
                                        text: "Address",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      Container(
                                        width: 100,
                                        child: TextView(
                                          text: orderViewModel
                                                      .userList.value.length !=
                                                  0
                                              ? "${orderViewModel.userList.value[0].customerAddress}"
                                              : "",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black,
                                          textAlign: TextAlign.right,
                                          textOverflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            AddVerticalSpace(16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextView(
                                text: "Payment Details",
                                fontSize: 16,
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            AddVerticalSpace(16),
                            Container(
                              // height: 300,
                              margin: EdgeInsets.only(
                                  right: 16, left: 16, bottom: 16),
                              width: Dimensions.screenWidth(context),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AddVerticalSpace(16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextView(
                                        text:
                                            "Items (${orderViewModel.orderList.value[widget.index].totalItems})",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      TextView(
                                        text:
                                            "${Token.curency}${orderViewModel.orderList.value[widget.index].totalItemPrice}",
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
                                        text: "Shipping",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                      TextView(
                                        text:
                                            "${Token.curency}${orderViewModel.orderList.value[widget.index].shippingOrder}",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                    ],
                                  ),
                                  // AddVerticalSpace(16),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     TextView(
                                  //       text: "Import charges",
                                  //       fontSize: 14,
                                  //       fontWeight: FontWeight.w400,
                                  //       color: AppColors.grey,
                                  //     ),
                                  //     TextView(
                                  //       text: "100",
                                  //       fontSize: 14,
                                  //       fontWeight: FontWeight.w400,
                                  //       color: AppColors.black,
                                  //     ),
                                  //   ],
                                  // ),
                                  AddVerticalSpace(16),
                                  DottedLine(
                                    dashColor: AppColors.grey.withOpacity(0.3),
                                  ),
                                  AddVerticalSpace(16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextView(
                                        text: "Total Price",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black,
                                      ),
                                      TextView(
                                        text:
                                            "${Token.curency}${orderViewModel.orderList.value[widget.index].totalAmount}",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.mainColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            AddVerticalSpace(16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // AddVerticalSpace(20),
                ],
              ),
            ),
          ),
        ));
  }
}
