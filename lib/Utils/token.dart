import 'package:get_storage/get_storage.dart';

class Token {
  static final String apiHeader = GetStorage().read("apiHeader");
  static final String ImageDir = GetStorage().read("ImageDir");
  static final String curency = "Rs.";
}
