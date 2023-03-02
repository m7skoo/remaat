//declare packages
import 'dart:async';
import 'dart:convert';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/model/accept_model.dart';
import 'package:remaat/model/order_model.dart';
import 'package:remaat/screen/assept/status_driver.dart';
import 'package:remaat/screen/details/details_screen.dart';
// import 'package:remaat/model/order_model.dart';
import 'package:remaat/util/share_const.dart';
import 'package:remaat/widgets/timeline/timelinestate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreenOrder extends StatefulWidget {
  SearchScreenOrder() : super();

  @override
  SearchScreenOrderState createState() => SearchScreenOrderState();
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class SearchScreenOrderState extends State<SearchScreenOrder> {
  final _debouncer = Debouncer();
  String? token = '';
  // 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWM1NDcwM2JkMjkyNzA2ZGViOGQ2NjJkYjNmYWFlZmNkM2Q5OTdjZDVkN2U5MDNhNTE5MGZlYTczYTExZjM3MDNmMDJjZGJkMmMxNTA4MjUiLCJpYXQiOjE2NjM2NTc5MDkuMzExOTE2LCJuYmYiOjE2NjM2NTc5MDkuMzExOTIxLCJleHAiOjE2OTUxOTM5MDkuMzEwMTM0LCJzdWIiOiI2Iiwic2NvcGVzIjpbXX0.S4kqdFQxuPI_hEks8H9THiY3DitnR95I4qHIGIYyEjFlYzzwpLjjqxYuHRXfNMAyp9lz0S-lJtT6ajyVch5rPaih-xLA6AVxxqqd1_H8SZGEebNx7Trc0AwUKMfgCU-WVQDbq6b8W_KijwKjolBnyNcxvuQdHPiGcS2Tnh1MJmbLxNhPGFctantAfwaqwmPUGU5YL52jIg2CGKYvdd5tYigaO0o8WRbiqiLQIjpiLCoGmB5gAVPmjOD_jcWnXrooUTElEQHRUgz9vlWKPl8WslJLMfEfQI3FUBQVyRKYAQksrjsHiGII3aS4Khurc4vNwajubZGEFjRHHsWtFjlDkUigM8awr_qhw-ipz-QHjq7D3d0axW648q3psUjYn12wVWGuCI6jBVoLARcnEW27sPbyBjmNwX_EGstDVAttVp4Mhkki2ijgcc1GnGNaOTUjqwfu88j_anCXPF8gY2-uP-r3pk6psGnTRH2hC2BT-8INq0h7P_6q6Y6wQDzZos9ZidTj_fd8O1c0tNX4IQI6N_t_enY9hI77uXwzfvX6E-bCCVhOPqkESmnA6hsvdT-hgvKn1Bn3Cl-E8ua-ct2ws0L5uJzFoJ4TDT8SMqGxm2ufhZrmuH3HJOLmZBgWM9Inu2Uxmd8fp_hPoPMCM1UYUrEImRmQxVKDzzysA-LH0Y0';
  int driverId = 0;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        token = prefs.getString("token").toString();
      });
      return prefs.getString("email")!;
    });
    _fetchData(token);
    print(token);

    super.initState();
  }

  Future<void> _fetchData(token1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      token1 = prefs.getString(ShareConst.token);
    });
    getData(token1).then((subjectFromServer) {
      setState(() {
        ulist = subjectFromServer;
        userLists = ulist;
      });
    });
    print(token1);
  }

  List<Orders> ulist = [];
  List<Orders> userLists = [];
  //API call for All Subject List

  Future<List<Orders>> getData(token) async {
    final uri = Uri.parse('http://coldt.remaat.com/api/orders/all');
    Map<String, String> requestHeaders1 = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    http.Response response = await http.get(uri, headers: requestHeaders1);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map(((e) => Orders.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  // static List<AcceptOrder> parseAgents(String responseBody) {
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //   return parsed.map<AcceptOrder>((json) => AcceptOrder.fromJson(json)).toList();
  // }

  //Main Widget

  final bool finsh = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Text(
          getlang(context, 'neworders'),
          // 'Driver\'s orders',
          style: GoogleFonts.tajawal(
              color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          //Search Bar to List of typed Subject
          Container(
            padding: const EdgeInsets.all(15),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  suffixIcon: const InkWell(
                    child: Icon(Icons.search),
                  ),
                  contentPadding: const EdgeInsets.all(15.0),
                  hintText: getlang(context, 'search'),
                  hintStyle: GoogleFonts.tajawal(color: Colors.grey[500])),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    userLists = ulist
                        .where(
                          (u) => (u.orderId!.contains(string) ||
                              u.reference!
                                  .toString()
                                  .contains(string.toLowerCase()) ||
                              u.receiver!.phoneNumber!
                                  .toString()
                                  .contains(string.toLowerCase()) ||
                              u.receiver!.name!
                                  .toString()
                                  .contains(string.toLowerCase()) ||
                              u.receiver!.name!
                                  .toString()
                                  .contains(string.toLowerCase()) ||
                              u.sender!.name!
                                  .toString()
                                  .contains(string.toLowerCase()) ||
                              '0${u.sender!.phoneNumber!}'
                                  .toString()
                                  .contains(string.toLowerCase())),
                        )
                        .toList();
                  });
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(5),
              itemCount: userLists.length,
              itemBuilder: (BuildContext context, int index) {
                var item = userLists[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(2),
                                  topRight: Radius.circular(2),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order Id: ${item.orderId}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.date_range_outlined),
                                          Column(
                                            children: [
                                              Text(
                                                getlang(context, 'create'),
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                '${item.createdAt}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.blue,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Shipper: ${item.sender!.name}',
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Type: ${item.sender!.role}",
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  RichText(
                                      text: TextSpan(
                                          text:
                                              '${item.sender!.street ?? ''}  ',
                                          style: const TextStyle(
                                              color: Colors.black38,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                        TextSpan(
                                          text: '${item.sender!.city ?? ''}  ',
                                          style: const TextStyle(
                                              color: Colors.black38,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: '${item.sender!.area ?? ''}  ',
                                          style: const TextStyle(
                                              color: Colors.black38,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              '${item.sender!.buildingNumber ?? ''}  ',
                                          style: const TextStyle(
                                              color: Colors.black38,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ])),

                                  // Row(
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: [
                                  //     Expanded(
                                  //       child: Row(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         children: [
                                  //           Expanded(
                                  //             child: Text(
                                  //               '${item.sender!.street ?? ''}, ',
                                  //               style: const TextStyle(
                                  //                   color: Colors.black38,
                                  //                   fontWeight:
                                  //                       FontWeight.bold),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //             child: Text(
                                  //               '${item.sender!.city ?? ''}, ',
                                  //               style: const TextStyle(
                                  //                   color: Colors.black38,
                                  //                   fontWeight:
                                  //                       FontWeight.bold),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //             child: Text(
                                  //               '${item.sender!.area ?? ''}, ',
                                  //               style: const TextStyle(
                                  //                   color: primaryColor,
                                  //                   fontWeight:
                                  //                       FontWeight.bold),
                                  //             ),
                                  //           ),
                                  //           // Expanded(
                                  //           //   child: Text(
                                  //           //     '${item.sender!.buildingNumber}',
                                  //           //     style: const TextStyle(
                                  //           //         color: primaryColor,
                                  //           //         fontWeight:
                                  //           //             FontWeight.bold),
                                  //           //   ),
                                  //           // ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 4),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment
                                  //           .spaceAround,
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.center,
                                  //   children: [
                                  //     Column(
                                  //       children: [
                                  //         const Text(
                                  //           "Shipper",
                                  //         ),
                                  //         CircleAvatar(
                                  //           radius: 20,
                                  //           backgroundColor:
                                  //               Colors.green,
                                  //           child: IconButton(
                                  //               color:
                                  //                   Colors.white,
                                  //               onPressed: () {
                                  //                 var long2 = double
                                  //                     .parse(item
                                  //                         .sender!
                                  //                         .lat!);
                                  //                 var lut = double
                                  //                     .parse(item
                                  //                         .sender!
                                  //                         .lng!);

                                  //                 MapsLauncher
                                  //                     .launchCoordinates(
                                  //                         long2,
                                  //                         lut,
                                  //                         'Google Headquarters are here');
                                  //               },
                                  //               icon: const Icon(Icons
                                  //                   .location_on_outlined)),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     IconButton(
                                  //         onPressed: () {
                                  //           Navigator.push(
                                  //               context,
                                  //               MaterialPageRoute(
                                  //                   builder: (context) => MapScreen(
                                  //                       lag: item
                                  //                           .sender!
                                  //                           .lng!,
                                  //                       lat: item
                                  //                           .sender!
                                  //                           .lat!,
                                  //                       latres: item
                                  //                           .receiver!
                                  //                           .lat!,
                                  //                       lagres: item
                                  //                           .receiver!
                                  //                           .lng!)));
                                  //         },
                                  //         icon: Icon(Icons
                                  //             .map_outlined)),
                                  //     const SizedBox(width: 10.0),
                                  //     Column(
                                  //       children: [
                                  //         const Text(
                                  //           "Receiver",
                                  //         ),
                                  //         CircleAvatar(
                                  //           radius: 20,
                                  //           backgroundColor:
                                  //               Colors.deepPurple,
                                  //           child: IconButton(
                                  //               color:
                                  //                   Colors.white,
                                  //               onPressed: () {
                                  //                 var long2 = double
                                  //                     .parse(item
                                  //                         .receiver!
                                  //                         .lat!);
                                  //                 var lut = double
                                  //                     .parse(item
                                  //                         .receiver!
                                  //                         .lng!);

                                  //                 MapsLauncher
                                  //                     .launchCoordinates(
                                  //                         long2,
                                  //                         lut,
                                  //                         'Google Headquarters are here');
                                  //               },
                                  //               icon: const Icon(Icons
                                  //                   .location_on_outlined)),
                                  //         ),
                                  //       ],
                                  //     )
                                  //   ],
                                  // ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.transparent,
                                          elevation: 0,
                                          // minimumSize: Size(
                                          //     size.width /
                                          //         0.5,
                                          //     35)
                                        ),
                                        onPressed: () {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => DetailsScreen(
                                                      idOrder: item.orderId!
                                                          .toString(),
                                                      status: item.status,
                                                      namesender:
                                                          item.sender!.name,
                                                      phonenumbersen: item
                                                          .sender!.phoneNumber!,
                                                      phonenumberres: item
                                                          .receiver!
                                                          .phoneNumber,
                                                      latsender:
                                                          item.sender!.lat!,
                                                      lutsender:
                                                          item.sender!.lng,
                                                      latres:
                                                          item.receiver!.lat,
                                                      lutres:
                                                          item.receiver!.lng,
                                                      citysen:
                                                          item.sender!.city,
                                                      areasen:
                                                          item.sender!.area,
                                                      streatsen:
                                                          item.sender!.street,
                                                      namereseriver:
                                                          item.receiver!.name,
                                                      totalprice: item
                                                          .total_Price!
                                                          .toDouble(),
                                                      typesen:
                                                          item.sender!.role,
                                                      paymentMethod:
                                                          item.paymentMethod,
                                                      typeres: item.receiver!.role,
                                                      cityres: item.receiver!.city,
                                                      areares: item.receiver!.area,
                                                      streatres: item.receiver!.street,
                                                      sername: item.package!.service!.name,
                                                      boccount: item.boxCount,
                                                      itemvalue: item.totalPrice,
                                                      weight: item.sHWeight,
                                                      packagename: item.package!.name,
                                                      reference: item.reference.toString())),
                                            );
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black54,
                                        ),
                                        label: Text(
                                          "Order Detail",
                                          style: GoogleFonts.taviraj(
                                            fontSize: 16,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ),
                                      Text(
                                          "Reference: ${item.reference.toString()}",
                                          style: GoogleFonts.tajawal(
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  const Divider(height: 2),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(),
                                      const SizedBox(height: 6.0),
                                      // ElevatedButton(
                                      //     onPressed: () {
                                      //       Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //               builder: (context) =>
                                      //                   MapScreen(
                                      //                       latres: item
                                      //                           .receiver!
                                      //                           .lat!,
                                      //                       lagres: item
                                      //                           .receiver!
                                      //                           .lng!,
                                      //                       lat: item
                                      //                           .sender!
                                      //                           .lat!,
                                      //                       lag: item
                                      //                           .sender!
                                      //                           .lng!)));
                                      //     },
                                      //     child: Text('maps')),
                                      item.status! == 'Delivered'
                                          ? const Text(
                                              "Completed Order",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : ClipRRect(
                                              // decoration: BoxDecoration(
                                              //     color: const Color.fromARGB(
                                              //         255, 10, 78, 12),
                                              //     borderRadius:
                                              //         BorderRadius.circular(12.0)),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              child: ExpansionWidget(
                                                initiallyExpanded: false,
                                                titleBuilder:
                                                    (double animationValue,
                                                        _,
                                                        bool isExpaned,
                                                        toogleFunction) {
                                                  return ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.green,
                                                            minimumSize: Size(
                                                                size.width,
                                                                50)),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewScreenAssept(
                                                                  id: item.id!),
                                                        ),
                                                      );
                                                      toogleFunction(
                                                          animated: false);
                                                      // orders();
                                                    },
                                                    child: Text(
                                                      item.status!,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  );
                                                },
                                                content: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 260,
                                                  color: Colors.green,
                                                  child: ProcessTimelinePage(
                                                    create: item.createdAt,
                                                    orderid: item.orderId,
                                                    id: driverId,
                                                    orid: item.id,
                                                    tokecn: token,
                                                    fish: finsh,
                                                    phoneres: item
                                                        .receiver!.phoneNumber,
                                                    status: item.status,
                                                    paymothode:
                                                        item.paymentMethod,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Declare Subject class for json data or parameters of json string/data
//Class For Subject
// class Subject {
//   var text;
//   var author;
//   Subject({
//     required this.text,
//     required this.author,
//   });

//   factory Subject.fromJson(Map<dynamic, dynamic> json) {
//     return Subject(
//       text: json['text'],
//       author: json['author'],
//     );
//   }
// }