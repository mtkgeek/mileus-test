import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:test_app/models/route_model/route_model.dart';
import 'package:test_app/models/route_model/waypoint.dart';
import 'package:test_app/services/services.dart';
import 'package:test_app/views/components/components.dart';

class LocationController extends GetxController with StateMixin {
  final LocationService _locationService = Get.put(LocationService());

  LocationData? locationData;
  Random random = Random();

  TextEditingController originLatTextController =
      TextEditingController(text: "6.5951");
  TextEditingController originLongTextController =
      TextEditingController(text: "3.3558");
  TextEditingController destinationLatTextController =
      TextEditingController(text: "6.5818");
  TextEditingController destinationLongTextController =
      TextEditingController(text: "3.3211");
  TextEditingController timeCheckTextController =
      TextEditingController(text: "");

  // time check related
  RxString timeCheck = "".obs;
  Marker? timeCheckMarker;
  RxBool routeSearchable = false.obs;
  Worker? onTimeCheck;
  RxnBool isTimeCheckSuccessful = RxnBool(null);
  // Start Location Marker

  final RoundedLoadingButtonController searchRouteBtnController =
      RoundedLoadingButtonController();

  RouteModel? route;

  // map related properties
  // For controlling the view of the Map
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  // Object for PolylinePoints
  PolylinePoints? polylinePoints;

// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};

  @override
  void onInit() async {
    await getUserLocationBackground();
    onTimeCheck = debounce(
      timeCheck,
      (_) => timeCheckCall(),
      time: const Duration(milliseconds: 500),
    );
    super.onInit();
  }

  @override
  void onClose() {
    originLatTextController.dispose();
    originLongTextController.dispose();
    destinationLatTextController.dispose();
    destinationLongTextController.dispose();
    timeCheckTextController.dispose();
    onTimeCheck?.dispose();
    super.onClose();
  }

  void checkRouteSearchable() {
    if (originLatTextController.text.isNotEmpty &&
        originLongTextController.text.isNotEmpty &&
        destinationLatTextController.text.isNotEmpty &&
        destinationLongTextController.text.isNotEmpty) {
      routeSearchable.value = true;
    } else {
      routeSearchable.value = false;
    }
  }

  // get coordinates
  Future<void> getUserLocation() async {
    try {
      showLoadingIndicator();
      Location location = Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          hideLoadingIndicator();
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          hideLoadingIndicator();
          return;
        }
      }
      final result = await location.getLocation();

      originLatTextController.text = "${result.latitude}";
      originLongTextController.text = "${result.longitude}";

