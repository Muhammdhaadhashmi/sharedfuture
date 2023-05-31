import 'dart:io';
import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
import 'package:http/http.dart' as http;
import 'package:shared_future/ApplicationModules/CategoryModule/Models/category_model.dart';
import '../../../LocalDatabaseHelper/local_database_handler.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/btn.dart';
import '../../../Utils/dimensions.dart';
import '../../../Utils/location_service.dart';
import '../../../Utils/spaces.dart';
import '../../../Utils/text_edit_field.dart';
import '../../../Utils/text_view.dart';
import '../../../Utils/toast.dart';
import '../../../Utils/token.dart';
import '../../AuthenticationModule/ViewModels/auth_view_model.dart';
import '../../AuthenticationModule/Views/Components/image_selection_btn.dart';
import '../../CategoryModule/ViewModels/category_view_model.dart';
import '../../HomeModule/Views/app_route_view.dart';
import '../../VerificationModule/Views/verification_view.dart';

class AddBusinessView extends StatefulWidget {
  final String email;
  const AddBusinessView({Key? key, required this.email}) : super(key: key);

  @override
  State<AddBusinessView> createState() => _AddBusinessViewState();
}

class _AddBusinessViewState extends State<AddBusinessView> {
  TextEditingController name = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController shippingCharges = TextEditingController();
  TextEditingController customerAddress = TextEditingController();
  TextEditingController des = TextEditingController();
  LocalDatabaseHepler db = LocalDatabaseHepler();

  bool nameValid = false;
  bool mobileNumberValid = false;
  bool shippingChargesValid = false;
  bool customerAddressValid = false;
  bool categoryValid = false;

  var encodedImage;
  final ImagePicker picker = ImagePicker();

  CategoryViewModel categoryViewModel = Get.put(CategoryViewModel());
  AuthViewModel authViewModel = Get.put(AuthViewModel());

  bool loading = false;
  String imageURL = "";

  int selectedCategoryID = 0;
  bool imageValid = false;

