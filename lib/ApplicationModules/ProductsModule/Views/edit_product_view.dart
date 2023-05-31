import 'dart:io';

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
import 'package:shared_future/ApplicationModules/ProductsModule/Models/product_model.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../Utils/btn.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/spaces.dart';
import '../../../../Utils/text_edit_field.dart';
import '../../../../Utils/text_view.dart';
import '../../../Utils/toast.dart';
import '../../../Utils/token.dart';
import '../../AuthenticationModule/Views/Components/image_selection_btn.dart';
import '../../CategoryModule/ViewModels/category_view_model.dart';

class EditProductView extends StatefulWidget {
  final int BusinessID;
  final ProductModel productModel;

  const EditProductView({
    super.key,
    required this.BusinessID,
    required this.productModel,
  });

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  TextEditingController name = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController costPrice = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController discountPrice = TextEditingController();
  TextEditingController des = TextEditingController();
  CategoryViewModel categoryViewModel = Get.put(CategoryViewModel());
  TextEditingController property = TextEditingController();
  TextEditingController unit = TextEditingController();

  bool nameValid = false;
  bool quantityValid = false;
  bool costPriceValid = false;
  bool salePriceValid = false;
  bool categoryValid = false;
  bool statusValid = false;
  bool propertyValid = false;
  bool unitValid = false;

  var encodedImage;
  final ImagePicker picker = ImagePicker();

  bool loading = false;
  String imageURL = "";
  int selectedCategoryID = 0;

  @override
  void initState() {
    super.initState();
    categoryViewModel.getProductCategories();
    name.text = widget.productModel.proName;
    quantity.text = widget.productModel.totalQty.toString();
    costPrice.text = widget.productModel.costPrice.toString();
    salePrice.text = widget.productModel.salePrice.toString();
    discountPrice.text = widget.productModel.discountPrice.toString();
    des.text = widget.productModel.proDis;
    property.text = widget.productModel.property;
    unit.text = widget.productModel.unit;
    selectedCategoryID = widget.productModel.proCat;
    selectedStatus = widget.productModel.proStatus;
  }

