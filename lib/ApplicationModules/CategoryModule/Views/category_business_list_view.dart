import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Models/business_model.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Views/Components/business_list_item.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';
import 'package:shared_future/ApplicationModules/ProductsModule/Views/Components/product_list_item.dart';
import 'package:shared_future/Utils/text_view.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/search_text_field.dart';
import '../../../Utils/spaces.dart';
import '../../BusinessModule/ViewModels/business_view_model.dart';
import '../../ProductsModule/Models/product_model.dart';
import '../../ProductsModule/ViewModels/product_view_model.dart';
import '../ViewModels/category_view_model.dart';
import 'Components/category_list_item.dart';

class CategoryBusinessListView extends StatelessWidget {
  final CategoryModel categoryModel;

  CategoryBusinessListView({super.key, required this.categoryModel});

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
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
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
                    AddVerticalSpace(10),
                    Container(
                      width: Dimensions.screenWidth(context)-50,
                      child: Center(
                        child: TextView(
                          text: categoryModel.categoryName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: FutureBuilder(
                    future: categoryViewModel.getCAtegoryBusiness(
                        cat: categoryModel.categoryId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Obx(() => GridView.builder(
                        padding: EdgeInsets.only(top: 10),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 00,
                              mainAxisSpacing: 0,
                              childAspectRatio: 0.8,
                              // mainAxisExtent: 150,
                            ),
                            itemCount:
                                categoryViewModel.catBusinessList.value.length,
                            itemBuilder: (context, index) {
                              var data = categoryViewModel
                                  .catBusinessList.value[index];
                              return BusinessListItem(
                                businessModel: BusinessModel(
                                  businessId: data.businessId,
                                  shippingCharges: data.shippingCharges,
                                  businessName: data.businessName,
                                  user_id: data.user_id,
                                  businessNumber: data.businessNumber,
                                  businessCategory: data.businessCategory,
                                  businessAddress: data.businessAddress,
                                  businessDescription: data.businessDescription,
                                  businessImage: data.businessImage,
                                  businessLocationLat: data.businessLocationLat,
                                  businessLocationLng: data.businessLocationLng,
                                  businessStatus: data.businessStatus,
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
