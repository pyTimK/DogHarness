import 'dart:async';

import 'package:bluetooth_app_test/components/dayRows.dart';
import 'package:bluetooth_app_test/components/defaultDatePicker.dart';
import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myDogDropdown.dart';
import 'package:bluetooth_app_test/components/myText.dart';
import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends ConsumerStatefulWidget {
  const LocationPage({super.key});

  @override
  LocationPageState createState() => LocationPageState();
}

class LocationPageState extends ConsumerState<LocationPage> with AutomaticKeepAliveClientMixin<LocationPage> {
  final _dogDropdownController = MyDogDropdownController();

  @override
  bool get wantKeepAlive => true;

  final Completer<GoogleMapController> mapController = Completer();

  void _setMapFitToTour(Set<Polyline> p) async {
    if (p.isEmpty || p.first.points.isEmpty) return;
    final GoogleMapController controller = await mapController.future;
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;
    for (var poly in p) {
      for (var point in poly.points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      }
    }
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLong),
          northeast: LatLng(maxLat, maxLong),
        ),
        20));
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var recordLocation = ref.watch(recordLocationProvider).value ?? [];

    // logger.wtf(recordLocation);

    Polyline polyline = Polyline(
      polylineId: const PolylineId("polyline"),
      color: Colors.blue,
      points: recordLocation.map((e) => LatLng(e.latitude, e.longitude)).toList(),
    );

    _setMapFitToTour({polyline});

    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      MyText.h1("GPS Track"),
                      DefaultDatePicker(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const MyText.p("See the places you explored together."),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MyDogDropdown(controller: _dogDropdownController),
                  ),
                  const SizedBox(height: 35),
                  const DayRows(),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: MyButton.outlineShrink(
                        label: "See Data",
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.gpsData,
                            // arguments: {
                            //   "date":
                            // }
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: GoogleMap(
              mapType: MapType.normal,
              polylines: {polyline},
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