  String selectedStatus = '';
  List businessStatus = [
    "Actice",
    "Inactive",
  ];

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
      body: Container(
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
              // AddVerticalSpace(50),
              // GestureDetector(
              //   onTap: () {
              //     Get.back();
              //   },
              //   child: Row(
              //     children: [
              //       AddHorizontalSpace(10),
              //       Icon(Icons.chevron_left),
              //       AddHorizontalSpace(5),
              //       TextView(
              //         text: "Add Product",
              //         fontSize: 20,
              //         fontWeight: FontWeight.w700,
              //       ),
              //     ],
              //   ),
              // ),
              // AddVerticalSpace(20),
              // Divider(
              //   height: 1,
              //   color: AppColors.grey,
              //   thickness: 1,
              // ),
              // AddVerticalSpace(20),
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
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: OptimizedCacheImage(
                                height: 120,
                                width: 140,
                                imageUrl:
                                    "${Token.ImageDir}${widget.productModel.proImg}",
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
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.chevron_left,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                                    width: Dimensions.screenWidth(context),
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
                                    width: Dimensions.screenWidth(context),
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
                                        await Permission.storage.request();
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
                      text: "Add Product",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.white,
                    ),
                    AddVerticalSpace(10),
                    TextView(
                      text: "Product Details",
                      color: AppColors.white,
                    ),
                    AddVerticalSpace(20),
                    TextEditField(
                      hintText: "Your Product Name",
                      hintSize: 14,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      ],
                      textEditingController: name,
                      width: Dimensions.screenWidth(context),
                      errorText: nameValid ? "Name is Required" : null,
                      preffixIcon: Icon(Icons.add_business_outlined),
                      cursorColor: AppColors.mainColor,
                    ),
                    AddVerticalSpace(16),
                    TextEditField(
                      hintText: "Your Product Quantity",
                      hintSize: 14,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      textEditingController: quantity,
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.list),
                      cursorColor: AppColors.mainColor,
                      errorText:
                          quantityValid ? "Mobile Number is Required" : null,
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
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.grey2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.mainColor)),
                            ),
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  color: AppColors.grey,
                                ),
                                AddHorizontalSpace(10),
                                TextView(
                                  text: categoryViewModel
                                      .productCategoryList.value
                                      .where((element) =>
                                          element.categoryId ==
                                          widget.productModel.proCat)
                                      .toList()[0]
                                      .categoryName,
                                  fontSize: 14,
                                  color: categoryValid
                                      ? AppColors.red
                                      : AppColors.grey,
                                ),
                              ],
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.grey,
                            ),
                            iconSize: 30,
                            buttonHeight: 55,
                            // buttonPadding:
                            // const EdgeInsets.only(left: 20, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            items: categoryViewModel.productCategoryList.value
                                .map((item) => DropdownMenuItem<int>(
                                      value: item.categoryId,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.category_outlined,
                                            color: AppColors.grey,
                                          ),
                                          AddHorizontalSpace(10),
                                          TextView(
                                            text: item.categoryName,
                                            fontSize: 14,
                                            color: AppColors.grey,
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
                              });
                              //Do something when changing the item if you want.
                            },
                          ),
                        )),
                    AddVerticalSpace(16),

                    TextEditField(
                      hintText: "Product Cost Price",
                      hintSize: 14,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      textEditingController: costPrice,
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.money),
                      cursorColor: AppColors.mainColor,
                      errorText: costPriceValid ? "Price is Required" : null,
                    ),
                    AddVerticalSpace(16),
                    TextEditField(
                      hintText: "Product Sale Price",
                      hintSize: 14,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      textEditingController: salePrice,
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.money),
                      cursorColor: AppColors.mainColor,
                      errorText: salePriceValid ? "Price is Required" : null,
                    ),
                    AddVerticalSpace(16),
                    TextEditField(
                      hintText: "Product Discount Price",
                      hintSize: 14,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      textEditingController: discountPrice,
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.money),
                      cursorColor: AppColors.mainColor,
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
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey2)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.mainColor)),
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
                              text: selectedStatus,
                              fontSize: 14,
                              color: AppColors.black,
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
                        items: businessStatus
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.online_prediction_outlined,
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
                            selectedStatus = value!;
                          });
                          //Do something when changing the item if you want.
                        },
                      ),
                    ),
                    AddVerticalSpace(16),
                    TextEditField(
                      hintText: "Piece Quantity",
                      hintSize: 14,
                      textEditingController: property,
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.production_quantity_limits),
                      cursorColor: AppColors.mainColor,
                      errorText: propertyValid ? "Price is Required" : null,
                    ),
                    AddVerticalSpace(16),
                    TextEditField(
                      hintText: "Unit",
                      hintSize: 14,
                      textEditingController: unit,
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.description_outlined),
                      cursorColor: AppColors.mainColor,
                      errorText: unitValid ? "Price is Required" : null,
                    ),
                    AddVerticalSpace(16),

                    TextEditField(
                      hintText: "Your Product Description",
                      hintSize: 14,
                      textEditingController: des,
                      width: Dimensions.screenWidth(context),
                      preffixIcon: Icon(Icons.description_outlined),
                      cursorColor: AppColors.mainColor,
                    ),

                    AddVerticalSpace(30),
                    BTN(
                      title: "Done",
                      onPressed: () async {
                        setState(() {
                          if (selectedStatus.isEmpty) {
                            statusValid = true;
                          } else if (selectedCategoryID == 0) {
                            categoryValid = true;
                          }
                        });
                        if (selectedStatus.isNotEmpty &&
                            selectedCategoryID != 0) {
                          setState(() {
                            loading = true;
                          });
                          var request = http.MultipartRequest(
                            "POST",
                            Uri.parse(
                                "${Token.apiHeader}updateProduct/${widget.productModel.id}"),
                          );
                          request.headers['accept'] = '*/*';
                          request.headers["Content-Type"] =
                              'multipart/form-data';
                          // request.headers["Authorization"] ='bearer ${token}';
                          if (encodedImage != null) {
                            var pic = await http.MultipartFile.fromPath(
                                "pro_img", encodedImage!.path.trim());
                            request.files.add(pic);
                            print(pic.filename);
                          }
                          request.fields["property"] = property.text;
                          request.fields["unit"] = unit.text;
                          request.fields["pro_name"] = name.text;
                          request.fields["detail"] = "details";
                          request.fields["pro_cat"] = "${selectedCategoryID}";
                          request.fields["pro_dis"] = des.text;
                          request.fields["cost_price"] = costPrice.text;
                          request.fields["sale_price"] = salePrice.text;
                          request.fields["discount_price"] = discountPrice.text;
                          request.fields["total_qty"] = quantity.text;
                          request.fields["sale_qty"] = "0";
                          request.fields["pro_status"] = selectedStatus;
                          request.fields["business_id"] =
                              widget.BusinessID.toString();
                          var response = await request.send();
                          var result = await http.Response.fromStream(response);
                          print(result.statusCode);
                          if (result.statusCode == 200) {
                            // Get.offAll(
                            //   AppRouteView(),
                            //   transition: Transition.rightToLeft,
                            //   duration: Duration(milliseconds: 600),
                            // );
                            Get.back();
                          } else {
                            setState(() {
                              loading = false;
                            });
                            FlutterErrorToast(error: "Something went wrong");
                          }
                        }
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
    );
  }
}
