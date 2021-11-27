import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:test_app/constants/app_routes.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:test_app/views/components/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  const String passKey = String.fromEnvironment('PASSWORD');
  GetStorage().write('password', passKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Loading(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Test',
        initialRoute: '/map',
        getPages: AppRoutes.routes,
      ),
    );
  }
}
