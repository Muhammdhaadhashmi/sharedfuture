import 'package:flutter/material.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:shared_future/Utils/text_view.dart';

class StepIndicator extends StatelessWidget {
  final bool done;

  const StepIndicator({super.key, required this.done});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 22,
          width: 22,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: done ? AppColors.green : AppColors.grey,
              shape: BoxShape.circle),
          child: FittedBox(
              child: Icon(
            Icons.done,
            color: AppColors.white,
          )),
        ),
        AddVerticalSpace(10),
        TextView(
          text: done?"Success":"Pending",
          color: AppColors.white,

        ),
      ],
    );
  }
}
