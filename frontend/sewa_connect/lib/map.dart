import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Stream<QuerySnapshot<Map<String, dynamic>>> ()async{}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: GoogleMap(
          markers: {
            Marker(
              infoWindow: InfoWindow(title: "Current Location 1"),
              markerId: MarkerId("Current Location"),
              icon: BitmapDescriptor.defaultMarker,
              position: LatLng(28.2605, 83.9750),
            ),
            Marker(
              markerId: MarkerId("Loc2"),
              position:LatLng(29.2605, 83.9750),
              infoWindow: InfoWindow(title: "Location 2"),


            ),
          },
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
            zoom: 13,
            target: LatLng(28.2605, 83.9750),
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}
