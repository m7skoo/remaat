import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:remaat/const/padd.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/screen/assept/assetp_screen.dart';
import 'package:remaat/screen/assept/status_driver.dart';
import 'package:remaat/util/colors.dart';
import 'package:remaat/util/styles.dart';
import 'package:remaat/widgets/colors.dart';
import 'package:remaat/widgets/location/mylocation.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {
  final int? id;
  final bool? issho;
  final bool? isnotcomplete;
  final String? idOrder;
  final String? phonenumbersen;
  final String? phonenumberres;
  final double? totalprice;
  final String? namesender;
  final String? namereseriver;
  final String? latsender, lutsender;
  final String? latres, lutres;
  final String? citysen, streatsen, areasen, typesen;
  final String? cityres, streatres, areares, typeres;
  final String? sername, boccount, itemvalue, weight, paymentMethod, status;
  final String? packagename;
  final String? token;
  final int? driverId, itemid;
  final String? reference;
  final String? pickup;
  final String? dropOff;
  const DetailsScreen(
      {Key? key,
      this.id,
      this.issho,
      this.isnotcomplete,
      this.idOrder,
      this.phonenumbersen,
      this.phonenumberres,
      this.namesender,
      this.namereseriver,
      this.totalprice,
      this.latsender,
      this.lutsender,
      this.citysen,
      this.streatsen,
      this.areasen,
      this.areares,
      this.cityres,
      this.typesen,
      this.typeres,
      this.latres,
      this.lutres,
      this.streatres,
      this.sername,
      this.boccount,
      this.weight,
      this.paymentMethod,
      this.status,
      this.packagename,
      this.token,
      this.driverId,
      this.itemid,
      this.reference,
      this.pickup,
      this.dropOff,
      this.itemvalue})
      : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final Location _location = Location();
  LatLng? currentLatLng;
  @override
  void initState() {
    maplocation();
    super.initState();
  }

  maplocation() {
    try {
      _location.onLocationChanged.listen((l) {
        setState(() {
          currentLatLng = LatLng(l.latitude!, l.longitude!);
        });
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double distance = 0.0;
  @override
  Widget build(BuildContext context) {
    // var lat = double.parse(widget.latsender!);
    // var lut = double.parse(widget.lutsender!);
    // distance = currentLatLng == null
    //     ? 0.0
    //     : calculateDistance(
    //         currentLatLng!.latitude, currentLatLng!.longitude, lat, lut);

    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('ID# ${widget.idOrder!}'),
        centerTitle: true,
        titleTextStyle:
            TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: size.width,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 180,
                      width: size.width,
                      child: const MapActivity(),
                    ),
                    // Expanded(
                    //   child: Positioned(
                    //     bottom: 0,
                    //     left: 0,
                    //     right: 0,
                    //     child: Container(
                    //         padding: const EdgeInsets.all(12),
                    //         width: size.width,
                    //         // height: size.height,
                    //         color: Colors.black.withOpacity(0.3),
                    //         child: Center(
                    //             child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               widget.citysen ?? '',
                    //               style: const TextStyle(
                    //                   color: Colors.black87,
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 18),
                    //             ),
                    // Expanded(
                    //   child: Text(
                    //     widget.streatsen ?? '',
                    //     style: const TextStyle(
                    //         color: Colors.black87,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 18),
                    //   ),
                    // ),
                    // Expanded(
                    //   child: Text(
                    //     widget.areasen ?? '',
                    //     style: const TextStyle(
                    //         color: Colors.black87,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 18),
                    //   ),
                    // )
                    // ],
                    // ))
                    // ),
                    // ),
                    // )
                  ],
                ),
              ),
              Column(
                children: [
                  // Text("${distance.toStringAsFixed(2)} KM",
                  //     style: GoogleFonts.tajawal(
                  //         color: Colors.grey[600],
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold)),
                  widget.status == "Delivered"
                      ? Container()
                      : Container(
                          color: Colors.green,
                          width: size.width,
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Status: ${widget.status!}',
                                style: GoogleFonts.tauri(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Card(
                      child: Container(
                        width: size.width,
                        height: 140,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              getlang(context, 'amountde'),
                              style: GoogleFonts.acme(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 5),
                            widget.paymentMethod == 'COD'
                                ? Text(
                                    '${widget.totalprice ?? 0} SR',
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                : const Text(
                                    '${0} SR',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                            padd5,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Reference: ${widget.reference!}",
                                    style: GoogleFonts.tajawal(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                                widget.pickup == ''
                                    ? Container()
                                    : Column(
                                        children: [
                                          Text(
                                            '${getlang(context, 'pickup')}: ${widget.dropOff}',
                                            style: GoogleFonts.tauri(
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            "${getlang(context, 'dropOff')}: ${widget.dropOff}",
                                            style: GoogleFonts.tauri(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  'Trip Info',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // for form
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16)),
                  ),
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('from',
                                style: GoogleFonts.tajawal(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                "${getlang(context, 'shipper')}: ${widget.namesender}",
                                style: GoogleFonts.tajawal(
                                    color: Colors.purple,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Expanded(
                                              flex: 0,
                                              child: Icon(
                                                Icons.location_on_rounded,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${getlang(context, 'city')}: ${widget.citysen}",
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  padd5,
                                                  Text(
                                                      "${getlang(context, 'streetname')}: ${widget.streatsen}.",
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  padd5,
                                                  Text(
                                                    "${getlang(context, 'area')}: ${widget.areasen}.",
                                                    style: GoogleFonts.tajawal(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  padd5,
                                                  Text(
                                                      "${getlang(context, 'phone')}: 966${widget.phonenumbersen}",
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        padd5,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.token_sharp,
                                              color: Colors.deepPurple,
                                            ),
                                            Text(
                                                "${getlang(context, 'type')}: ${widget.typesen ?? ''}",
                                                style: GoogleFonts.tajawal(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Text(widget.areasen!),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.green,
                                  // child: IconButton(
                                  //   splashRadius: 19,
                                  //   onPressed: () {
                                  //     // _launchWhatsapp(widget.phonenumbersen!);
                                  //     // FlutterOpenWhatsapp.sendSingleMessage(
                                  //     //     "+966506827499", "Hello");
                                  //     // openwhatsapp(widget.phonenumbersen!);/
                                  //     openwhatsapp(widget.phonenumbersen!);
                                  //     //   FlutterOpenWhatsapp.sendSingleMessage(
                                  //     //       "509029867", "Hello");
                                  //   },
                                  //   // icon: const Icon(Icons.whatsapp_outlined),
                                  //   iconSize: 19,
                                  //   color: Colors.white,
                                  // ),
                                ),
                                const SizedBox(height: 8),
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.deepPurple[400],
                                  child: IconButton(
                                    splashRadius: 19,
                                    hoverColor: Colors.orange,
                                    focusColor: Colors.orange,
                                    disabledColor: Colors.orange,
                                    splashColor: Colors.orange,
                                    color: Colors.blueGrey,
                                    onPressed: () {
                                      _callNumber(widget.phonenumbersen!);
                                    },
                                    icon: const Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                    iconSize: 19,
                                    highlightColor: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.deepPurple[400],
                                  child: IconButton(
                                    splashRadius: 19,
                                    onPressed: () {
                                      var long2 =
                                          double.parse(widget.latsender!);
                                      var lut = double.parse(widget.lutsender!);

                                      MapsLauncher.launchCoordinates(long2, lut,
                                          'Google Headquarters are here');
                                    },
                                    icon:
                                        const Icon(Icons.location_on_outlined),
                                    iconSize: 19,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // for to
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16)),
                  ),
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('To',
                                style: GoogleFonts.tajawal(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                "${getlang(context, 'receiver')}: ${widget.namereseriver}",
                                style: GoogleFonts.tajawal(
                                    color: Colors.purple,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Expanded(
                                              flex: 0,
                                              child: Icon(
                                                Icons.location_on_rounded,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${getlang(context, 'city')}: ${widget.cityres}",
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  padd5,
                                                  Text(
                                                      "${getlang(context, 'streetname')}: ${widget.streatres}.",
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  padd5,
                                                  Text(
                                                    "${getlang(context, 'area')}: ${widget.areares}.",
                                                    style: GoogleFonts.tajawal(
                                                        color: Colors.grey,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  padd5,
                                                  Text(
                                                      "${getlang(context, 'phone')}: 966${widget.phonenumberres}",
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        padd10,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.token_sharp,
                                              color: Colors.deepPurple,
                                            ),
                                            Text(
                                                "${getlang(context, 'type')}: ${widget.typeres ?? ''}",
                                                style: GoogleFonts.tajawal(
                                                    color: Colors.grey,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold)
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Text(widget.areasen!),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.green,
                                  // child: IconButton(
                                  //   splashRadius: 19,
                                  //   onPressed: () {
                                  //     // _launchWhatsapp(widget.phonenumberres!);
                                  //     // openwhatsapp(widget.phonenumberres!);
                                  //     openwhatsapp(widget.phonenumberres!);
                                  //     // FlutterOpenWhatsapp.sendSingleMessage(
                                  //     //     "966506827499", "Hello");
                                  //   },
                                  //   // icon: const Icon(Icons.whatsapp_outlined),
                                  //   iconSize: 19,
                                  //   color: Colors.white,
                                  // ),
                                ),
                                const SizedBox(height: 8),
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.deepPurple[400],
                                  child: IconButton(
                                    splashRadius: 19,
                                    hoverColor: Colors.orange,
                                    focusColor: Colors.orange,
                                    disabledColor: Colors.orange,
                                    splashColor: Colors.orange,
                                    color: Colors.blueGrey,
                                    onPressed: () {
                                      _callNumber(widget.phonenumberres!);
                                    },
                                    icon: const Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                    iconSize: 19,
                                    highlightColor: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.deepPurple[400],
                                  child: IconButton(
                                    splashRadius: 19,
                                    onPressed: () {
                                      var long2 = double.parse(widget.latres!);
                                      var lut = double.parse(widget.lutres!);

                                      MapsLauncher.launchCoordinates(long2, lut,
                                          'Google Headquarters are here');
                                    },
                                    icon:
                                        const Icon(Icons.location_on_outlined),
                                    iconSize: 19,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Items Details',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'type: ${widget.packagename}',
                              style: GoogleFonts.tajawal(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Weight',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${widget.weight ?? ''} kg',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Service type',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.sername ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Box count',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.boccount ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Goods Value',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.itemvalue ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 60),
            ],
          ),
        ),
        widget.issho == true
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    acceptDialog(
                        ctx: context,
                        tokecn: widget.token,
                        orid: widget.itemid,
                        id: widget.driverId);
                  },
                  child: Container(
                    height: 50,
                    width: size.width,
                    color: Colors.deepPurple,
                    child: const Center(
                      child: Text(
                        'Accept Order',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ))
            : Container(),
        widget.isnotcomplete == true
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: InkWell(
                    onTap: () {
                      //   acceptDialog(
                      //       ctx: context,
                      //       tokecn: widget.token,
                      //       orid: widget.itemid,
                      //       id: widget.driverId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewScreenAssept(id: widget.id!),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: size.width,
                      color: const Color.fromARGB(255, 72, 38, 132),
                      child: Center(
                        child: Text(
                          getlang(context, 'contindrive'),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )))
            : Container(),
      ]),
    );
  }

  openwhatsapp(String phone) async {
    const String ss =
        "أنا مندوب التوصيل🙋🏻‍♂لشركة  (كولدت ) . أود إعلامك بأني سأقوم بتوصيل شحنتك📦🚐  .الرجاء مشاركة عنوان التوصيل. كما نود تأكيد التواجد اليوم في موقع التسليم.";

    final Uri whatsappURlandroid =
        Uri.parse("whatsapp://send?phone=$phone&text=$ss");
    final Uri whatappURLios =
        Uri.parse("https://wa.me/$phone?text=${Uri.parse("hello")}");
    if (Platform.isIOS) {
      // for iOS phone only
      if (!await launchUrl(whatappURLios)) {
        await launchUrl(whatappURLios);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (!await launchUrl(whatsappURlandroid)) {
        await launchUrl(whatsappURlandroid);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  void _launchMapsUrl(lat, lon) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${widget.latsender!},${widget.lutsender!}&destination=${widget.latres!},${widget.lutres!}&travelmode=driving&dir_action=navigate';

    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _callNumber(String numb) async {
    // const  number = widget.phonenumber; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber('0$numb');
    return res;
  }

  void acceptDialog({BuildContext? ctx, tokecn, orid, id}) {
    showDialog(
        context: ctx!,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              titlePadding: const EdgeInsets.all(0),
              title: Stack(
                children: [
                  Image.asset(
                    'assets/images/dialog_header.png',
                    color: deepPurpleColor,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Center(
                        child: Text(
                      'Accept Orders',
                      style: AppStyles.DialogTitle,
                    )),
                  ),
                ],
              ),
              content: Text('Are you sure that the Order will be accepted?',
                  style: GoogleFonts.tajawal(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800])),
              actions: <Widget>[
                TextButton(
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: deepPurpleColor,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: AppColors.blue),
                    ),
                    child: Center(
                      child: Text(
                        'Accept',
                        style: GoogleFonts.tajawal(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      StatusOrder.statuscheck(
                              token: tokecn,
                              status: "Driver assigned", //Driver assigned
                              orderid: orid,
                              id: id)
                          .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScreenAssept())));
                    });
                  },
                ),
                TextButton(
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      // color: deepPurpleColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.tajawal(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
