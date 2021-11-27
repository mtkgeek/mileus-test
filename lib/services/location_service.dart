import 'dart:convert';

import 'package:get/get.dart';
import 'package:test_app/constants/urls.dart';

class LocationService extends GetConnect {
  @override
  void onInit() {
    //httpClient.baseUrl = baseUrl();
    httpClient.addRequestModifier<void>((request) async {
      request.headers["Content-Type"] = "application/json";
      request.headers["Accept"] = "application/json";
      // request.headers['Authorization'] = "Bearer $token";
      return request;
    });
  }

  Future searchRoute(
      String orLat, String orLong, String destLat, String destLong) async {
    final response = await get(
      fetchRouteUrl(orLat, orLong, destLat, destLong),
    );
    if (response.status.hasError) {
      return Future.error(response);
    } else {
      final codeUnits = json.encode(response.body);
      return json.decode(codeUnits);
    }
  }

  // Future addToCart(Map body, String token) async {
  //   final response = await post(getCartUrl(), body,
  //       headers: {"Authorization": "Bearer $token"});
  //   if (response.status.hasError) {
  //     return Future.error(response);
  //   } else {
  //     final codeUnits = json.encode(response.body);
  //     return json.decode(codeUnits);
  //   }
  // }

  // Future getNewsItems(String token) async {
  //   final response = await get(
  //     getNewsArticlesUrl(),
  //   );
  //   if (response.status.hasError) {
  //     return Future.error(response);
  //   } else {
  //     final codeUnits = json.encode(response.body);
  //     return json.decode(codeUnits);
  //   }
  // }

}
