import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_future/ApplicationModules/OrderModule/Views/Components/order_list_item.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/Views/edit_profile_view.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/dimensions.dart';
import 'package:shared_future/Utils/spaces.dart';

import '../../../Utils/text_view.dart';
import '../Models/order_detail_model.dart';
import '../Models/order_model.dart';
import '../ViewModels/order_view_model.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({Key? key}) : super(key: key);

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  OrderViewModel orderViewModel = Get.put(OrderViewModel());
  RefreshController refreshController = RefreshController(initialRefresh: true);
  bool show = false;

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
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
    Future.delayed(Duration(seconds: 2),(){
      setState(() {
        show = true;
      });
    });
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
                            text: "Orders History",
                            fontSize: 20,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AddVerticalSpace(20),
              Divider(
                height: 1,
                color: AppColors.white,
                thickness: 1,
              ),
              AddVerticalSpace(10),
              Container(
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
                      children: [
                        FutureBuilder(
                            future: orderViewModel.getOrdersHistory(),
                            builder: (context, snapshot) {
                              return !show?SizedBox():Obx(() => ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: orderViewModel
                                        .ordehistoryrList.value.length,
                                    itemBuilder: (context, index) {
                                      var data = orderViewModel
                                          .ordehistoryrList.value[index];
                                      return OrderListItem(
                                        history: true,
                                        index: index,
                                        orderModel: OrderModel(
                                          business_mid: data.business_mid,
                                          businessAddress: data.businessAddress,
                                          businessContact: data.businessContact,
                                          businessName: data.businessName,
                                          orderId: data.orderId,
                                          customerId: data.customerId,
                                          orderNo: data.orderNo,
                                          businessId: data.businessId,
                                          dateTime: data.dateTime,
                                          orderStatus: data.orderStatus,
                                          totalItemPrice: data.totalItemPrice,
                                          shippingOrder: data.shippingOrder,
                                          totalItems: data.totalItems,
                                          shippingDate: data.shippingDate,
                                          totalAmount: data.totalAmount,
                                        ),
                                      );
                                    },
                                  ));
                            }),
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
