import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickMapPage extends StatefulWidget {
  final double lat;
  final double long;

  const PickMapPage({
    super.key,
    required this.lat,
    required this.long,
  });

  @override
  State<PickMapPage> createState() => _PickMapPageState();
}

class _PickMapPageState extends State<PickMapPage> {
  late LatLng selectedLocation;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();

    selectedLocation = LatLng(widget.lat, widget.long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: selectedLocation,
          zoom: 16,
        ),

        markers: {
          Marker(
            markerId: const MarkerId("picked"),
            position: selectedLocation,
          ),
        },

        onMapCreated: (controller) {
          mapController = controller;
        },

        onTap: (LatLng position) {
          setState(() {
            selectedLocation = position;
          });
        },
      ),


      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.check),
        label: const Text("Confirm Location"),
        onPressed: () {
          Navigator.pop(context, selectedLocation);
        },
      ),
    );
  }
}