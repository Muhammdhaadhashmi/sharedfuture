import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Utils/token.dart';

Future getProductsFromApis() async {
  var responce = await http.get(Uri.parse("${Token.apiHeader}getproducts"));
  print(responce.body);
  return jsonDecode(responce.body);
}
