// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:math';

// class Home extends StatefulWidget{
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {

//   GoogleMapController? mapController; //contrller for Google map
//   PolylinePoints polylinePoints = PolylinePoints();

//   String googleAPiKey = "AIzaSyDma7ThRPGokuU_cJ2Q_qFvowIpK35RAPs";

//   Set<Marker> markers = Set(); //markers for google map
//   Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

//   LatLng startLocation = LatLng(27.6683619, 85.3101895);
//   LatLng endLocation = LatLng(27.6875436, 85.2751138);

//   double distance = 0.0;

//   @override
//   void initState() {

//      markers.add(Marker( //add start location marker
//         markerId: MarkerId(startLocation.toString()),
//         position: startLocation, //position of marker
//         infoWindow: InfoWindow( //popup info
//           title: 'Starting Point ',
//           snippet: 'Start Marker',
//         ),
//         icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//       ));

//       markers.add(Marker( //add distination location marker
//         markerId: MarkerId(endLocation.toString()),
//         position: endLocation, //position of marker
//         infoWindow: InfoWindow( //popup info
//           title: 'Destination Point ',
//           snippet: 'Destination Marker',
//         ),
//         icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//       ));
//       setState(() {
//               getDirections(); //fetch direction polylines from Google API

//       });

//     super.initState();
//   }

//   getDirections() async {
//       List<LatLng> polylineCoordinates = [];

//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//           googleAPiKey,
//           PointLatLng(startLocation.latitude, startLocation.longitude),
//           PointLatLng(endLocation.latitude, endLocation.longitude),
//           travelMode: TravelMode.driving,
//       );

//       if (result.points.isNotEmpty) {
//             result.points.forEach((PointLatLng point) {
//                 polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//             });
//       } else {
//          print(result.errorMessage);
//       }

//       //polulineCoordinates is the List of longitute and latidtude.
//       double totalDistance = 0;
//       for(var i = 0; i < polylineCoordinates.length-1; i++){
//            totalDistance += calculateDistance(
//                 polylineCoordinates[i].latitude,
//                 polylineCoordinates[i].longitude,
//                 polylineCoordinates[i+1].latitude,
//                 polylineCoordinates[i+1].longitude);
//       }
//       print(totalDistance);

//       setState(() {
//          distance = totalDistance;
//       });

//       //add to the list of poly line coordinates
//       addPolyLine(polylineCoordinates);
//   }

//   addPolyLine(List<LatLng> polylineCoordinates) {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.deepPurpleAccent,
//       points: polylineCoordinates,
//       width: 8,
//     );
//     polylines[id] = polyline;
//     setState(() {});
//   }

//   double calculateDistance(lat1, lon1, lat2, lon2){
//     var p = 0.017453292519943295;
//     var a = 0.5 - cos((lat2 - lat1) * p)/2 +
//           cos(lat1 * p) * cos(lat2 * p) *
//           (1 - cos((lon2 - lon1) * p))/2;
//     return 12742 * asin(sqrt(a));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//           appBar: AppBar(
//              title: Text("Calculate Distance in Google Map"),
//              backgroundColor: Colors.deepPurpleAccent,
//           ),
//           body: Stack(
//             children:[
//                 GoogleMap( //Map widget from google_maps_flutter package
//                         zoomGesturesEnabled: true, //enable Zoom in, out on map
//                         initialCameraPosition: CameraPosition( //innital position in map
//                           target: startLocation, //initial position
//                           zoom: 14.0, //initial zoom level
//                         ),
//                         markers: markers, //markers to show on map
//                         polylines: Set<Polyline>.of(polylines.values), //polylines
//                         mapType: MapType.normal, //map type
//                         onMapCreated: (controller) { //method called when map is created
//                           setState(() {
//                             mapController = controller;
//                           });
//                         },
//                   ),

//                   Positioned(
//                     bottom: 200,
//                     left: 50,
//                     child: Container(
//                      child: Card(
//                          child: Container(
//                             padding: EdgeInsets.all(20),
//                             child: Text("Total Distance: " + distance.toStringAsFixed(2) + " KM",
//                                          style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold))
//                          ),
//                      )
//                     )
//                  )
//             ]
//           )
//        );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Position? _currentPosition;
  Position? _previousPosition;
  StreamSubscription<Position>? _positionStream;
  double _totalDistance = 0;

  List<Position> locations = [];

  @override
  void initState() {
    super.initState();
    _calculateDistance();
  }

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Future _calculateDistance() async {
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      if ((await Geolocator.isLocationServiceEnabled())) {
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position position) {
          setState(() {
            _currentPosition = position;
            locations.add(_currentPosition!);

            if (locations.length > 1) {
              _previousPosition = locations.elementAt(locations.length - 2);

              var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
                _previousPosition!.latitude,
                _previousPosition!.longitude,
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              );
              _totalDistance += _distanceBetweenLastTwoLocations;
              print('Total Distance: $_totalDistance');
            }
          });
        }).catchError((err) {
          print(err);
        });
      } else {
        print("GPS is off.");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('Make sure your GPS is on in Settings !'),
                actions: <Widget>[
                  FloatingActionButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      })
                ],
              );
            });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _positionStream!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Manager'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Previous Latitude: ${_previousPosition?.latitude ?? '-'} \nPrevious Longitude: ${_previousPosition?.longitude ?? '-'}',
            ),
            SizedBox(height: 50),
            Text(
              'Current Latitude: ${_currentPosition?.latitude ?? '-'} \nCurrent Longitude: ${_currentPosition?.longitude ?? '-'}',
            ),
            SizedBox(height: 50),
            Text(
                'Distance: ${_totalDistance != null ? _totalDistance > 1000 ? (_totalDistance / 1000).toStringAsFixed(2) : _totalDistance.toStringAsFixed(2) : 0} ${_totalDistance != null ? _totalDistance > 1000 ? 'KM' : 'meters' : 0}')
          ],
        ),
      ),
    );
  }
}
