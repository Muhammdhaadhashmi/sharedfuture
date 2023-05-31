import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_future/ApplicationModules/AuthenticationModule/ViewModels/auth_view_model.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Views/add_business_view.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/Models/user_model.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/ViewModels/profile_view_model.dart';
import 'package:shared_future/LocalDatabaseHelper/local_database_handler.dart';
import 'package:shared_future/Utils/location_service.dart';
import 'package:shared_future/Utils/toast.dart';
import 'package:shared_future/Utils/token.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/btn.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_edit_field.dart';
import '../../../Utils/text_view.dart';
import '../../AuthenticationModule/Views/Components/image_selection_btn.dart';
import '../../HomeModule/Views/app_route_view.dart';

class EditProfileView extends StatefulWidget {
  final UserModel userModel;

  const EditProfileView({super.key, required this.userModel});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController customerAddress = TextEditingController();
  TextEditingController password = TextEditingController();

  bool nameValid = false;
  bool emailValid = false;
  bool mobileNumberValid = false;
  bool customerAddressValid = false;
  bool passwordValid = false;

  ProfileViewModel profileViewModel = Get.put(ProfileViewModel());
  LocalDatabaseHepler db = LocalDatabaseHepler();

  bool typeValid = false;

  String selectedType = '';
  List type = [
    "Customer",
    "Business",
  ];

