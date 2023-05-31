import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Models/business_model.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/text_view.dart';
import 'package:http/http.dart' as http;
import '../../../../Utils/token.dart';
import '../../../ProfileModule/ViewModels/profile_view_model.dart';
import '../business_detail_view.dart';

class BusinessListItem extends StatefulWidget {
  final BusinessModel businessModel;

  const BusinessListItem({super.key, required this.businessModel});

  @override
  State<BusinessListItem> createState() => _BusinessListItemState();
}

class _BusinessListItemState extends State<BusinessListItem> {
  bool favirate = false;
  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (profileViewModel.localCurrentUserList.value.length != 0) {
      profileViewModel.getBusinessFavirateFromApis();
      for (final value in profileViewModel.busfavirateList.value) {
        if (value.userId ==
                profileViewModel.localCurrentUserList.value[0].customerId &&
            value.busId == widget.businessModel.businessId) {
          setState(() {
            favirate = true;
          });
          print(favirate);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          BusinessDetailsView(businessModel: widget.businessModel, isMY: false),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 600),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            // height: 200,
            width: 180,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
              // border: Border.all(width: 1, color: AppColors.white),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: OptimizedCacheImage(
                      height: 120,
                      width: 170,
                      imageUrl:
                          "${Token.ImageDir}${widget.businessModel.businessImage}",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          color: AppColors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: AppColors.red,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // AddVerticalSpace(8),
                TextView(
                  text: "${widget.businessModel.businessName}",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  textOverflow: TextOverflow.ellipsis,
                ),
                // AddVerticalSpace(8),
                TextView(
                  text: "${widget.businessModel.businessAddress}",
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.mainColor,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: InkWell(
              onTap: () async {
                setState(() {
                  favirate = !favirate;
                });

                print(favirate);

                if (favirate) {
                  await http.post(
                    Uri.parse("${Token.apiHeader}addBusinessFvrt"),
                    body: {
                      "user_id":
                          "${profileViewModel.localCurrentUserList.value[0].customerId}",
                      "business_id": "${widget.businessModel.businessId}",
                    },
                  ).then((value) {
                    print(value.body);
                  });
                } else {
                  await http
                      .delete(
                    // Uri.parse("${Token.apiHeader}deleteProductFvrt"),
                    Uri.parse(
                        "${Token.apiHeader}deleteBusinessFvrt/${profileViewModel.localCurrentUserList.value[0].customerId}/${widget.businessModel.businessId}"),
                    // body: {
                    //   "user_id":"${profileViewModel.localCurrentUserList.value[0].customerId}",
                    //   "pro_id":"${widget.productModel.id}",
                    // },
                  )
                      .then((value) {
                    print(value.body);
                  });
                }
              },
              borderRadius: BorderRadius.circular(100),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  favirate?Icons.favorite: Icons.favorite_border,
                  color:favirate?AppColors.red:AppColors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
