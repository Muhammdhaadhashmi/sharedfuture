import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_future/ApplicationModules/HomeModule/Views/app_route_view.dart';
import 'package:shared_future/Utils/btn.dart';
import 'package:shared_future/Utils/toast.dart';
import 'package:shared_future/Utils/token.dart';

import '../../../LocalDatabaseHelper/local_database_handler.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_edit_field.dart';
import '../../../Utils/text_view.dart';
import '../../AuthenticationModule/ViewModels/auth_view_model.dart';
import '../../AuthenticationModule/Views/sign_in_view.dart';
import '../../HomeModule/ViewModels/home_view_model.dart';
import '../../ProfileModule/Models/user_model.dart';

class ChangePasswordView extends StatefulWidget {
  final String email;

  const ChangePasswordView({
    super.key,
    required this.email,
  });

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  AuthViewModel authViewModel = Get.put(AuthViewModel());
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  LocalDatabaseHepler db = LocalDatabaseHepler();

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController conPass = TextEditingController();
  bool emailValid = false;
  bool passValid = false;
  bool conPassValid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                    sigmaX: authViewModel.loading.value ? 5 : 0,
                    sigmaY: authViewModel.loading.value ? 5 : 0),
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 16),
                  height: Dimensions.screenHeight(context),
                  width: Dimensions.screenWidth(context),
                  child: SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        AddVerticalSpace(50),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Row(
                            children: [
                              Icon(Icons.chevron_left),
                              AddHorizontalSpace(5),
                              TextView(
                                text: "Change Password",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                        AddVerticalSpace(20),
                        Divider(
                          height: 1,
                          color: AppColors.grey,
                          thickness: 1,
                        ),
                        AddVerticalSpace(10),
                        Container(
                          height: Dimensions.screenHeight(context) - 100,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AddVerticalSpace(20),
                              TextView(
                                text: "Change password to Shared Future",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              AddVerticalSpace(20),
                              TextView(
                                text: "Your can update your password",
                                color: AppColors.grey,
                              ),
                              AddVerticalSpace(20),
                              TextEditField(
                                hintText: "Your Email",
                                hintSize: 14,
                                readOnly: true,
                                inputType: TextInputType.emailAddress,
                                textEditingController: email,
                                width: Dimensions.screenWidth(context),
                                preffixIcon: Icon(Icons.email_outlined),
                                cursorColor: AppColors.mainColor,
                                errorText:
                                    emailValid ? "Email is Required" : null,
                              ),
                              AddVerticalSpace(40),
                              TextEditField(
                                hintText: "Your Password",
                                hintSize: 14,
                                inputType: TextInputType.visiblePassword,
                                textEditingController: pass,
                                width: Dimensions.screenWidth(context),
                                preffixIcon: Icon(Icons.lock_outline),
                                cursorColor: AppColors.mainColor,
                                errorText:
                                    passValid ? "Password is Required" : null,
                              ),
                              AddVerticalSpace(20),
                              TextEditField(
                                hintText: "Confirm Password",
                                hintSize: 14,
                                inputType: TextInputType.visiblePassword,
                                textEditingController: conPass,
                                width: Dimensions.screenWidth(context),
                                preffixIcon: Icon(Icons.lock_outline),
                                cursorColor: AppColors.mainColor,
                                errorText: conPassValid
                                    ? "Confirm Password is Required"
                                    : null,
                              ),
                              AddVerticalSpace(120),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              authViewModel.loading.value
                  ? Container(
                      height: Dimensions.screenHeight(context),
                      width: Dimensions.screenWidth(context),
                      color: AppColors.transparent,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(),
            ],
          )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: BTN(
          title: "Done",
          color: AppColors.mainColor,
          textColor: AppColors.white,
          width: Dimensions.screenWidth(context) - 100,
          onPressed: () async {
            setState(() {
              if (pass.text.isEmpty) {
                passValid = true;
              } else if (conPass.text.isEmpty) {
                conPassValid = true;
              }
            });
            if (pass.text.isNotEmpty && conPass.text.isNotEmpty) {
              if (pass.text == conPass.text) {
                http.post(
                  Uri.parse("${Token.apiHeader}newPassword"),
                  body: {"password":pass.text},
                ).then((value) {
                  Get.off(
                    SignInView(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 600),
                  );
                });
              } else {
                FlutterErrorToast(error: "Password Must be Same");
              }
            }
          },
        ),
      ),
    );
  }
}
