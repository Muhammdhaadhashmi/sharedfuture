import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shared_future/ApplicationModules/CartModule/Models/cart_model.dart';
import 'package:shared_future/ApplicationModules/CartModule/ViewModels/cart_view_model.dart';
import 'package:shared_future/LocalDatabaseHelper/local_database_handler.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/dimensions.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:shared_future/Utils/token.dart';

import '../../../../Utils/text_view.dart';

class CartListItem extends StatelessWidget {
  final CartModel cartModel;
  final int index;

  CartListItem({
    super.key,
    required this.cartModel,
    required this.index,
  });

  CartViewModel cartViewModel = Get.put(CartViewModel());

  LocalDatabaseHepler db = LocalDatabaseHepler();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          // height: 120,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(right: 16, left: 16, bottom: 10),
          width: Dimensions.screenWidth(context),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
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
                    height: 80,
                    width: 72,
                    imageUrl: "${Token.ImageDir}${cartModel.image}",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
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
              AddHorizontalSpace(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Dimensions.screenWidth(context) - 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height: 50,
                          width: 156,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextView(
                                text: "${cartModel.productName}",
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                              TextView(
                                text: "${cartModel.property}",
                                // fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                              TextView(
                                text: "Unit ${cartModel.unit}",
                                // fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                              TextView(
                                text: "${cartModel.des}",
                                // fontWeight: FontWeight.w700,
                                fontSize: 9,
                              ),

                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            db.deleteCart(id: cartModel.id!);
                            cartViewModel.carList.removeWhere(
                                (element) => element.id == cartModel.id!);
                            cartViewModel.getCartCount();
                            cartViewModel.getCartFromLocal();
                          },
                          child: Icon(
                            Icons.delete,
                            color: AppColors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  AddVerticalSpace(8),
                  Container(
                    width: Dimensions.screenWidth(context) - 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextView(
                              text: cartModel.discountPrice == 0
                                  ? "${Token.curency}${cartModel.salePrice}"
                                  : "${Token.curency}${(cartModel.salePrice) - (cartModel.discountPrice)}",
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.mainColor,
                            ),
                            AddHorizontalSpace(5),
                            TextView(
                              text: cartModel.discountPrice != 0
                                  ? "${Token.curency}${cartModel.salePrice}"
                                  : "",
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (cartViewModel
                                            .carList.value[index].quantity -
                                        1 >
                                    0) {
                                  cartViewModel.quantity.value = cartViewModel
                                      .carList.value[index].quantity;
                                  cartViewModel.quantity.value--;

                                  cartViewModel.singleProductPrice.value =
                                      (cartModel.salePrice -
                                              cartModel.discountPrice) *
                                          (cartViewModel.quantity.value);

                                  await db.updateCartQuantity(
                                      id: cartModel.id!,
                                      quantity: cartViewModel.quantity.value);
                                  await db.updateProductPrice(
                                      id: cartModel.id!,
                                      Price: cartViewModel
                                          .singleProductPrice.value);
                                  await cartViewModel.getCartFromLocal();
                                }
                              },
                              child: Container(
                                height: 25,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                  border: Border.all(
                                      color: AppColors.lightgrey, width: 1),
                                ),
                                child: Center(
                                  child: TextView(
                                    text: "-",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 25,
                              width: 35,
                              decoration: BoxDecoration(
                                color: AppColors.lightgrey,
                              ),
                              child: Center(
                                child: TextView(
                                  // text: "${cartModel.quantity}",
                                  text:
                                      "${cartViewModel.carList.value[index].quantity}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // cartViewModel.total.value=0;?
                                print(cartModel.saleQuantity);
                                if (cartViewModel.quantity.value <
                                    cartModel.saleQuantity) {
                                  cartViewModel.quantity.value =
                                      cartViewModel.carList[index].quantity;
                                  cartViewModel.quantity.value++;
                                  cartViewModel.singleProductPrice.value =
                                      (cartModel.salePrice -
                                              cartModel.discountPrice) *
                                          (cartViewModel.quantity.value);
                                  await db.updateCartQuantity(
                                      id: cartModel.id!,
                                      quantity: cartViewModel.quantity.value);
                                  await db.updateProductPrice(
                                      id: cartModel.id!,
                                      Price: cartViewModel
                                          .singleProductPrice.value);
                                  await cartViewModel.getCartFromLocal();
                                }
                              },
                              child: Container(
                                height: 25,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                  border: Border.all(
                                      color: AppColors.lightgrey, width: 1),
                                ),
                                child: Center(
                                  child: TextView(
                                    text: "+",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
