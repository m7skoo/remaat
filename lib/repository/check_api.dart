import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remaat/model/check.dart';

class GetCheck {
  static Future<http.Response> AttCheck(String token, int id) async {
    var accesstken =
        'a715da6371b293ec5e826eca691d2762d103560e50422b1df9829341f3041e7ab8ad6567a79e9b07';
    Map data = {
      "access_token": accesstken,
      "driver_id": id,
      "status": "check in"
    };
    Map<String, String> requestHeaders1 = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = json.encode(data);
    var url = Uri.parse('http://coldt.remaat.com/api/drivers/attendance');

    http.Response response =
        await http.post(url, headers: requestHeaders1, body: body);

    print(response.body);
    return response;
  }

  static Future<Check> getCheck(String token, int id) async {
    // https://jsonplaceholder.typicode.com/albums
    http.Response response = await AttCheck(token, id);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // List body = jsonDecode(response.body);
      print(jsonDecode(response.body));
      return Check.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Check');
    }
  }

  static Future<http.Response> AttCheckOut(String token, int id) async {
    var accesstken =
        'a715da6371b293ec5e826eca691d2762d103560e50422b1df9829341f3041e7ab8ad6567a79e9b07';
    Map data = {
      "access_token": accesstken,
      "driver_id": id,
      "status": "check out"
    };
    Map<String, String> requestHeaders1 = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = json.encode(data);
    var url = Uri.parse('http://coldt.remaat.com/api/drivers/attendance');

    http.Response response = await http.post(
      url,
      headers: requestHeaders1,
      body: body,
    );

    print(response.body);
    return response;
  }

  static Future<Check> getCheckOut(String token, int id) async {
    // https://jsonplaceholder.typicode.com/albums
    http.Response response = await AttCheckOut(token, id);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // List body = jsonDecode(response.body);
      print(jsonDecode(response.body));
      return Check.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Check');
    }
  }
}
