import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Utils/token.dart';

Future getBannersFromApis() async {
  var responce = await http.get(Uri.parse("${Token.apiHeader}getBanner"));
  return jsonDecode(responce.body);
}
