import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localization/map_provider.dart';
import 'package:provider/provider.dart';

class MapsScreen extends StatefulWidget {
  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MapsProvider>(builder: (context, provider, widget) {
        return GoogleMap(
          markers: provider.markers,
          onTap: (LatLng point) {
            provider.markers.add(Marker(markerId: MarkerId('des'), position: point)) ;
            // setState(() {

            // });
            provider.goToDes(point);
          },
          onMapCreated: provider.initGoogleMap,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        );
      }),
    );
  }
}