      hideLoadingIndicator();
    } catch (e) {
      return Get.rawSnackbar(
        message: ' ',
        messageText:
            const Text('An error occurred', style: TextStyle(fontSize: 16)),
        overlayColor: const Color(0XFFFFFFFF),
        icon: const Icon(Icons.error, color: Colors.redAccent),
        shouldIconPulse: true,
        backgroundColor: const Color(0xFFFFFFFF),
        isDismissible: true,
        duration: const Duration(seconds: 5),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        borderRadius: 12,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> getUserLocationBackground() async {
    try {
      change(null, status: RxStatus.loading());
      Location location = Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          change(null, status: RxStatus.error());
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          change(null, status: RxStatus.error());
          return;
        }
      }
      locationData = await location.getLocation();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
      return Get.rawSnackbar(
        message: ' ',
        messageText: const Text('Unable to fetch location',
            style: TextStyle(fontSize: 16)),
        overlayColor: const Color(0XFFFFFFFF),
        icon: const Icon(Icons.error, color: Colors.redAccent),
        shouldIconPulse: true,
        backgroundColor: const Color(0xFFFFFFFF),
        isDismissible: true,
        duration: const Duration(seconds: 5),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        borderRadius: 12,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> searchRoute() async {
    markers.clear();

    await _locationService
        .searchRoute(
            originLatTextController.text,
            originLongTextController.text,
            destinationLatTextController.text,
            destinationLongTextController.text)
        .then((resp) async {
      print('Route retrieved successfully');
      route = RouteModel.fromJson(resp);
      Marker startMarker = Marker(
        markerId: MarkerId(
            "${route?.waypoints?.first.name} ${route?.waypoints?.first.hint} ${random.nextInt(1000)}"),
        position: LatLng(double.parse(originLatTextController.text),
            double.parse(originLongTextController.text)),
        infoWindow: InfoWindow(
          title: 'Origin',
          snippet: '${route?.waypoints?.first.name}',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      Marker endMarker = Marker(
        markerId: MarkerId(
            "${route?.waypoints?.last.name} ${route?.waypoints?.last.hint} ${random.nextInt(1000)}"),
        position: LatLng(double.parse(destinationLatTextController.text),
            double.parse(destinationLongTextController.text)),
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: '${route?.waypoints?.last.name}',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      markers.add(startMarker);
      markers.add(endMarker);

      FocusManager.instance.primaryFocus?.unfocus();
      Get.rawSnackbar(
        message: ' ',
        messageText: const Text('Route retrieved successfully',
            style: TextStyle(fontSize: 16)),
        overlayColor: const Color(0XFFFFFFFF),
        icon: const Icon(Icons.check, color: Colors.greenAccent),
        shouldIconPulse: true,
        backgroundColor: const Color(0xFFFFFFFF),
        isDismissible: true,
        duration: const Duration(seconds: 5),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        borderRadius: 12,
        snackPosition: SnackPosition.TOP,
      );
      searchRouteBtnController.success();
      await buildRoute();
      searchRouteBtnController.reset();
    }, onError: (err) {
      print(err.body);
      searchRouteBtnController.stop();
      Get.rawSnackbar(
        message: err.body != null ? 'An error occurred getting route' : '',
        messageText: Text(
            "${err.body != null ? err.body["message"] : 'An error occurred getting route'}",
            style: const TextStyle(fontSize: 16)),
        overlayColor: const Color(0XFFFFFFFF),
        icon: const Icon(Icons.error, color: Colors.redAccent),
        shouldIconPulse: true,
        backgroundColor: const Color(0xFFFFFFFF),
        isDismissible: true,
        duration: const Duration(seconds: 5),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        borderRadius: 12,
        snackPosition: SnackPosition.TOP,
      );
      return;
    });
  }

  Future<void> buildRoute() async {
    try {
      polylines.clear();
      polylineCoordinates.clear();
      List result = route?.routes?.first.geometry?.coordinates ?? [];
      for (var point in result) {
        polylineCoordinates.add(LatLng(point.last, point.first));
      }

      // Defining an ID
      PolylineId id = const PolylineId('poly');

      // Initializing Polyline
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.greenAccent,
        points: polylineCoordinates,
        width: 3,
      );

      // Adding the polyline to the map
      polylines[id] = polyline;
      await adjustMapView();
      debugPrint("polyline drawn successfully");
    } catch (err) {
      debugPrint("An error occurred building route");
      debugPrint(err.toString());
    }
  }

  Future<void> adjustMapView() async {
    // Calculating to check that the position relative
// to the frame, and pan & zoom the camera accordingly.
    double miny = (double.parse(originLatTextController.text) <=
            double.parse(destinationLatTextController.text))
        ? double.parse(originLatTextController.text)
        : double.parse(destinationLatTextController.text);
    double minx = (double.parse(originLongTextController.text) <=
            double.parse(destinationLongTextController.text))
        ? double.parse(originLongTextController.text)
        : double.parse(destinationLongTextController.text);
    double maxy = (double.parse(originLatTextController.text) <=
            double.parse(destinationLatTextController.text))
        ? double.parse(destinationLatTextController.text)
        : double.parse(originLatTextController.text);
    double maxx = (double.parse(originLongTextController.text) <=
            double.parse(destinationLongTextController.text))
        ? double.parse(destinationLongTextController.text)
        : double.parse(originLongTextController.text);

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

// Accommodate the two locations within the
// camera view of the map
    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
  }

  Future<void> timeCheckCall() async {
    debugPrint("it rann nnnn");
    try {
      isTimeCheckSuccessful.value = false;
      if (timeCheckMarker != null) {
        markers.remove(timeCheckMarker);
      }

      int? indexOfCoordinate;
      double sumOfDuration = 0.0;
      List? durations = route?.routes?.first.legs?.first.annotation?.duration;

      // calculate time from origin for each subsequent duration and compare with time values from api

      for (var i = 0; i < durations!.length; i++) {
        sumOfDuration = sumOfDuration + double.parse("${durations[i]}");
        if (double.parse(timeCheck.value) <= sumOfDuration) {
          indexOfCoordinate = i;
          break;
        }
      }

      if (indexOfCoordinate != null) {
        final coOrdinates = route
            ?.routes?.first.geometry?.coordinates?[indexOfCoordinate] as List;
        // set marker for new position after specified time
        timeCheckMarker = Marker(
          markerId: MarkerId(
              "${coOrdinates.first} ${coOrdinates.last} ${random.nextInt(1000)}"),
          position: LatLng(double.parse("${coOrdinates.last}"),
              double.parse("${coOrdinates.first}")),
          infoWindow: InfoWindow(
            title: 'Estimated position after',
            snippet: '$timeCheck seconds',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        );
        if (timeCheckMarker != null) {
          markers.add(timeCheckMarker!);
          isTimeCheckSuccessful.value = true;
        }
        debugPrint("it ran doonnneee");
        print(markers.length);
        // reload ui
        update();
      } else {
        isTimeCheckSuccessful.value = null;
      }
    } catch (err) {
      debugPrint("an error occurred with time check");
      print(err);
      isTimeCheckSuccessful.value = null;
    }
  }
}
