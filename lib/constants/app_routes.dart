import 'package:get/get.dart';
import 'package:test_app/views/views.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/login', page: () => LoginScreen()),
    // ignore: prefer_const_constructors
    GetPage(name: '/map', page: () => MapScreen()),
  ];
}
