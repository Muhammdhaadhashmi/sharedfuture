import 'package:flutter/material.dart';
import 'package:flutter_multi_slider/flutter_multi_slider.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';
import 'package:shared_future/ApplicationModules/CategoryModule/Views/Components/category_list_item.dart';
import 'package:shared_future/ApplicationModules/ExploreModule/Views/Components/filter_category_list_item.dart';
import 'package:shared_future/Utils/btn.dart';
import 'package:shared_future/Utils/dimensions.dart';
import 'package:shared_future/Utils/text_edit_field.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/spaces.dart';
import '../../../../Utils/text_view.dart';
import '../../ViewModels/explore_view_model.dart';
import 'filter_location_list_item.dart';

class FilterView extends StatefulWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  TextEditingController fromPrice = TextEditingController();
  TextEditingController toPrice = TextEditingController();

  ExploreViewModel exploreViewModel = Get.put(ExploreViewModel());

  List<double> priceList = [10, 50000];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: AppColors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddVerticalSpace(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextView(
                    text: "Filter Search",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            AddVerticalSpace(10),
            Divider(
              height: 1,
              color: AppColors.grey,
              thickness: 1,
            ),
            AddVerticalSpace(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  exploreViewModel.exploreIndex == 1
                      ? Column(
                          children: [
                            TextView(
                              text: "Price Range",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            AddVerticalSpace(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextEditField(
                                  hintText: "From",
                                  inputType: TextInputType.number,
                                  textEditingController: fromPrice,
                                  width: Dimensions.screenWidth(context) / 2.5,
                                ),
                                TextEditField(
                                  hintText: "To",
                                  inputType: TextInputType.number,
                                  textEditingController: toPrice,
                                  width: Dimensions.screenWidth(context) / 2.5,
                                ),
                              ],
                            ),
                            AddVerticalSpace(10),
                            MultiSlider(
                              color: AppColors.mainColor,
                              min: 10,
                              max: 50000,
                              values: priceList,
                              onChanged: (values) {
                                setState(() {
                                  priceList = values;
                                });
                                fromPrice.text = "${priceList[0].ceil()}";
                                toPrice.text = " ${priceList[1].ceil()}";
                              },
                            ),
                          ],
                        )
                      : SizedBox(),
                  AddVerticalSpace(5),
                  TextView(
                    text: "Category",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  AddVerticalSpace(10),
                  Container(
                    height: 60,
                    child: FutureBuilder(
                        future: exploreViewModel.getAllCategories(),
                        builder: (context, snapshot) {
                          return Obx(
                            () => ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  exploreViewModel.categoryList.value.length,
                              itemBuilder: (context, index) {
                                var data =
                                    exploreViewModel.categoryList.value[index];
                                return FilterCategoryListItem(
                                  categoryModel: CategoryModel(
                                    categoryId: data.categoryId,
                                    categoryName: data.categoryName,
                                    category_type: data.category_type,
                                    categoryImage: data.categoryImage,
                                    categoryStatus: data.categoryStatus,
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                  ),
                  AddVerticalSpace(10),
                  exploreViewModel.exploreIndex == 0
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView(
                              text: "Location",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            AddVerticalSpace(10),
                            Container(
                              height: 60,
                              child: FutureBuilder(
                                  future: null,
                                  builder: (context, snapshot) {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: exploreViewModel
                                          .LocationList.value.length,
                                      itemBuilder: (context, index) {
                                        return FilterLocationListItem(
                                          Location: exploreViewModel
                                              .LocationList.value[index],
                                        );
                                      },
                                    );
                                  }),
                            ),
                          ],
                        )
                      : SizedBox(),
                  AddVerticalSpace(20),
                  Center(
                    child: BTN(
                      color: AppColors.mainColor,
                      textColor: AppColors.white,
                      title: "Apply Filter",
                      onPressed: () {
                        // exploreViewModel.fromPrice.value= double.parse(fromPrice.text);
                        // exploreViewModel.toPrice.value= double.parse(toPrice.text);
                        exploreViewModel.fromPrice.value = fromPrice.text!=""?double.parse(fromPrice.text):priceList[0];
                        exploreViewModel.toPrice.value = toPrice.text!=""?double.parse(toPrice.text):priceList[1];
                        exploreViewModel.getFilterBusiness();
                        exploreViewModel.getCatProducts();
                        Get.back();
                      },
                      width: Dimensions.screenWidth(context) - 100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
