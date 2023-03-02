import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:remaat/model/accept_model.dart';
import 'package:remaat/model/check.dart';
import 'package:remaat/model/complete_model.dart';
import 'package:remaat/model/order_model.dart';
import 'package:remaat/model/user.dart';
import 'package:remaat/repository/globals.dart';
import 'package:remaat/screen/order/order_screen.dart';
import 'package:remaat/util/share_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final orderprovidr = Provider<GetDataFromAPI>((ref) => GetDataFromAPI());
// final bb = StreamProvider<GetDataFromAPI>((ref) async* {
//   yield GetDataFromAPI();
// });

class GetDataFromAPI {
  static login(BuildContext context, String email, String password) async {
    var pref = await SharedPreferences.getInstance();
    Map data = {
      "access_token":
          "a715da6371b293ec5e826eca691d2762d103560e50422b1df9829341f3041e7ab8ad6567a79e9b07",
      "email": email,
      "password": password
    };
    setHeaders() => {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
    var body = json.encode(data);
    var url = Uri.parse('http://coldt.remaat.com/api/login');
    // var url1 = Uri.parse('http://test.remaat.com/api/login');

    var response = await http.post(
      url,
      body: body,
      headers: setHeaders(),
    );
    // var response1 = await http
    //     .post(
    //       url1,
    //       body: body,
    //       headers: setHeaders(),
    //     )
    //     .timeout(const Duration(seconds: 8));
    try {
      if (response.statusCode == 200) {
        final respo = UserModel.fromJson(jsonDecode(response.body));
        if (respo.token != null) {
          pref.setString(ShareConst.token, respo.token!);
          pref.setString(ShareConst.name, respo.user!.name!);
          pref.setString(ShareConst.email, respo.user!.email!);
          pref.setInt(ShareConst.driverId, respo.driverId!);
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ScreenOrder()));
          // ignore: use_build_context_synchronously
          errorSnaokBar(context, 'Welcome ${respo.user!.name!}', Colors.green);
        }

        return respo;
      }

      Map resul = jsonDecode(response.body);
      // ignore: use_build_context_synchronously
      errorSnaokBar(context, resul.values.first, Colors.red);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Orders>> getData(token) async {
    final uri = Uri.parse('http://coldt.remaat.com/api/orders/all');
    Map<String, String> requestHeaders1 = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    http.Response response = await http
        .get(uri, headers: requestHeaders1)
        .timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map(((e) => Orders.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  //get accept
  Future<List<AcceptOrder>> getDataAccept(token, driverId) async {
    final urr = Uri.parse('http://coldt.remaat.com/api/drivers/get_orders');

    Map data = {"driver_id": driverId};

    var body = json.encode(data);

    Map<String, String> requestHeaders1 = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    http.Response response =
        await http.post(urr, headers: requestHeaders1, body: body);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map(((e) => AcceptOrder.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  //compete
  Future<List<CompleteOrder>> getDataComplete(token, driverId) async {
    final urr =
        Uri.parse('http://coldt.remaat.com/api/orders/get_orders_delivered');

    Map data = {"driver_id": driverId};

    var body = json.encode(data);

    Map<String, String> requestHeaders1 = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    http.Response response =
        await http.post(urr, headers: requestHeaders1, body: body);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map(((e) => CompleteOrder.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

class StatusOrder {
  static Future<Check> statuscheck(
      {String? token, String? status, int? orderid, int? id}) async {
    Check check;
    Map data = {
      "access_token":
          "a715da6371b293ec5e826eca691d2762d103560e50422b1df9829341f3041e7ab8ad6567a79e9b07",
      "order_id": orderid,
      "driver": id,
      "status": status,
    };
    Map<String, String> requestHeaders1 = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = json.encode(data);
    var url = Uri.parse('http://coldt.remaat.com/api/orders/update/status');

    http.Response response =
        await http.post(url, headers: requestHeaders1, body: body);
    if (response.statusCode == 200) {
      check = Check.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Check');
    }

    return check;
  }

  // static Future<Check> getStatus(
  //     {String? token, String? status, int? orderid, int? id}) async {
  //   http.Response response = await statuscheck(token!, status!, orderid!, id!);

  //   if (response.statusCode == 200) {
  //     return Check.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load Check');
  //   }
  // }
}
