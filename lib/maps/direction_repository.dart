import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:remaat/maps/dircetion.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  static const String googleAPIKey = 'AIzaSyAA3_SXszhXXsFyjgG2TWzDqJUvgkxwRHk';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections(
      {required lat, required lag, required latres, required lagres}) async {
    var url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$lag&destination=$latres,$lagres&key=$googleAPIKey";
    final response = await _dio.get(
      url,
      // queryParameters: {
      //   'origin': '${origin.latitude},${origin.longitude}',
      //   'destination': '${destination.latitude},${destination.longitude}',
      //   'key': googleAPIKey,
      // },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }

  // Future<List<Directions?>> getDirections({
  //   required LatLng origin,
  //   required LatLng destination,
  // }) async {
  //   final response = await _dio.get(
  //     _baseUrl,
  //     queryParameters: {
  //       'origin': '${origin.latitude},${origin.longitude}',
  //       'destination': '${destination.latitude},${destination.longitude}',
  //       'key': googleAPIKey,
  //     },
  //   );

  //   // Check if response is successful
  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.data);
  //     final paymentList = jsonResponse['maps'] as List;
  //     return paymentList.map((data) => Directions.fromMap(data)).toList();
  //   } else {
  //     throw Exception('');
  //   }

  //   // return Directions.fromMap(response.data);
  // }
}
