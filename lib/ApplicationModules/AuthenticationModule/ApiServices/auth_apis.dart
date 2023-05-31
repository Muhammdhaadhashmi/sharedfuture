import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Utils/token.dart';

Future signUp({
  required String name,
  required String email,
  required String number,
  required String address,
  required String password,
  required String lat,
  required String long,
  required String imagePath,
  required String type,
}) async {
  var request = http.MultipartRequest(
    "POST",
    Uri.parse("${Token.apiHeader}addCustomer"),
  );
  request.headers['accept'] = '*/*';
  request.headers["Content-Type"] = 'multipart/form-data';
  // request.headers["Authorization"] ='bearer ${token}';
  var pic = await http.MultipartFile.fromPath("customer_image", imagePath);
  request.files.add(pic);
  print(pic.filename);
  request.fields["customer_name"] = name;
  request.fields["customer_phone"] = number;
  request.fields["customer_email"] = email;
  request.fields["customer_password"] = password;
  request.fields["customer_address"] = address;
  request.fields["customer_status"] = "active";
  request.fields["customer_location_lat"] = lat;
  request.fields["customer_location_lng"] = long;
  request.fields["customer_type"] = type;
  var responce = await request.send();
  var result = await http.Response.fromStream(responce);
  print(result.statusCode);
  print(result.body);
  return result.statusCode;
}


