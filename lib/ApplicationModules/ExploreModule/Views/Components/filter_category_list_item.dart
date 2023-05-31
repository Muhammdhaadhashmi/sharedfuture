import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/text_view.dart';
import '../../ViewModels/explore_view_model.dart';

class FilterCategoryListItem extends StatefulWidget {
  final CategoryModel categoryModel;

  const FilterCategoryListItem({super.key, required this.categoryModel});

  @override
  State<FilterCategoryListItem> createState() => _FilterCategoryListItemState();
}

class _FilterCategoryListItemState extends State<FilterCategoryListItem> {
  bool selected = false;
  ExploreViewModel exploreViewModel = Get.put(ExploreViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (exploreViewModel.selectedCat.value
        .contains(widget.categoryModel.categoryId)) {
      setState(() {
        selected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        if (selected) {
          exploreViewModel.selectedCat.value
              .add(widget.categoryModel.categoryId);
        } else {
          exploreViewModel.selectedCat.value.removeWhere(
              (element) => element == widget.categoryModel.categoryId);
        }
        print(exploreViewModel.selectedCat.value);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.mainColor.withOpacity(0.2) : AppColors.white,
          border: Border.all(
            color: AppColors.lightgrey,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: TextView(
            text: "${widget.categoryModel.categoryName}",
            color: selected ? AppColors.mainColor : AppColors.black,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
