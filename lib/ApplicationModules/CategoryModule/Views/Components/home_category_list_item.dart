import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/text_view.dart';

import '../../../../Utils/token.dart';
import '../category_business_list_view.dart';

class HomeCategoryListItem extends StatelessWidget {
  final CategoryModel categoryModel;

  const HomeCategoryListItem({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          CategoryBusinessListView(categoryModel: categoryModel),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 600),
        );
      },
      child: Container(
        height: 110,
        width: 120,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        // margin: EdgeInsets.only(right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: OptimizedCacheImage(
                  height: 70,
                  width: 110,
                  imageUrl: "${Token.ImageDir}${categoryModel.categoryImage}",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
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
            ),
            Container(
              width: 150,
              child: TextView(
                text: categoryModel.categoryName,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left,
                textOverflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
      // child: Container(
      //   width: 90,
      //   // height: 70,
      //   margin: EdgeInsets.only(right: 10, bottom: 10),
      //   decoration:
      //       BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
      //     BoxShadow(color: AppColors.grey, blurRadius: 5, offset: Offset(1, 3))
      //   ]),
      //   child: Stack(
      //     children: [
      //       Container(
      //         width: 90,
      //         height: 70,
      //         decoration: BoxDecoration(
      //           color: AppColors.mainColor,
      //           borderRadius: BorderRadius.circular(20),
      //         ),
      //         child: ClipRRect(
      //           borderRadius: BorderRadius.circular(20),
      //           child: OptimizedCacheImage(
      //             imageUrl: image,
      //             progressIndicatorBuilder: (context, url, downloadProgress) =>
      //                 Center(
      //               child: CircularProgressIndicator(
      //                 value: downloadProgress.progress,
      //                 color: AppColors.white,
      //               ),
      //             ),
      //             errorWidget: (context, url, error) => Icon(
      //               Icons.error,
      //               color: AppColors.white,
      //             ),
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //       Container(
      //         width: 90,
      //         height: 70,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(20),
      //           gradient: LinearGradient(
      //             colors: [
      //               AppColors.black.withOpacity(0.3),
      //               AppColors.black.withOpacity(0.3),
      //             ],
      //           ),
      //         ),
      //         child: Center(
      //           child: TextView(
      //             text: "Category",
      //             color: AppColors.white,
      //             fontSize: 16,
      //             fontWeight: FontWeight.w600,
      //             textAlign: TextAlign.center,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
