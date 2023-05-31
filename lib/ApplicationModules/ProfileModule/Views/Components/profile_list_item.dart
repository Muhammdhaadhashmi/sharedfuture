import 'package:flutter/material.dart';
import 'package:shared_future/Utils/dimensions.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/spaces.dart';
import '../../../../Utils/text_view.dart';

class ProfileListItem extends StatelessWidget {
  final listItem;

  const ProfileListItem({super.key, required this.listItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: Dimensions.screenWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AddHorizontalSpace(20),
              Container(
                height: 24,
                width: 24,
                child: Icon(
                  listItem["icon"],
                  color: AppColors.white,
                ),
              ),
              AddHorizontalSpace(20),
              TextView(
                text: listItem["title"],
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                fontSize: 14,
              ),
            ],
          ),
          Row(
            children: [
              TextView(
                text: listItem["data"],
                color: AppColors.white,
              ),
              // Icon(
              //   Icons.chevron_right,
              //   color: AppColors.grey,
              // ),
              AddHorizontalSpace(20),
            ],
          ),
        ],
      ),
    );
  }
}
