import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sewa_connect/services/database_services.dart';

class MapPage extends StatefulWidget {
  final double lat;
  final double long;

  MapPage({required this.lat, required this.long});

  // const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Text("Map Page"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.lat, widget.long),
            zoom: 17
        ),
        markers: {
          Marker(
            markerId: MarkerId("destination"),
            position: LatLng(widget.lat, widget.long),)
        },
      ),
    );
  }
}
