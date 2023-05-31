import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/Models/user_model.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/Views/edit_profile_view.dart';
import 'package:shared_future/LocalDatabaseHelper/local_database_handler.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/dimensions.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:shared_future/Utils/token.dart';

import '../../../Utils/text_view.dart';
import '../ViewModels/profile_view_model.dart';
import 'Components/profile_list_item.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // List profileList = [];

  LocalDatabaseHepler db = LocalDatabaseHepler();
  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());
  RefreshController refreshController = RefreshController(initialRefresh: true);


  // void onRefresh() async {
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   profileViewModel.get();
  //   refreshController.refreshCompleted();
  // }
  //
  // void onLoading() async {
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   refreshController.loadComplete();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileViewModel.getCurrentUser();
    print(profileViewModel.localCurrentUserList.value[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Container(
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
            child: Column(
              children: [
                AddVerticalSpace(50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.chevron_left,
                              color: AppColors.white,
                            ),
                            AddHorizontalSpace(5),
                            TextView(
                              text: "Profile",
                              fontSize: 20,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          Get.to(
                            EditProfileView(
                              userModel: UserModel(
                                customerId: profileViewModel
                                    .localCurrentUserList.value[0].customerId,
                                customerName: profileViewModel
                                    .localCurrentUserList.value[0].customerName,
                                customerPhone: profileViewModel
                                    .localCurrentUserList
                                    .value[0]
                                    .customerPhone,
                                customerEmail: profileViewModel
                                    .localCurrentUserList
                                    .value[0]
                                    .customerEmail,
                                customerPassword: profileViewModel
                                    .localCurrentUserList
                                    .value[0]
                                    .customerPassword,
                                customerAddress: profileViewModel
                                    .localCurrentUserList
                                    .value[0]
                                    .customerAddress,
                                customerStatus: profileViewModel
                                    .localCurrentUserList
                                    .value[0]
                                    .customerStatus,
                                customerImage: profileViewModel
                                    .localCurrentUserList
                                    .value[0]
                                    .customerImage,
                                customer_type: profileViewModel
                                    .localCurrentUserList
                                    .value[0]
                                    .customer_type,
                                customerLocationLat: profileViewModel
                                    .localCurrentUserList
                                    .value[0]
                                    .customerLocationLat,
                                customerLocationLng: profileViewModel
                                    .localCurrentUserList
                                    .value[0]
                                    .customerLocationLng,
                                is_verified: profileViewModel
                                    .localCurrentUserList.value[0].is_verified,
                              ),
                            ),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 600),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.edit_note,
                            color: AppColors.white,
                          ),
                        ),
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
                AddVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: OptimizedCacheImage(
                            imageUrl:
                                "${Token.ImageDir}${profileViewModel.localCurrentUserList.value[0].customerImage}",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: AppColors.mainColor,
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
                      AddHorizontalSpace(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(
                            text:
                                "${profileViewModel.localCurrentUserList.value[0].customerName}",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                          TextView(
                            text:
                                "${profileViewModel.localCurrentUserList.value[0].customerEmail}",
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AddVerticalSpace(20),
                Expanded(
                  // height: Dimensions.screenHeight(context) - 240,
                  child: ListView.builder(
                    itemCount: profileViewModel.profileList.value.length,
                    itemBuilder: (context, index) {
                      return ProfileListItem(
                        listItem: profileViewModel.profileList.value[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
