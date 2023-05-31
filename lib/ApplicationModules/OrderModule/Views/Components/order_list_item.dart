import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/OrderModule/ViewModels/order_view_model.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/dimensions.dart';
import 'package:shared_future/Utils/spaces.dart';

import '../../../../Utils/text_view.dart';
import '../../../../Utils/token.dart';
import '../../Models/order_detail_model.dart';
import '../../Models/order_model.dart';
import '../order_details_view.dart';
import '../order_history_details_view.dart';

class OrderListItem extends StatefulWidget {
  final OrderModel orderModel;
  final int index;
  final bool history;

  const OrderListItem({
    super.key,
    required this.orderModel,
    required this.index,
    required this.history,
  });

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          !widget.history
              ? OrderDetailView(index: widget.index)
              : OrderHistoryDetailView(index: widget.index),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 600),
        );
      },
      child: Container(
        // height: 300,
        margin: EdgeInsets.only(right: 16, left: 16, bottom: 16),
        width: Dimensions.screenWidth(context),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextView(
              text: "${widget.orderModel.orderNo}",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            AddVerticalSpace(16),
            TextView(
              text: "Order at : ${widget.orderModel.dateTime}",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
            AddVerticalSpace(16),
            DottedLine(
              dashColor: AppColors.grey.withOpacity(0.3),
            ),
            AddVerticalSpace(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextView(
                  text: "Order Status",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                TextView(
                  text: "${widget.orderModel.orderStatus}",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ],
            ),
            AddVerticalSpace(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextView(
                  text: "Business",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                TextView(
                  text: "${widget.orderModel.businessName}",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ],
            ),
            AddVerticalSpace(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextView(
                  text: "Item",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                TextView(
                  text: "${widget.orderModel.totalItems} Items purchased",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ],
            ),
            AddVerticalSpace(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextView(
                  text: "Price",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                TextView(
                  text: "${Token.curency}${widget.orderModel.totalAmount}",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
