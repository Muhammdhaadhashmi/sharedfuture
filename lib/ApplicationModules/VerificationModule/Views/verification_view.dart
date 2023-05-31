import 'dart:convert';
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
import '../../AuthenticationModule/Views/sign_up_view.dart';
import '../../HomeModule/ViewModels/home_view_model.dart';
import '../../ProfileModule/Models/user_model.dart';
import 'change_password.dart';

class VerificationView extends StatefulWidget {
  final String email;
  final bool forget;

  const VerificationView({
    super.key,
    required this.email,
    required this.forget,
  });

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  AuthViewModel authViewModel = Get.put(AuthViewModel());
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  LocalDatabaseHepler db = LocalDatabaseHepler();

  TextEditingController email = TextEditingController();
  bool emailValid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email.text = widget.email;
    http
        .get(Uri.parse("${Token.apiHeader}send-verify-email/${widget.email}"))
        .then((value) {
      print("value");
      print(value.body);
    });
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
                                text: "Email Verification",
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
                                text: "Continue to Shared Future",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              AddVerticalSpace(20),
                              TextView(
                                text: "Verify your email to continue",
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
                              Container(
                                width: Dimensions.screenWidth(context),
                                child: OTPTextField(
                                  length: 4,
                                  width: MediaQuery.of(context).size.width,
                                  fieldWidth: 50,
                                  style: TextStyle(fontSize: 17),
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.box,
                                  onChanged: (v) {},
                                  onCompleted: (pin) async {
                                    homeViewModel.index.value = 0;
                                    await http.post(
                                        Uri.parse("${Token.apiHeader}checkOTP"),
                                        body: {
                                          "email": widget.email,
                                          "OTP": pin,
                                        }).then((value) async {
                                      print(value.statusCode);
                                      print(value.body);
                                      if (jsonDecode(value.body)["success"]) {
                                        if (widget.forget) {
                                          Get.to(
                                            ChangePasswordView(
                                                email: widget.email),
                                            transition: Transition.rightToLeft,
                                            duration:
                                                Duration(milliseconds: 600),
                                          );
                                        } else {
                                          await http.post(
                                              Uri.parse(
                                                  "${Token.apiHeader}isVerified"),
                                              body: {
                                                "email": widget.email,
                                                "OTP": pin,
                                              }).then((value) async {
                                            await db.insertUserForLogin(
                                                email: widget.email);
                                            await db.updateUserVerify(
                                                email: widget.email);

                                            Get.offAll(
                                              SignInView(),
                                              transition:
                                                  Transition.rightToLeft,
                                              duration:
                                                  Duration(milliseconds: 600),
                                            );
                                          });
                                        }
                                      } else {
                                        FlutterErrorToast(error: "Wrong OTP");
                                      }
                                    });
                                    print("Completed: " + pin);
                                  },
                                ),
                              ),
                              AddVerticalSpace(20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    print("object");
                                    http
                                        .get(Uri.parse("${Token.apiHeader}send-verify-email/${widget.email}"))
                                        .then((value) {
                                      print("value");
                                      print(value.body);
                                    });
                                  },
                                  child: TextView(
                                    text: "Resend Code?",
                                    color: AppColors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              AddVerticalSpace(100),
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
    );
  }
}
