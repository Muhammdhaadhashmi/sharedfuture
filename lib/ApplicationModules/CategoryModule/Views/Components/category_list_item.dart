import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';
import 'package:shared_future/Utils/app_colors.dart';

import '../../../../Utils/text_view.dart';
import '../../../../Utils/token.dart';
import '../category_business_list_view.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryListItem({super.key, required this.categoryModel});

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
        height: 90,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.white,
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
                  height: 80,
                  width: 120,
                  imageUrl: "${Token.ImageDir}${categoryModel.categoryImage}",
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
            Container(
              width: 150,
              child: TextView(
                text: categoryModel.categoryName,
                color: AppColors.black,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
      ),
    );
  }
}
