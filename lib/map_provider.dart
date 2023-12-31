import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsProvider extends ChangeNotifier {
  GoogleMapController? googleMapController;
  Set<Marker> markers = {};

  initGoogleMap(GoogleMapController googleMapController) {
    this.googleMapController = googleMapController;
  }

  moveCamera(LatLng newPosition) {
    googleMapController!
        .animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14));
  }

  moveToUserPosition() async {
    Position position = await _determinePosition();
    moveCamera(LatLng(position.latitude, position.longitude));
    markers.add(Marker(
        markerId: MarkerId('location'),
        position: LatLng(position.latitude, position.longitude)));
    notifyListeners();
  }

  goToDes(LatLng des) async {
    Position position = await _determinePosition();
    double originalLat = position.latitude;
    double originalLong = position.longitude;
    double desLat = des.latitude;
    double desLong = des.longitude;

    String googleMapUrl =
        "https://www.google.com/maps/dir/?api=1&origin=$originalLat,$originalLong&destination=$desLat,$desLong&travelmode=driving";

    launch(googleMapUrl);
  }

  startTracking() {
    LocationSettings locationSettings =
        LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      moveCamera(LatLng(position.latitude, position.longitude));
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
