import 'package:latlng/latlng.dart';
import 'package:location/location.dart';

Location location = Location();
bool serviceEnabled = false;
PermissionStatus? permissionGranted;
LocationData? locationData;
Future<LatLng?> getCurrentLocation() async {
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
    }
  }
  locationData = await location.getLocation();

  if (locationData != null) {
    return LatLng(locationData!.latitude!, locationData!.longitude!);
  } else {
    print("wait");
  }
}