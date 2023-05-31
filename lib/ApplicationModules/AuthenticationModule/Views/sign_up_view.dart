import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_future/ApplicationModules/AuthenticationModule/ViewModels/auth_view_model.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Views/add_business_view.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/Models/user_model.dart';
import 'package:shared_future/ApplicationModules/VerificationModule/Views/verification_view.dart';
import 'package:shared_future/Utils/location_service.dart';
import 'package:shared_future/Utils/toast.dart';
import 'package:shared_future/Utils/token.dart';
import '../../../LocalDatabaseHelper/local_database_handler.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/btn.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_edit_field.dart';
import '../../../Utils/text_view.dart';
import '../../HomeModule/Views/app_route_view.dart';
import '../ApiServices/auth_apis.dart';
import 'Components/image_selection_btn.dart';

class SignUpView extends StatefulWidget {
  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController customerAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  LocalDatabaseHepler db = LocalDatabaseHepler();

  bool nameValid = false;
  bool emailValid = false;
  bool mobileNumberValid = false;
  bool customerAddressValid = false;
  bool passwordValid = false;
  bool confirmPasswordValid = false;
  bool imageValid = false;

  AuthViewModel authViewModel = Get.put(AuthViewModel());

  bool typeValid = false;

  String selectedType = '';
  List type = [
    "Customer",
    "Business",
  ];

  File? encodedImage;
  final ImagePicker picker = ImagePicker();

