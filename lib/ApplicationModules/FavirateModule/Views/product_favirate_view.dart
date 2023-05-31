import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/FavirateModule/Models/pro_favirate_model.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/text_view.dart';

import '../../ProductsModule/Models/product_model.dart';
import '../../ProductsModule/ViewModels/product_view_model.dart';
import '../../ProductsModule/Views/Components/product_list_item.dart';
import '../ViewModels/favirate_view_model.dart';

class ProductFavirateView extends StatefulWidget {
  const ProductFavirateView({Key? key}) : super(key: key);

  @override
  State<ProductFavirateView> createState() => _ProductFavirateViewState();
}

class _ProductFavirateViewState extends State<ProductFavirateView> {
  List images = [
    "https://images.unsplash.com/photo-1523800378286-dae1f0dae656?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8YmFubmVyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1513757378314-e46255f6ed16?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8YmFubmVyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1513151233558-d860c5398176?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGJhbm5lcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1614851099175-e5b30eb6f696?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGJhbm5lcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fGJhbm5lcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
  ];

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
              future: favirateViewModel.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Obx(() => favirateViewModel.favproductList.value.length !=
                        0
                    ? GridView.builder(
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 00,
                          mainAxisSpacing: 0,
                          childAspectRatio: 0.8,
                          // mainAxisExtent: 150,
                        ),
                        itemCount: favirateViewModel.favproductList.value.length,
                        itemBuilder: (context, index) {
                          var data =
                              favirateViewModel.favproductList.value[index];
                          return ProductListItem(
                            productModel: ProductModel(
                              id: data.id,                            businessManID: data.businessManID,
                              property: data.property,
                              unit: data.unit,
                              businessID: data.businessID,
                              proName: data.proName,
                              detail: data.detail,
                              proCat: data.proCat,
                              proDis: data.proDis,
                              costPrice: data.costPrice,
                              salePrice: data.salePrice,
                              discountPrice: data.discountPrice,
                              totalQty: data.totalQty,
                              saleQty: data.saleQty,
                              proImg: data.proImg,
                              proStatus: data.proStatus,
                            ),
                          );
                        },
                      )
                    : Center(child: TextView(text: "No record",color: AppColors.white,)));
              }),
        ),
      ),
    );
  }
}
