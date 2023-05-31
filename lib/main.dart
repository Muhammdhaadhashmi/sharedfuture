import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_future/ApplicationModules/HomeModule/Views/app_route_view.dart';
import 'package:shared_future/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => ClassicHeader(),
      headerTriggerDistance: 80.0,
      springDescription:SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
      maxOverScrollExtent :100,
      maxUnderScrollExtent:0,
      enableScrollWhenRefreshCompleted: true,
      enableLoadingWhenFailed : true,
      hideFooterWhenNotFull: false,
      enableBallisticLoad: true,
      child: GetMaterialApp(
        home: SplashView(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          // this line is important
          RefreshLocalizations.delegate,
          // GlobalWidgetsLocalizations.delegate,
          // GlobalMaterialLocalizations.delegate
        ],


        //removing glow from scroll view
        scrollBehavior: MyCustomScrollBehavior(),
      ),
    );
  }
}


//removing glow from scroll view
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
