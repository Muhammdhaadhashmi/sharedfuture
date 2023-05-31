import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Utils/token.dart';

Future getBusinessFromApis() async {
  var responce = await http.get(Uri.parse("${Token.apiHeader}getBusiness"));
  return jsonDecode(responce.body);
}
