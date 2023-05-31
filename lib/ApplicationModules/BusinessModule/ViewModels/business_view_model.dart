import 'dart:math';

import 'package:get/get.dart';
import 'package:shared_future/ApplicationModules/BusinessModule/Models/business_model.dart';
import 'package:shared_future/Utils/location_service.dart';

import '../ApisServices/business_apis.dart';

class BusinessViewModel extends GetxController {
  RxList<BusinessModel> businessList = <BusinessModel>[].obs;
  RxList<BusinessModel> nearByBusinessList = <BusinessModel>[].obs;
  RxList<BusinessModel> currentBusinessList = <BusinessModel>[].obs;
  RxInt businessId = 0.obs;
  RxInt shipping = 0.obs;
  RxInt businessCategory = 0.obs;
  RxInt user_id = 0.obs;
  RxDouble businessLocationLat = 0.0.obs;
  RxDouble businessLocationLng = 0.0.obs;
  RxString businessName = "".obs;
  RxString businessNumber = "".obs;
  RxString businessAddress = "".obs;
  RxString businessDescription = "".obs;
  RxString businessImage = "".obs;
  RxString businessStatus = "".obs;

  // final random = new Random();

  getBusiness() async {
    businessList.value.clear();
    getBusinessFromApis().then((value) {
      businessList.value = BusinessModel.jsonToListView(value)
          .where(
            (element) => currentBusinessList.value.length != 0
                ? element.businessId != currentBusinessList.value[0].businessId
                : true,
          )
          .toList()
        ..shuffle();
    });
  }

  getNearByBusiness() async {
    nearByBusinessList.value.clear();
    getBusinessFromApis().then((value) {
      getCurrentLocation().then((myLoc) {
        nearByBusinessList.value = BusinessModel.jsonToListView(value)
            .where((element) => currentBusinessList.value.length != 0
                ? element.businessId != currentBusinessList.value[0].businessId
                : true &&
                    (latlangfinder(
                            element.businessLocationLat,
                            element.businessLocationLng,
                            myLoc!.latitude,
                            myLoc.longitude)! <=
                        10.00))
            .toList();
      });
    });
  }

  getCurrentBusiness({required int userId}) async {
    currentBusinessList.value.clear();
    getBusinessFromApis().then((value) {
      currentBusinessList.value = BusinessModel.jsonToListView(value)
          .where((element) =>
              // currentBusinessList.value.length != 0 ? element.businessId != currentBusinessList.value[0].businessId : true &&
              element.user_id == userId)
          .toList();
      businessId.value = currentBusinessList.value[0].businessId!;
      shipping.value = currentBusinessList.value[0].shippingCharges;
      businessCategory.value = currentBusinessList.value[0].businessCategory;
      user_id.value = currentBusinessList.value[0].user_id;
      businessLocationLat.value =
          currentBusinessList.value[0].businessLocationLat;
      businessLocationLng.value =
          currentBusinessList.value[0].businessLocationLng;
      businessName.value = currentBusinessList.value[0].businessName;
      businessNumber.value = currentBusinessList.value[0].businessNumber;
      businessAddress.value = currentBusinessList.value[0].businessAddress;
      businessDescription.value =
          currentBusinessList.value[0].businessDescription;
      businessImage.value = currentBusinessList.value[0].businessImage;
      businessStatus.value = currentBusinessList.value[0].businessStatus;
    });
  }

  double? latlangfinder(firtlat, firstlang, curntulat, curntulang) {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    double totalDistance = 0;

    totalDistance += calculateDistance(
      firtlat,
      firstlang,
      curntulat,
      curntulang,
    );
    return totalDistance;
  }
}
