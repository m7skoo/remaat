import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

import 'package:location/location.dart';
// import 'package:location/location.dart';
// import 'package:haversine_distance/haversine_distance.dart';

class HomeMap extends StatefulWidget {
  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyAmdjuld8NWpDdQxOiZboPDpARTMNtSVBE";

  // Set<Marker> markers = Set(); //markers for google map
  // Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  LatLng startLocation = LatLng(27.6683619, 85.3101895);
  LatLng endLocation = LatLng(24.727718900000, 46.676982800000);
  final Location _location = Location();
  double distance = 0.0;
  LatLng? currentLatLng;

  @override
  void initState() {
    _location.onLocationChanged.listen((l) {
      setState(() {
        currentLatLng = LatLng(l.latitude!, l.longitude!);
        getDirections(currentLatLng!);
      });
    });

    super.initState();
  }

  getDirections(LatLng l) async {
    setState(() {
      print(currentLatLng);
    });
    double totalDistance = 0;
    totalDistance = calculateDistance(
        l.latitude, l.longitude, endLocation.latitude, endLocation.longitude);

    setState(() {
      distance = totalDistance;
    });
    print(totalDistance);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Calculate Distance in Google Map"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Stack(children: [
          currentLatLng == null
              ? const CircularProgressIndicator()
              : GoogleMap(
                  //Map widget from google_maps_flutter package
                  zoomGesturesEnabled: true, //enable Zoom in, out on map
                  initialCameraPosition: CameraPosition(
                    //innital position in map
                    target: endLocation, //initial position
                    zoom: 14.0, //initial zoom level
                  ),
                  // markers: markers, //markers to show on map
                  // polylines: Set<Polyline>.of(polylines.values), //polylines
                  mapType: MapType.normal, //map type
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  myLocationEnabled: true,
                ),
          Positioned(
              bottom: 200,
              left: 50,
              child: Container(
                  child: Card(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                        "Total Distance: " +
                            distance.toStringAsFixed(2) +
                            " KM",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
              )))
        ]));
  }
}
