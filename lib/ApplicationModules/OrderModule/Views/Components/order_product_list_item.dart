import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shared_future/ApplicationModules/ProductsModule/Models/product_model.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/dimensions.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:shared_future/Utils/text_view.dart';

import '../../../../Utils/token.dart';

class OrderProductListItem extends StatefulWidget {
  final ProductModel productModel;
  final int quantity;

  const OrderProductListItem({
    super.key,
    required this.productModel,
    required this.quantity,
  });

  @override
  State<OrderProductListItem> createState() => _OrderProductListItemState();
}

class _OrderProductListItemState extends State<OrderProductListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.screenWidth(context),
      margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: OptimizedCacheImage(
                height: 55,
                width: 75,
                imageUrl: "${Token.ImageDir}${widget.productModel.proImg}",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    color: AppColors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: AppColors.white,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AddHorizontalSpace(10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width:Dimensions.screenWidth(context)-250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: widget.productModel.proName,
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      TextView(
                        text: "${widget.productModel.property}",
                        // fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                      TextView(
                        text: "Unit ${widget.productModel.unit}",
                        // fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                      TextView(
                        text: "Description : ${widget.productModel.proDis}",
                        // fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ],
                  ),
                ),
                TextView(
                  text:
                      "${Token.curency}${widget.productModel.salePrice - widget.productModel.discountPrice}x${widget.quantity}",
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
