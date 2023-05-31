import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Utils/token.dart';

Future getCategoriesFromApis() async {
  var responce = await http.get(Uri.parse("${Token.apiHeader}getcategory"));
  return jsonDecode(responce.body);
}