  @override
  void initState() {
    super.initState();
    categoryViewModel.getBussinessCategories();
  }

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
    // setState(() {
    //   encodedImage = File(photo!.path);
    // });

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
      body: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(
                sigmaX: loading ? 5 : 0, sigmaY: loading ? 5 : 0),
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 16),
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
                    Stack(
                      children: [
                        Container(
                          height: 280,
                          margin: EdgeInsets.only(bottom: 20),
                          width: Dimensions.screenWidth(context),
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: encodedImage != null
                                ? Image.file(
                                    encodedImage!,
                                    fit: BoxFit.cover,
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.business,
                                      color: imageValid
                                          ? AppColors.red
                                          : AppColors.mainColor,
                                      size: 55,
                                    ),
                                  ),
                          ),
                        ),
                        // Positioned(
                        //   top: 50,
                        //   left: 20,
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: AppColors.white,
                        //     ),
                        //     child: InkWell(
                        //       borderRadius: BorderRadius.circular(100),
                        //       onTap: () {
                        //         Get.back();
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Icon(
                        //           Icons.chevron_left,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Positioned(
                          bottom: 2,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                backgroundColor: AppColors.transparent,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 130,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ImageSelectionBTN(
                                          width:
                                              Dimensions.screenWidth(context),
                                          title: "Camera",
                                          color: AppColors.white,
                                          margin: 5,
                                          onPressed: () async {
                                            var status =
                                                await Permission.camera.status;
                                            if (status.isGranted) {
                                              openCamera();
                                              Navigator.pop(context);
                                            } else {
                                              await Permission.camera.request();
                                            }
                                          },
                                        ),
                                        ImageSelectionBTN(
                                          width:
                                              Dimensions.screenWidth(context),
                                          title: "Gallery",
                                          color: AppColors.white,
                                          margin: 5,
                                          onPressed: () async {
                                            var status =
                                                await Permission.storage.status;

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
                              height: 45,
                              width: 45,
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
                          // AddVerticalSpace(20),
                          TextView(
                            text: "Final Step to Go",
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                          AddVerticalSpace(20),
                          TextView(
                            text: "Business Details",
                            color: AppColors.white,
                          ),
                          AddVerticalSpace(20),
                          TextEditField(
                            hintText: "Your Business Name",
                            hintSize: 14,
                            inputType: TextInputType.name,
                            textEditingController: name,
                            width: Dimensions.screenWidth(context),
                            errorText: nameValid ? "Name is Required" : null,
                            preffixIcon: Icon(Icons.person_outline_outlined),
                            cursorColor: AppColors.mainColor,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                            ],
                          ),
                          AddVerticalSpace(16),
                          TextEditField(
                            hintText: "Your Business Number",
                            hintSize: 14,
                            inputType: TextInputType.phone,
                            textEditingController: mobileNumber,
                            width: Dimensions.screenWidth(context),
                            preffixIcon: Icon(Icons.phone_outlined),
                            cursorColor: AppColors.mainColor,
                            errorText: mobileNumberValid
                                ? "Mobile Number is Required"
                                : null,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            ],
                          ),
                          AddVerticalSpace(16),
                          Obx(() => Container(
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
                                        Icons.category_outlined,
                                        color: AppColors.black,
                                      ),
                                      AddHorizontalSpace(10),
                                      TextView(
                                        text: 'Business Category',
                                        fontSize: 14,
                                        color: categoryValid
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
                                  items: categoryViewModel
                                      .bussinessCategoryList.value
                                      .map((item) => DropdownMenuItem<int>(
                                            value: item.categoryId,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.category_outlined,
                                                  color: AppColors.black,
                                                ),
                                                AddHorizontalSpace(10),
                                                TextView(
                                                  text: item.categoryName,
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
                                      selectedCategoryID = value!;
                                      print(value);
                                    });
                                    //Do something when changing the item if you want.
                                  },
                                ),
                              )),
                          AddVerticalSpace(16),

                          TextEditField(
                            hintText: "Your Business Address",
                            hintSize: 14,
                            textEditingController: customerAddress,
                            width: Dimensions.screenWidth(context),
                            preffixIcon: Icon(Icons.location_on_outlined),
                            cursorColor: AppColors.mainColor,
                            errorText: customerAddressValid
                                ? "Business Address is Required"
                                : null,
                          ),
                          AddVerticalSpace(16),
                          TextEditField(
                            hintText: "Shipping Charges",
                            hintSize: 14,
                            inputType: TextInputType.phone,
                            textEditingController: shippingCharges,
                            width: Dimensions.screenWidth(context),
                            preffixIcon: Icon(Icons.money),
                            cursorColor: AppColors.mainColor,
                            errorText: shippingChargesValid
                                ? "Shipping Charges is Required"
                                : null,
                          ),
                          AddVerticalSpace(16),
                          TextEditField(
                            hintText: "Your Business Description",
                            hintSize: 14,
                            textEditingController: des,
                            width: Dimensions.screenWidth(context),
                            preffixIcon: Icon(Icons.description_outlined),
                            cursorColor: AppColors.mainColor,
                          ),
                          AddVerticalSpace(30),
                          BTN(
                            title: "Done",
                            onPressed: () {
                              setState(() {
                                if (encodedImage == null) {
                                  FlutterErrorToast(error: "Select Image");
                                  imageValid = true;
                                } else if (name.text.isEmpty) {
                                  nameValid = true;
                                } else if (mobileNumber.text.isEmpty) {
                                  mobileNumberValid = true;
                                } else if (selectedCategoryID == 0) {
                                  categoryValid = true;
                                } else if (customerAddress.text.isEmpty) {
                                  customerAddressValid = true;
                                } else if (shippingCharges.text.isEmpty) {
                                  shippingChargesValid = true;
                                }
                              });
                              if (name.text.isNotEmpty &&
                                  mobileNumber.text.isNotEmpty &&
                                  selectedCategoryID != 0 &&
                                  customerAddress.text.isNotEmpty &&
                                  shippingCharges.text.isNotEmpty &&
                                  encodedImage != null) {
                                getCurrentLocation().then((value) async {
                                  setState(() {
                                    loading = true;
                                  });
                                  var request = http.MultipartRequest(
                                    "POST",
                                    Uri.parse("${Token.apiHeader}addBusiness"),
                                  );
                                  request.headers['accept'] = '*/*';
                                  request.headers["Content-Type"] =
                                      'multipart/form-data';
                                  // request.headers["Authorization"] ='bearer ${token}';
                                  var pic = await http.MultipartFile.fromPath(
                                      "business_image",
                                      encodedImage!.path.trim());
                                  request.files.add(pic);
                                  print(pic.filename);

                                  request.fields["user_id"] =
                                      "${authViewModel.currentUserList.value[0].customerId}";
                                  request.fields["business_name"] = name.text;
                                  request.fields["business_number"] =
                                      mobileNumber.text;
                                  request.fields["business_category"] =
                                      selectedCategoryID.toString();
                                  request.fields["business_status"] = "Active";
                                  request.fields["business_address"] =
                                      customerAddress.text;
                                  request.fields["shipping_charges"] =
                                      shippingCharges.text;
                                  request.fields["business_description"] =
                                      customerAddress.text;
                                  request.fields["business_location_lat"] =
                                      value!.latitude.toString();
                                  request.fields["business_location_lng"] =
                                      value.longitude.toString();
                                  var response = await request.send();
                                  var result =
                                      await http.Response.fromStream(response);
                                  print(result.statusCode);
                                  print(result.body);
                                  if (result.statusCode == 200) {
                                    db
                                        .checkUserVarified(
                                      email: widget.email,
                                    )
                                        .then((res) async {
                                      if (res != "0") {
                                        await db.insertUserForLogin(
                                            email: widget.email);
                                        Get.offAll(
                                          AppRouteView(),
                                          transition: Transition.rightToLeft,
                                          duration: Duration(milliseconds: 600),
                                        );
                                      } else {
                                        Get.offAll(
                                          VerificationView(
                                              email: widget.email, forget: false),
                                          transition: Transition.rightToLeft,
                                          duration: Duration(milliseconds: 600),
                                        );
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    FlutterErrorToast(
                                        error: "Something went wrong");
                                  }
                                });
                              }
                              // Get.to(
                              //   AppRouteView(),
                              //   transition: Transition.rightToLeft,
                              //   duration: Duration(milliseconds: 600),
                              // );
                            },
                            color: AppColors.mainColor,
                            textColor: AppColors.white,
                            width: Dimensions.screenWidth(context) - 100,
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
          loading
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
      ),
    );
  }
}
