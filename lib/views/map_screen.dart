import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:test_app/controllers/controllers.dart';
import 'package:test_app/helpers/helpers.dart';
import 'package:test_app/views/components/components.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationController locationController = Get.put(LocationController());

  double _panelHeightOpen = 0;

  final double _panelHeightClosed = 95.0;

  PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .70;
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        parallaxEnabled: true,
        parallaxOffset: .5,
        controller: panelController,
        // ignore: prefer_const_constructors
        body: MapBody(),
        panelBuilder: (sc) => ControlPanel(
          scrollController: sc,
          panelController: panelController,
          reloadParent: () => setState(() {}),
        ),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        onPanelSlide: (double pos) => setState(() {
          // _fabHeight =
          //     pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
        }),
      ),
    );
  }
}

class ControlPanel extends StatefulWidget {
  final ScrollController scrollController;
  final PanelController panelController;
  final Function reloadParent;
  const ControlPanel(
      {Key? key,
      required this.scrollController,
      required this.panelController,
      required this.reloadParent})
      : super(key: key);

  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  final LocationController locationController = Get.find();
  final validator = Validator();

  @override
  Widget build(BuildContext context) {
    final sc = widget.scrollController;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(controller: sc, children: <Widget>[
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          const SizedBox(
            height: 18.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Control",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30.0,
          ),
          const Text(
            "Origin",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FormInputField(
                      controller: locationController.originLatTextController,
                      hintText: 'latitude',
                      onChanged: (value) =>
                          locationController.checkRouteSearchable(),
                      textInputAction: TextInputAction.next,
                      //maxLines: 1,
                      fontSize: 18.0,
                      maxLength: 10,
                      borderRadius: 8,
                      fillColor: Colors.grey.withOpacity(0.1),
                      focusColor: const Color(0XFFFFFFFF),
                      keyboardType: TextInputType.number,
                      obscureText: false),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FormInputField(
                      controller: locationController.originLongTextController,
                      hintText: 'longitude',
                      onChanged: (value) =>
                          locationController.checkRouteSearchable(),
                      textInputAction: TextInputAction.next,
                      //maxLines: 1,
                      fontSize: 18.0,
                      maxLength: 10,
                      borderRadius: 8,
                      fillColor: Colors.grey.withOpacity(0.1),
                      focusColor: const Color(0XFFFFFFFF),
                      keyboardType: TextInputType.number,
                      obscureText: false),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                  onPressed: locationController.getUserLocation,
                  icon: const Icon(
                    Icons.location_pin,
                    color: Colors.blueAccent,
                  ))
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            "Destination",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FormInputField(
                      controller:
                          locationController.destinationLatTextController,
                      hintText: 'latitude',
                      onChanged: (value) =>
                          locationController.checkRouteSearchable(),
                      textInputAction: TextInputAction.next,
                      //maxLines: 1,
                      fontSize: 18.0,
                      maxLength: 10,
                      borderRadius: 8,
                      fillColor: Colors.grey.withOpacity(0.1),
                      focusColor: const Color(0XFFFFFFFF),
                      keyboardType: TextInputType.number,
                      obscureText: false),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FormInputField(
                      controller:
                          locationController.destinationLongTextController,
                      hintText: 'longitude',
                      onChanged: (value) =>
                          locationController.checkRouteSearchable(),
                      textInputAction: TextInputAction.done,
                      //maxLines: 1,
                      fontSize: 18.0,
                      maxLength: 10,
                      borderRadius: 8,
                      fillColor: Colors.grey.withOpacity(0.1),
                      focusColor: const Color(0XFFFFFFFF),
                      keyboardType: TextInputType.number,
                      obscureText: false),
                ),
              )
            ],
          ),
          if (locationController.route != null) ...[
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              "Time check",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FormInputField(
                        controller: locationController.timeCheckTextController,
                        hintText: 'time in seconds',
                        onChanged: (value) =>
                            locationController.timeCheck.value = value ?? "",
                        textInputAction: TextInputAction.done,
                        //maxLines: 1,
                        fontSize: 18.0,
                        maxLength: 10,
                        borderRadius: 8,
                        fillColor: Colors.grey.withOpacity(0.1),
                        focusColor: const Color(0XFFFFFFFF),
                        keyboardType: TextInputType.number,
                        obscureText: false),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                // ignore: sized_box_for_whitespace
                Obx(() => Container(
                      width: 30,
                      height: 30,
                      child:
                          locationController.isTimeCheckSuccessful.value == null
                              ? const SizedBox.shrink()
                              : locationController.isTimeCheckSuccessful.value!
                                  ? const Icon(Icons.check,
                                      color: Colors.blueAccent)
                                  : const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.blueAccent,
                                    ),
                    ))
              ],
            )
          ],
          const SizedBox(
            height: 50,
          ),
          Container(
              height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Obx(
                () => RoundedLoadingButton(
                  child: const Center(
                      child: Text('SEARCH ROUTE',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18))),
                  controller: locationController.searchRouteBtnController,
                  borderRadius: 8,
                  successColor: Theme.of(context).colorScheme.primary,
                  loaderSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: locationController.routeSearchable.value
                      ? () async {
                          await locationController.searchRoute().then((value) {
                            widget.panelController.close();
                            widget.reloadParent();
                          }, onError: (err) {});
                        }
                      : null,
                  width: Get.width,
                ),
              )),
        ]),
      ),
    );
  }
}

class MapBody extends StatefulWidget {
  const MapBody({Key? key}) : super(key: key);

  @override
  _MapBodyState createState() => _MapBodyState();
}

class _MapBodyState extends State<MapBody> {
  final LocationController locationController = Get.find();

  // Initial location of the Map view
  late CameraPosition _initialLocation;

  @override
  void initState() {
    _initialLocation = CameraPosition(
        zoom: 12,
        target: LatLng(locationController.locationData?.latitude ?? 6.5818,
            locationController.locationData?.latitude ?? 3.32));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return locationController.obx(
      (_) => GetBuilder<LocationController>(builder: (context) {
        return GoogleMap(
          markers: Set<Marker>.from(locationController.markers),
          initialCameraPosition: _initialLocation,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          polylines: Set<Polyline>.of(locationController.polylines.values),
          onMapCreated: (GoogleMapController controller) {
            locationController.mapController = controller;
          },
        );
      }),
      onError: (_) => GetBuilder<LocationController>(builder: (context) {
        return GoogleMap(
          markers: Set<Marker>.from(locationController.markers),
          polylines: Set<Polyline>.of(locationController.polylines.values),
          initialCameraPosition: _initialLocation,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            locationController.mapController = controller;
          },
        );
      }),
    );
  }
}