  File? encodedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    name.text = widget.userModel.customerName;
    email.text = widget.userModel.customerEmail;
    mobileNumber.text = widget.userModel.customerPhone;
    customerAddress.text = widget.userModel.customerAddress;
    password.text = widget.userModel.customerPassword;
  }

  Future<void> openCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    getTargetPath().then((file) {
      testCompressAndGetFile(File(photo!.path), file.path).then((value) {
        setState(() {
          encodedImage =value;
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
          encodedImage =value;
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
    final uniqueIdentifier = DateTime.now().microsecondsSinceEpoch;
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
      body: Obx(() => Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                    sigmaX: profileViewModel.loading.value ? 5 : 0,
                    sigmaY: profileViewModel.loading.value ? 5 : 0),
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 16),
                  height: Dimensions.screenHeight(context),
                  width: Dimensions.screenWidth(context),
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
                              Icon(Icons.chevron_left),
                              AddHorizontalSpace(5),
                              TextView(
                                text: "Edit Profile",
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
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: OptimizedCacheImage(
                                              height: 120,
                                              width: 140,
                                              imageUrl:
                                                  "${Token.ImageDir}${widget.userModel.customerImage}",
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value:
                                                      downloadProgress.progress,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.error,
                                                color: AppColors.white,
                                              ),
                                              fit: BoxFit.cover,
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
                                text: "Edit your profile",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              AddVerticalSpace(20),
                              TextView(
                                text: "Personal Details",
                                color: AppColors.grey,
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
                                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
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
                                inputType: TextInputType.phone,
                                textEditingController: mobileNumber,
                                width: Dimensions.screenWidth(context),
                                preffixIcon: Icon(Icons.phone_android),
                                cursorColor: AppColors.mainColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                ],
                                errorText: mobileNumberValid
                                    ? "Mobile Number is Required"
                                    : null,
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
                              // Container(
                              //   height: 70,
                              //   child: DropdownButtonFormField2(
                              //     buttonPadding: EdgeInsets.symmetric(
                              //       horizontal: 10,
                              //     ),
                              //
                              //     decoration: InputDecoration(
                              //       isDense: true,
                              //       contentPadding: EdgeInsets.zero,
                              //       border: OutlineInputBorder(
                              //           borderSide:
                              //               BorderSide(color: AppColors.grey2)),
                              //       focusedBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: AppColors.mainColor)),
                              //     ),
                              //     isExpanded: true,
                              //     hint: Row(
                              //       children: [
                              //         Icon(
                              //           Icons.online_prediction_outlined,
                              //           color: AppColors.grey,
                              //         ),
                              //         AddHorizontalSpace(10),
                              //         TextView(
                              //           text: 'Account Type',
                              //           fontSize: 14,
                              //           color: typeValid
                              //               ? AppColors.red
                              //               : AppColors.grey,
                              //         ),
                              //       ],
                              //     ),
                              //     icon: Icon(
                              //       Icons.arrow_drop_down,
                              //       color: AppColors.grey,
                              //     ),
                              //     iconSize: 30,
                              //     buttonHeight: 55,
                              //     // buttonPadding:
                              //     // const EdgeInsets.only(left: 20, right: 10),
                              //     dropdownDecoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(15),
                              //     ),
                              //     items: type
                              //         .map((item) => DropdownMenuItem<String>(
                              //               value: item,
                              //               child: Row(
                              //                 children: [
                              //                   Icon(
                              //                     Icons
                              //                         .online_prediction_outlined,
                              //                     color: AppColors.grey,
                              //                   ),
                              //                   AddHorizontalSpace(10),
                              //                   TextView(
                              //                     text: item,
                              //                     fontSize: 14,
                              //                     color: AppColors.grey,
                              //                   ),
                              //                 ],
                              //               ),
                              //             ))
                              //         .toList(),
                              //     validator: (value) {
                              //       if (value == null) {
                              //         return 'Please select Days.';
                              //       }
                              //     },
                              //     onChanged: (value) {
                              //       setState(() {
                              //         selectedType = value!;
                              //       });
                              //       //Do something when changing the item if you want.
                              //     },
                              //   ),
                              // ),
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
                              AddVerticalSpace(30),
                              BTN(
                                title: "Update",
                                color: AppColors.mainColor,
                                textColor: AppColors.white,
                                width: Dimensions.screenWidth(context) - 100,
                                onPressed: () async {
                                  setState(() {
                                    if (name.text.isEmpty) {
                                      nameValid = true;
                                    } else if (email.text.isEmpty) {
                                      emailValid = true;
                                    } else if (mobileNumber.text.isEmpty) {
                                      mobileNumberValid = true;
                                    } else if (customerAddress.text.isEmpty) {
                                      customerAddressValid = true;
                                    } else if (password.text.isEmpty) {
                                      passwordValid = true;
                                    }
                                  });
                                  if (name.text.isNotEmpty &&
                                      email.text.isNotEmpty &&
                                      mobileNumber.text.isNotEmpty &&
                                      customerAddress.text.isNotEmpty &&
                                      password.text.isNotEmpty) {
                                    profileViewModel.loading.value = true;


                                    var request = http.MultipartRequest(
                                      "POST",
                                      Uri.parse(
                                          "${Token.apiHeader}updateCustomer/${widget.userModel.customerId}"),
                                    );
                                    request.headers['accept'] = '*/*';
                                    request.headers["Content-Type"] =
                                        'multipart/form-data';
                                    // request.headers["Authorization"] ='bearer ${token}';
                                    if (encodedImage != null) {
                                      var pic =
                                          await http.MultipartFile.fromPath(
                                              "customer_image",
                                              encodedImage!.path.trim());
                                      request.files.add(pic);
                                      print(pic.filename);
                                    }
                                    request.fields["customer_name"] = name.text;
                                    request.fields["customer_phone"] =
                                        mobileNumber.text;
                                    request.fields["customer_email"] =
                                        email.text;
                                    request.fields["customer_password"] =
                                        password.text;
                                    request.fields["customer_address"] =
                                        customerAddress.text;
                                    request.fields["customer_status"] =
                                        "active";
                                    request.fields["customer_type"] =
                                        widget.userModel.customer_type;
                                    var responce = await request.send();
                                    var result = await http.Response.fromStream(
                                        responce);
                                    print(result.statusCode);
                                    print(result.body);



                                    if (result.statusCode == 200) {

                                      profileViewModel.getImageFromApis(id: widget.userModel.customerId!);

                                    } else {
                                        profileViewModel.loading.value = false;
                                      FlutterErrorToast(
                                          error: "Something went wrong");
                                    }
                                  }
                                },
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
              profileViewModel.loading.value
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
