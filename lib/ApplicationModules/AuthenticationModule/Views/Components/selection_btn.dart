import 'package:flutter/material.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:shared_future/Utils/text_view.dart';

import '../../../../Utils/dimensions.dart';

class SelectionBtn extends StatelessWidget {
  final String title;
  final String image;
  final  onTap;

  const SelectionBtn({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: Dimensions.screenWidth(context) / 2.3,
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              child: Image.asset(image),
            ),
            AddVerticalSpace(20),
            TextView(
              text: title,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
