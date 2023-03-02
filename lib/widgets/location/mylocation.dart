import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapActivity extends StatefulWidget {
  const MapActivity({Key? key}) : super(key: key);

  @override
  State<MapActivity> createState() => _MapActivityState();
}

class _MapActivityState extends State<MapActivity> {
  LatLng? center = const LatLng(24.727718900000, 46.676982800000);
  // Position? currentLocation;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _onMapCreated;
  }

  final Location _location = Location();

  void _onMapCreated(GoogleMapController cntlr) {
    _controller = cntlr;
    _location.onLocationChanged.listen((l) {
      _location.serviceEnabled();
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          color: Colors.black.withOpacity(0.4),
        ),
        GoogleMap(
          initialCameraPosition: CameraPosition(target: center!),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          // myLocationButtonEnabled: true,
        ),
      ],
    );
  }
}
