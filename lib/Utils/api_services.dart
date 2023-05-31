import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Utils/token.dart';

Future getOrdersFromAPIS({required int id}) async {
  // var responce = await http.get(Uri.parse("${Token.apiHeader}showCustomerOrder/5"));
  var responce = await http.get(Uri.parse("${Token.apiHeader}showCustomerOrder/${id}"));
  print(responce.statusCode);
  print(responce.body);
  return jsonDecode(responce.body);
}

Future getOrdersDetailsFromAPIS({required int id}) async {
  var responce =
      await http.get(Uri.parse("${Token.apiHeader}getDetailOrder/${id}"));
  return jsonDecode(responce.body);
}

getUserFromApis() async {
  var responce = await http.get(Uri.parse("${Token.apiHeader}getCustomer"));
  return jsonDecode(responce.body);
}
