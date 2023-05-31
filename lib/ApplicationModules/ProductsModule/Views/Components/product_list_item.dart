import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Models/business_model.dart';
import 'package:shared_future/ApplicationModules/FavirateModule/ViewModels/favirate_view_model.dart';
import 'package:shared_future/ApplicationModules/ProductsModule/Models/product_model.dart';
import 'package:shared_future/ApplicationModules/ProductsModule/Views/product_detail_view.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:shared_future/Utils/text_view.dart';
import 'package:http/http.dart' as http;
import '../../../../Utils/token.dart';
import '../../../ProfileModule/ViewModels/profile_view_model.dart';

class ProductListItem extends StatefulWidget {
  final ProductModel productModel;

  const ProductListItem({
    super.key,
    required this.productModel,
  });

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  bool favirate = false;
  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());
  FavirateViewModel favirateViewModel = Get.put(FavirateViewModel());

  // bool isFav = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (profileViewModel.localCurrentUserList.value.length != 0) {
      profileViewModel.getProFavirateFromApis();
      for (final value in profileViewModel.profavirateList.value) {
        if (value.userId ==
                profileViewModel.localCurrentUserList.value[0].customerId &&
            value.proId == widget.productModel.id) {
          setState(() {
            favirate = true;
          });
          print(favirate);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          ProductDetailsView(productModel: widget.productModel),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 600),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            width: 180,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: OptimizedCacheImage(
                      height: 120,
                      width: 140,
                      imageUrl:
                          "${Token.ImageDir}${widget.productModel.proImg}",
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
                TextView(
                  text: "${widget.productModel.proName}",
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  textOverflow: TextOverflow.ellipsis,
                ),
                TextView(
                  text: widget.productModel.discountPrice == 0
                      ? "${Token.curency}${widget.productModel.salePrice}"
                      : "${Token.curency}${(widget.productModel.salePrice) - (widget.productModel.discountPrice)}",
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.mainColor,
                ),
                Row(children: [
                  TextView(
                    decoration: TextDecoration.lineThrough,
                    text: widget.productModel.discountPrice != 0
                        ? "${Token.curency}${widget.productModel.salePrice}"
                        : "",
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ]),
              ],
            ),
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: InkWell(
              onTap: () async {
                setState(() {
                  favirate = !favirate;
                });

                print(favirate);

                if (favirate) {
                  await http.post(
                    Uri.parse("${Token.apiHeader}addProductFvrt"),
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
                    // Uri.parse("${Token.apiHeader}deleteProductFvrt"),
                    Uri.parse(
                        "${Token.apiHeader}deleteProductFvrt/${profileViewModel.localCurrentUserList.value[0].customerId}/${widget.productModel.id}"),
                    // body: {
                    //   "user_id":"${profileViewModel.localCurrentUserList.value[0].customerId}",
                    //   "pro_id":"${widget.productModel.id}",
                    // },
                  )
                      .then((value) {
                    print(value.body);
                    favirateViewModel.getProducts();
                  });
                }
              },
              borderRadius: BorderRadius.circular(100),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  favirate ? Icons.favorite : Icons.favorite_border,
                  // isFav?Icons.favorite: favirate?Icons.favorite:Icons.favorite_border,
                  color: favirate ? AppColors.red : AppColors.grey,
                  // color:isFav?AppColors.red: favirate?AppColors.red:AppColors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
