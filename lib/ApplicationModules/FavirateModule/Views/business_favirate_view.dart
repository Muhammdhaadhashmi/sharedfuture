import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/FavirateModule/ViewModels/favirate_view_model.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/text_view.dart';

import '../../BusinessModule/Models/business_model.dart';
import '../../BusinessModule/ViewModels/business_view_model.dart';
import '../../BusinessModule/Views/Components/business_list_item.dart';

class BusinessFavirateView extends StatefulWidget {
  const BusinessFavirateView({Key? key}) : super(key: key);

  @override
  State<BusinessFavirateView> createState() => _BusinessFavirateViewState();
}

class _BusinessFavirateViewState extends State<BusinessFavirateView> {
  FavirateViewModel favirateViewModel = Get.put(FavirateViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: FutureBuilder(
              future: favirateViewModel.getFavBusiness(),
              builder: (context, snapshot) {
                return Obx(
                    () => favirateViewModel.favbusinessList.value.length != 0
                        ? GridView.builder(
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
                                favirateViewModel.favbusinessList.value.length,
                            itemBuilder: (context, index) {
                              var data = favirateViewModel
                                  .favbusinessList.value[index];
                              return BusinessListItem(
                                businessModel: BusinessModel(
                                  user_id: data.user_id,
                                  shippingCharges: data.shippingCharges,
                                  businessId: data.businessId,
                                  businessName: data.businessName,
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
                          )
                        : Center(
                            child: TextView(
                            text: "No record",
                            color: AppColors.white,
                          )));
              }),
        ),
      ),
    );
  }
}
