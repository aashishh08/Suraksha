import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyApps extends StatefulWidget {
  @override
  _MyAppsState createState() => _MyAppsState();
}

class _MyAppsState extends State<MyApps> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  //Bumi Tamanan Regency
  final LatLng _bumiTamananRegency = const LatLng(-7.8429152, 110.3875462);
  final String _bumiTamananRegencyStr = "-7.8429152, 110.3875462";
  //Qiscus
  final LatLng _qiscus = const LatLng(-7.7960708, 110.3920556);
  final String _qiscusStr = "-7.7960708, 110.3920556";

  @override
  void initState() {
    _markers.add(
      Marker(
          markerId: MarkerId(_bumiTamananRegencyStr),
          position: _bumiTamananRegency,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Bumi Tamanan Regency")),
    );
    _markers.add(
      Marker(
          markerId: MarkerId(_qiscusStr),
          position: _qiscus,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Qicsus")),
    );
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Google Maps Demo'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition:
              CameraPosition(target: _bumiTamananRegency, zoom: 15.0),
          markers: _markers,
        ),
      ),
    );
  }
}
