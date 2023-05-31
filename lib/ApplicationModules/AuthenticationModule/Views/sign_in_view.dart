import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_future/ApplicationModules/AuthenticationModule/Views/sign_up_view.dart';
import 'package:shared_future/ApplicationModules/VerificationModule/Views/verification_view.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/btn.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:shared_future/Utils/text_edit_field.dart';
import 'package:shared_future/Utils/text_view.dart';
import 'package:shared_future/Utils/toast.dart';

import '../../../LocalDatabaseHelper/local_database_handler.dart';
import '../../../Utils/dimensions.dart';
import '../../../main.dart';
import '../../HomeModule/ViewModels/home_view_model.dart';
import '../../HomeModule/Views/app_route_view.dart';

class SignInView extends StatefulWidget {
  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  LocalDatabaseHepler db = LocalDatabaseHepler();
  HomeViewModel homeViewModel = Get.put(HomeViewModel());

  bool emailValid = false;
  bool passwordValid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db.deleteTable(tableName: "tbl_login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildMyNavBar(context),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddVerticalSpace(50),
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
                      text: "Sign in",
                      fontSize: 20,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              AddVerticalSpace(20),
              Divider(
                color: AppColors.white,
                thickness: 2,
              ),
              AddVerticalSpace(100),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/Icons/vendor.png"),
                    ),
                    AddVerticalSpace(20),
                    TextView(
                      text: "Wellcome to Shared Future",
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 18,
                    ),
                    AddVerticalSpace(20),
                    TextView(
                      text: "Sign in to continue",
                      color: AppColors.white,
                    ),
                    AddVerticalSpace(20),
                    TextEditField(
                      hintText: "Your Email",
                      hintSize: 14,
                      textEditingController: email,
                      inputType: TextInputType.emailAddress,
                      width: Dimensions.screenWidth(context),
                      errorText: emailValid ? "Enter Email" : null,
                      preffixIcon: Icon(Icons.email_outlined),
                    ),
                    AddVerticalSpace(16),
                    TextEditField(
                      hintText: "Your Password",
                      hintSize: 14,
                      inputType: TextInputType.visiblePassword,
                      textEditingController: password,
                      width: Dimensions.screenWidth(context),
                      errorText: passwordValid ? "Enter Password" : null,
                      preffixIcon: Icon(Icons.lock_outline),
                      isPassword: true,
                    ),
                    AddVerticalSpace(30),
                    BTN(
                      title: "Sign in",
                      onPressed: () {
                        setState(() {
                          if (email.text.isEmpty) {
                            emailValid = true;
                          } else if (password.text.isEmpty) {
                            passwordValid = true;
                          }
                        });
                        if (email.text.isNotEmpty && password.text.isNotEmpty) {
                          db.checkUserForLogin(
                              email: email.text, password: password.text)
                              .then((value) {
                            db.deleteTable(tableName: "tbl_cart");

                            homeViewModel.index.value == 0;
                            print(value);
                            if (value.length != 0) {
                              // homeViewModel.index.value = 0;
                              homeViewModel.checkAcountExits();
                              db
                                  .checkUserVarified(
                                email: email.text,
                              )
                                  .then((res) async {
                                if (res != "0") {
                                  await db.insertUserForLogin(
                                      email: email.text);
                                  Get.offAll(
                                    AppRouteView(),
                                    transition: Transition.rightToLeft,
                                    duration: Duration(milliseconds: 600),
                                  );
                                  print("hello");
                                } else {
                                  Get.offAll(
                                    VerificationView(
                                        email: email.text, forget: false),
                                    transition: Transition.rightToLeft,
                                    duration: Duration(milliseconds: 600),
                                  );
                                }
                              });
                            } else {
                              FlutterErrorToast(error: "Invalid User");
                            }
                          });
                        }
                      },
                      color: AppColors.mainColor,
                      textColor: AppColors.white,
                      width: Dimensions.screenWidth(context) - 100,
                    ),
                    AddVerticalSpace(16),
                    InkWell(
                      onTap: () {
                        if (email.text.isEmpty) {
                          setState(() {
                            emailValid = true;
                          });
                        } else {
                          Get.to(
                            VerificationView(email: email.text, forget: true),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 600),
                          );
                        }
                      },
                      child: TextView(
                        text: "Forget password?",
                        color: AppColors.mainColor,
                      ),
                    ),
                    AddVerticalSpace(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextView(
                          text: "Don’t have a account? ",
                          color: AppColors.white,
                        ),
                        InkWell(
                          onTap: () async {
                            Get.to(
                              SignUpView(),
                              transition: Transition.rightToLeft,
                              duration: Duration(milliseconds: 600),
                            );
                          },
                          child: TextView(
                            text: "Register",
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height / 13,
      decoration: BoxDecoration(
          color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    // setState(() {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => WorkOut()));
                    //   pageIndex = 0;
                    // });
                  },
                  child: Icon(
                    Icons.support,
                    size: 25,
                  )),
              SizedBox(
                height: 5,
              ),
              Text(
                "Support",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    // setState(() {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => WeightGain()));
                    //   // pageIndex = 1;
                    // });
                  },
                  child: Icon(
                    Icons.phone,
                    size: 25,
                  )),
              SizedBox(
                height: 5,
              ),
              Text(
                "Contact us",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    // setState(() {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => DietPlan()));
                    //
                    //   pageIndex = 2;
                    // });
                  },
                  child: Icon(
                    Icons.privacy_tip_sharp,
                    size: 25,
                  )),
              SizedBox(
                height: 5,
              ),
              Text(
                "Privacy Policy",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    // setState(() {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => BmiCalculate()));
                    //
                    //   pageIndex = 2;
                    // });
                  },
                  child: Icon(
                    Icons.note_alt_sharp,
                    size: 25,
                  )),
              SizedBox(
                height: 5,
              ),
              Text(
                "Terms & Conditions",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         // setState(() {
          //         //   Navigator.push(context,
          //         //       MaterialPageRoute(builder: (context) => drawer()));
          //         //   pageIndex = 3;
          //         // });
          //       },
          //       child: Icon(
          //         Icons.person,
          //         size: 35,
          //       ),
          //     ),
          //     SizedBox(
          //       height: 5,
          //     ),
          //     Text(
          //       "Profile",
          //       style: TextStyle(color: Colors.black),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}