  Future<void> openCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    getTargetPath().then((file) {
      testCompressAndGetFile(File(photo!.path), file.path).then((value) {
        setState(() {
          encodedImage = value;
        });
      });
    });
    if (photo != null) {
      // storeUserImage();
    } else {
      print('No Image Path Received');
    }
  }

  Future<void> openGallery() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    getTargetPath().then((file) {
      testCompressAndGetFile(File(photo!.path), file.path).then((value) {
        setState(() {
          encodedImage = value;
        });
      });
    });

    if (photo != null) {
      // storeUserImage();
    } else {
      print('No Image Path Received');
    }
  }

  Future<File> getTargetPath() async {
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    final uniqueIdentifier = DateTime
        .now()
        .microsecondsSinceEpoch;
    final file = await new File('$path/$uniqueIdentifier.jpg').create();
    // file.writeAsBytesSync(capturedImage);
    return file;
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: 400,
      minHeight: 400,
      quality: 50,
    );

    return result!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
          Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                    sigmaX: authViewModel.loading.value ? 5 : 0,
                    sigmaY: authViewModel.loading.value ? 5 : 0),
                child: Container(
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
                                text: "Sign up",
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
                        AddVerticalSpace(10),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                              ),
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.white,
                                ),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.mainColor,
                                  ),
                                  child: ClipOval(
                                    child: encodedImage != null
                                        ? Image.file(
                                      encodedImage!,
                                      fit: BoxFit.cover,
                                    )
                                        : Center(
                                      child: Icon(
                                        Icons.person,
                                        color: imageValid
                                            ? AppColors.red
                                            : AppColors.white,
                                        size: 35,
                                      ),
                                    ),
                                    // child: OptimizedCacheImage(
                                    //   imageUrl: encodedImage?.path??"",
                                    //   progressIndicatorBuilder:
                                    //       (context, url, downloadProgress) => Center(
                                    //     child: CircularProgressIndicator(
                                    //       value: downloadProgress.progress,
                                    //       color: AppColors.white,
                                    //     ),
                                    //   ),
                                    //   errorWidget: (context, url, error) => Icon(
                                    //     Icons.person,
                                    //     color: AppColors.white,
                                    //     size: 40,
                                    //   ),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    backgroundColor: AppColors.transparent,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 130,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            ImageSelectionBTN(
                                              width: Dimensions.screenWidth(
                                                  context),
                                              title: "Camera",
                                              color: AppColors.white,
                                              margin: 5,
                                              onPressed: () async {
                                                var status = await Permission
                                                    .camera.status;

                                                if (status.isGranted) {
                                                  openCamera();
                                                  Navigator.pop(context);
                                                } else {
                                                  await Permission.camera
                                                      .request();
                                                }
                                              },
                                            ),
                                            ImageSelectionBTN(
                                              width: Dimensions.screenWidth(
                                                  context),
                                              title: "Gallery",
                                              color: AppColors.white,
                                              margin: 5,
                                              onPressed: () async {
                                                var status = await Permission
                                                    .storage.status;

                                                if (status.isGranted) {
                                                  openGallery();
                                                  Navigator.pop(context);
                                                } else {
                                                  await Permission.storage
                                                      .request();
                                                }
                                              },
                                            ),
                                            AddVerticalSpace(5),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    // borderRadius: BorderRadius.circular(100),
                                    shape: BoxShape.circle,
                                    // image: DecorationImage(image: AssetImage("assets/Icons/done.png"))
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: AppColors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              AddVerticalSpace(20),
                              TextView(
                                text: "Let's Get Started",
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                fontSize: 18,
                              ),
                              AddVerticalSpace(20),
                              TextView(
                                text: "Personal Details",
                                color: AppColors.white,
                              ),
                              AddVerticalSpace(20),
                              TextEditField(
                                hintText: "Your Full Name",
                                hintSize: 14,
                                inputType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                textEditingController: name,
                                width: Dimensions.screenWidth(context),
                                errorText:
                                nameValid ? "Name is Required" : null,
                                preffixIcon:
                                Icon(Icons.person_outline_outlined),
                                cursorColor: AppColors.mainColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z \s+]')),
                                ],
                              ),
                              AddVerticalSpace(16),
                              TextEditField(
                                hintText: "Your Email",
                                hintSize: 14,
                                inputType: TextInputType.emailAddress,
                                textEditingController: email,
                                width: Dimensions.screenWidth(context),
                                preffixIcon: Icon(Icons.email_outlined),
                                cursorColor: AppColors.mainColor,
                                onChanged: (value){
                                  setState(() {
                                    emailValid= !EmailValidator.validate(value);

                                  });

                                },
                                errorText:
                                emailValid ? "Enter valid Email" : null,
                              ),
                              AddVerticalSpace(16),
                              TextEditField(
                                hintText: "Your Mobile Number",
                                hintSize: 14,
                                maxLength: 11,
                                inputType: TextInputType.phone,
                                textEditingController: mobileNumber,
                                width: Dimensions.screenWidth(context),
                                preffixIcon: Icon(Icons.phone_android),
                                cursorColor: AppColors.mainColor,
                                errorText: mobileNumberValid
                                    ? "Mobile Number is Required"
                                    : null,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                ],
                              ),
                              AddVerticalSpace(16),
                              TextEditField(
                                hintText: "Your Address",
                                hintSize: 14,
                                inputType: TextInputType.streetAddress,
                                textEditingController: customerAddress,
                                width: Dimensions.screenWidth(context),
                                preffixIcon: Icon(Icons.location_on_outlined),
                                cursorColor: AppColors.mainColor,
                                errorText: customerAddressValid
                                    ? "Business Address is Required"
                                    : null,
                              ),
                              AddVerticalSpace(16),
                              Container(
                                height: 53,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonFormField2(
                                  buttonPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),

                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  isExpanded: true,
                                  hint: Row(
                                    children: [
                                      Icon(
                                        Icons.online_prediction_outlined,
                                        color: AppColors.black,
                                      ),
                                      AddHorizontalSpace(10),
                                      TextView(
                                        text: 'Account Type',
                                        fontSize: 14,
                                        color: typeValid
                                            ? AppColors.red
                                            : AppColors.black,
                                      ),
                                    ],
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.black,
                                  ),
                                  iconSize: 30,
                                  buttonHeight: 55,
                                  // buttonPadding:
                                  // const EdgeInsets.only(left: 20, right: 10),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  items: type
                                      .map((item) =>
                                      DropdownMenuItem<String>(
                                        value: item,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .online_prediction_outlined,
                                              color: AppColors.black,
                                            ),
                                            AddHorizontalSpace(10),
                                            TextView(
                                              text: item,
                                              fontSize: 14,
                                              color: AppColors.black,
                                            ),
                                          ],
                                        ),
                                      ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select Days.';
                                    }
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      selectedType = value!;
                                    });
                                    //Do something when changing the item if you want.
                                  },
                                ),
                              ),
                              AddVerticalSpace(16),
                              TextEditField(
                                hintText: "Your Password",
                                hintSize: 14,
                                textEditingController: password,
                                width: Dimensions.screenWidth(context),
                                preffixIcon: Icon(Icons.lock_outline),
                                cursorColor: AppColors.mainColor,
                                isPassword: true,
                                errorText: passwordValid
                                    ? "Password is Required"
                                    : null,
                              ),
                              AddVerticalSpace(16),
                              TextEditField(
                                hintText: "Confirm Password",
                                hintSize: 14,
                                textEditingController: confirmPassword,
                                width: Dimensions.screenWidth(context),
                                preffixIcon: Icon(Icons.lock_outline),
                                cursorColor: AppColors.mainColor,
                                isPassword: true,
                                errorText: confirmPasswordValid
                                    ? "Password Must be Same"
                                    : null,
                              ),
                              AddVerticalSpace(30),
                              BTN(
                                title: selectedType == "Customer"
                                    ? "Done"
                                    : "Next",
                                color: AppColors.mainColor,
                                textColor: AppColors.white,
                                width: Dimensions.screenWidth(context) - 100,
                                onPressed: () async {
                                  setState(() {
                                    if (encodedImage == null) {
                                      FlutterErrorToast(error: "Select Image");
                                      imageValid = true;
                                    } else if (name.text.isEmpty) {
                                      nameValid = true;
                                    } else if (email.text.isEmpty) {
                                      emailValid = true;
                                    }

                                    else if (mobileNumber.text.isEmpty) {
                                      mobileNumberValid = true;
                                    } else if (selectedType.isEmpty) {
                                      typeValid = true;
                                    } else if (customerAddress.text.isEmpty) {
                                      customerAddressValid = true;
                                    } else if (password.text.isEmpty) {
                                      passwordValid = true;
                                    } else if (confirmPassword.text.isEmpty) {
                                      confirmPasswordValid = true;
                                    }
                                  });
                                  if (name.text.isNotEmpty &&
                                      email.text.isNotEmpty &&
                                      mobileNumber.text.isNotEmpty &&
                                      selectedType.isNotEmpty &&
                                      customerAddress.text.isNotEmpty &&
                                      password.text.isNotEmpty &&
                                      confirmPassword.text.isNotEmpty &&
                                      encodedImage != null) {
                                    if (password.text.length < 6) {
                                      FlutterErrorToast(
                                          error: "Password is Weak");
                                    } else if (password.text !=
                                        confirmPassword.text) {
                                      setState(() {
                                        confirmPasswordValid = true;
                                      });
                                    } else {
                                      getCurrentLocation().then((value) async {
                                        authViewModel.loading.value = true;
                                        db.deleteTable(tableName: "tbl_login");
                                        db.deleteTable(tableName: "tbl_cart");

                                        signUp(
                                          name: name.text,
                                          email: email.text,
                                          number: mobileNumber.text,
                                          address: customerAddress.text,
                                          password: password.text,
                                          lat: value!.latitude.toString(),
                                          long: value.longitude.toString(),
                                          imagePath: encodedImage!.path.trim(),
                                          type: selectedType,
                                        ).then((value) async {
                                          //faysalneowaz@gmail.com
                                          if (value == 200) {
                                            await authViewModel.getUserEmail(
                                                email: email.text,
                                                selectedType: selectedType);
                                            authViewModel.loading.value = false;
                                          } else {
                                            authViewModel.loading.value = false;

                                            FlutterErrorToast(
                                                error:
                                                "Email already exits!");
                                          }
                                        });
                                      });
                                    }
                                  }
                                },
                              ),
                              AddVerticalSpace(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextView(
                                    text: "Already have an account? ",
                                    color: AppColors.white,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: TextView(
                                      text: "Sign in",
                                      color: AppColors.mainColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              AddVerticalSpace(20),
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
