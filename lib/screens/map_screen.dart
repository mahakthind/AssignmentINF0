import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? currentPosition;

  final List<Marker> markersList = [
    Marker(
      markerId: MarkerId("0"),
      position: LatLng(43.4787439, -80.5187513),
      infoWindow: InfoWindow(title: "Conestoga College"),
    ),
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(43.4721793, -80.5437039),
      infoWindow: InfoWindow(title: "University of Waterloo"),
    ),
    Marker(
      markerId: MarkerId("2"),
      position: LatLng(43.4978056, -80.5276314),
      infoWindow: InfoWindow(title: "Conestoga Mall"),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (currentPosition != null) {
      _moveToLocation(currentPosition!);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      var status = await Permission.location.request();
      if (status.isGranted) {
        bool isLocationServiceEnabled =
        await Geolocator.isLocationServiceEnabled();
        if (!isLocationServiceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location services are disabled.")),
          );
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        LatLng positionLatLng = LatLng(position.latitude, position.longitude);

        setState(() {
          currentPosition = positionLatLng;

          markersList.add(
            Marker(
              markerId: MarkerId("current"),
              position: positionLatLng,
              infoWindow: InfoWindow(title: "You are here"),
            ),
          );

          if (mapController != null) {
            _moveToLocation(positionLatLng);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch location: $e")),
      );
    }
  }

  void _moveToLocation(LatLng location) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 14.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
      ),
      body: Column(
        children: [
          const Text(
            "Wanna Find A Way!!",
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(43.4787439, -80.5187513), // Default position
                zoom: 11.0,
              ),
              markers: Set<Marker>.of(markersList),
            ),
          ),
        ],
      ),
    );
  }
}
