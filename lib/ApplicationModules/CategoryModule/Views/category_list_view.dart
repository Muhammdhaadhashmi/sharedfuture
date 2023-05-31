import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/ViewModels/category_view_model.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/search_text_field.dart';
import '../../../Utils/spaces.dart';
import 'Components/category_list_item.dart';

class CategoryListView extends StatelessWidget {
  TextEditingController search = TextEditingController();

  CategoryViewModel categoryViewModel = Get.put(CategoryViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        height: Dimensions.screenHeight(context),
        width: Dimensions.screenWidth(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientLight,
              AppColors.gradientDark,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddVerticalSpace(50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    AddHorizontalSpace(10),
                    SearchTextField(
                      readOnly: true,
                      onTap: () {},
                      width: Dimensions.screenWidth(context) - 95,
                      hintText: "Search",
                      textEditingController: search,
                      prefixIcon: Icon(Icons.search),
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                    future: categoryViewModel.getBussinessCategories(),
                    builder: (context, snapshot) {
                      return Obx(() => GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.3,
                              // mainAxisExtent: 150,
                            ),
                            itemCount: categoryViewModel
                                .bussinessCategoryList.value.length,
                            itemBuilder: (context, index) {
                              var data = categoryViewModel
                                  .bussinessCategoryList.value[index];
                              return CategoryListItem(
                                categoryModel: CategoryModel(
                                  categoryId: data.categoryId,
                                  categoryName: data.categoryName,
                                  category_type: data.category_type,
                                  categoryImage: data.categoryImage,
                                  categoryStatus: data.categoryStatus,
                                ),
                              );
                            },
                          ));
                    }),
              ),
              AddVerticalSpace(10),
            ],
          ),
        ),
      ),
    );
  }
}
