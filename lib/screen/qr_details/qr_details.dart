import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:remaat/bloc/order/order_bloc.dart';
import 'package:remaat/const/padd.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/screen/assept/assetp_screen.dart';
import 'package:remaat/screen/details/details_screen.dart';
import 'package:remaat/util/colors.dart';
import 'package:remaat/util/design/colors.dart';
import 'package:remaat/util/styles.dart';

class QrDetails extends StatefulWidget {
  final String resultQR, token;
  final int driverId;
  const QrDetails(
      {required this.resultQR,
      required this.token,
      required this.driverId,
      super.key});

  @override
  State<QrDetails> createState() => _QrDetailsState();
}

class _QrDetailsState extends State<QrDetails> {
  LatLng? currentLatLng;
  bool? attendance = false;
  Location location = Location();

  @override
  void initState() {
    super.initState();

    maplocation();
  }

  maplocation() async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      location.onLocationChanged.listen((l) {
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => OrderBloc(
          RepositoryProvider.of<GetDataFromAPI>(context), widget.token)
        ..add(LoadOrder()),
      child: Scaffold(
          body: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
        if (state is OrderLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is OrderLoadedState) {
          final allorders = state.data;
          return Column(
            children: [
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: () async =>
                          context.read<OrderBloc>().add(LoadOrder()),
                      child: ListView.builder(
                          itemCount: allorders.length,
                          itemBuilder: (context, index) {
                            var item = allorders[index];

                            // final item = itemOrder[index];
                            final lat = double.parse(item.sender!.lat!);
                            final lag = double.parse(item.sender!.lng!);
                            // final latr = double.parse(item.receiver!.lat!);
                            final lagr = double.parse(item.receiver!.lng!);

                            // double distance = 0.0;

                            item.distance = currentLatLng == null
                                ? 0.0
                                : calculateDistance(currentLatLng!.latitude,
                                    currentLatLng!.longitude, lat, lag);

                            return item.orderId == widget.resultQR
                                ? Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => DetailsScreen(
                                                      issho: true,
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
                                                      totalprice: item
                                                          .total_Price!
                                                          .toDouble(),
                                                      namereseriver:
                                                          item.receiver!.name,
                                                      typesen: item.sender!.role,
                                                      paymentMethod: item.paymentMethod,
                                                      typeres: item.receiver!.role,
                                                      cityres: item.receiver!.city,
                                                      areares: item.receiver!.area,
                                                      streatres: item.receiver!.street,
                                                      sername: item.package!.service!.name,
                                                      boccount: item.boxCount,
                                                      itemvalue: item.totalPrice,
                                                      weight: item.sHWeight,
                                                      packagename: item.package!.name,
                                                      token: widget.token,
                                                      driverId: widget.driverId,
                                                      itemid: item.id,
                                                      reference: item.reference.toString())));
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                topRight: Radius.circular(8.0),
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${getlang(context, 'idorder')}: ${item.orderId}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                        ),
                                                        padd3,
                                                        Text(
                                                            "${getlang(context, 'Reference')}: ${item.reference.toString()}",
                                                            style: GoogleFonts
                                                                .tajawal(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                            .grey[
                                                                        700])),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(Icons
                                                            .date_range_outlined),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              getlang(context,
                                                                  'create'),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10),
                                                            ),
                                                            Text(
                                                              '${item.createdAt}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                        // SizedBox(
                                                        //   height: 25,
                                                        //   child: IconButton(
                                                        //       splashRadius: 8,
                                                        //       onPressed: () {
                                                        //         setState(
                                                        //             () {
                                                        //           item.isSelected =
                                                        //               !item.isSelected!;
                                                        //           if (item.isSelected ==
                                                        //               true) {
                                                        //             selectedOrder.add(Orders(id: item.id));
                                                        //           } else if (item.isSelected ==
                                                        //               false) {
                                                        //             selectedOrder.removeWhere((element) => element.id == item.id);
                                                        //           }
                                                        //         });
                                                        //       },
                                                        //       icon: item.isSelected!
                                                        //           ? const Icon(
                                                        //               Icons.check_box,
                                                        //               color: Colors.green,
                                                        //             )
                                                        //           : const Icon(Icons.check_box_outlined)),
                                                        // )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.grey[600],
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${getlang(context, 'shipper')}: ${item.sender!.name ?? ''}',
                                                      style: const TextStyle(
                                                          color: Colors.black38,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${getlang(context, 'type')}: ${item.sender!.role ?? ''}',
                                                      style: const TextStyle(
                                                          color: Colors.black38,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "${getlang(context, 'city')}: ${item.sender!.city ?? ''}",
                                                              style: GoogleFonts.tajawal(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          // padd5,
                                                          // Text(
                                                          //     "${getlang(context, 'streetname')}: ${item.sender!.street ?? ''}.",
                                                          //     style: GoogleFonts.tajawal(
                                                          //         color: Colors
                                                          //             .grey,
                                                          //         fontSize:
                                                          //             13,
                                                          //         fontWeight:
                                                          //             FontWeight.bold)),
                                                          Text(
                                                            "${getlang(context, 'area')}: ${item.sender!.area ?? ''}.",
                                                            style: GoogleFonts
                                                                .tajawal(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          // Text(
                                                          //   '${item.sender!.street ?? ''}, ',
                                                          //   style: const TextStyle(
                                                          //       color: Colors
                                                          //           .black38,
                                                          //       fontWeight:
                                                          //           FontWeight.bold),
                                                          // ),
                                                          // Text(
                                                          //   '${item.sender!.city ?? ''}, ',
                                                          //   style: const TextStyle(
                                                          //       color: Colors
                                                          //           .black38,
                                                          //       fontWeight:
                                                          //           FontWeight.bold),
                                                          // ),
                                                          // Expanded(
                                                          //   child:
                                                          //       Text(
                                                          //     '${item.sender!.area ?? ''}, ',
                                                          //     style: const TextStyle(
                                                          //         color:
                                                          //             Colors.black38,
                                                          //         fontWeight: FontWeight.bold),
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Container(
                                                        color: Colors.grey[200],
                                                        child: Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                var long2 = double
                                                                    .parse(item
                                                                        .sender!
                                                                        .lat!);
                                                                var lut = double
                                                                    .parse(item
                                                                        .sender!
                                                                        .lng!);

                                                                MapsLauncher
                                                                    .launchCoordinates(
                                                                        long2,
                                                                        lut,
                                                                        'Google Headquarters are here');
                                                              },
                                                              child: Center(
                                                                  child: Lottie.asset(
                                                                      'assets/images/location-pin.json',
                                                                      width: 25,
                                                                      height:
                                                                          25)),
                                                            ),
                                                            Text(
                                                              "${item.distance!.toStringAsFixed(2)} ${getlang(context, 'km')}",
                                                              style: GoogleFonts
                                                                  .tauri(
                                                                      fontSize:
                                                                          12.0,
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  children: [
                                                    // Expanded(
                                                    //   child:
                                                    //       ElevatedButton(
                                                    //     style: ElevatedButton
                                                    //         .styleFrom(
                                                    //       shape: const RoundedRectangleBorder(
                                                    //           borderRadius: BorderRadius.only(
                                                    //               bottomLeft: Radius.circular(
                                                    //                 14,
                                                    //               ),
                                                    //               bottomRight: Radius.circular(14))),
                                                    //       backgroundColor:
                                                    //           const Color.fromARGB(
                                                    //               26,
                                                    //               170,
                                                    //               146,
                                                    //               146),
                                                    //       elevation:
                                                    //           0,
                                                    //       minimumSize:
                                                    //           Size(
                                                    //               size.width,
                                                    //               40),
                                                    //     ),
                                                    //     onPressed:
                                                    //         () {
                                                    //       Navigator.push(
                                                    //           context,
                                                    //           MaterialPageRoute(
                                                    //               builder: (context) => DetailsScreen(
                                                    //                   issho: true,
                                                    //                   id: item.orderId!.toString(),
                                                    //                   status: item.status,
                                                    //                   namesender: item.sender!.name,
                                                    //                   phonenumbersen: item.sender!.phoneNumber!,
                                                    //                   phonenumberres: item.receiver!.phoneNumber,
                                                    //                   latsender: item.sender!.lat!,
                                                    //                   lutsender: item.sender!.lng,
                                                    //                   latres: item.receiver!.lat,
                                                    //                   lutres: item.receiver!.lng,
                                                    //                   citysen: item.sender!.city,
                                                    //                   areasen: item.sender!.area,
                                                    //                   streatsen: item.sender!.street,
                                                    //                   totalprice: item.total_Price!.toDouble(),
                                                    //                   namereseriver: item.receiver!.name,
                                                    //                   typesen: item.sender!.role,
                                                    //                   paymentMethod: item.paymentMethod,
                                                    //                   typeres: item.receiver!.role,
                                                    //                   cityres: item.receiver!.city,
                                                    //                   areares: item.receiver!.area,
                                                    //                   streatres: item.receiver!.street,
                                                    //                   sername: item.package!.service!.name,
                                                    //                   boccount: item.boxCount,
                                                    //                   itemvalue: item.totalPrice,
                                                    //                   weight: item.sHWeight,
                                                    //                   packagename: item.package!.name,
                                                    //                   token: token,
                                                    //                   driverId: driverId,
                                                    //                   itemid: item.id,
                                                    //                   reference: item.reference.toString())));
                                                    //       // shownitf(
                                                    //       //   item.id!,
                                                    //       //   item.orderId!.toString(),
                                                    //       //   item.sender!.city!,
                                                    //       //   item.sender!.area!,
                                                    //       // );
                                                    //     },
                                                    //     child: Text(
                                                    //       getlang(
                                                    //           context,
                                                    //           'details'),
                                                    //       style: GoogleFonts.taviraj(
                                                    //           fontSize:
                                                    //               13.5,
                                                    //           color: Colors
                                                    //               .black,
                                                    //           fontWeight:
                                                    //               FontWeight.bold),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          elevation: 0,
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(
                                                                    4,
                                                                  ),
                                                                  topRight: Radius.circular(
                                                                    4,
                                                                  ),
                                                                  bottomLeft: Radius.circular(
                                                                    14,
                                                                  ),
                                                                  bottomRight: Radius.circular(14))),
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  9,
                                                                  84,
                                                                  1),
                                                          minimumSize: Size(
                                                              size.width, 38.0),
                                                        ),
                                                        onPressed: () async {
                                                          attendance!
                                                              ? acceptDialog(
                                                                  ctx: context,
                                                                  tokecn: widget
                                                                      .token,
                                                                  orid: item.id,
                                                                  id: widget
                                                                      .driverId)
                                                              : await showAccesp();
                                                        },
                                                        child: Text(
                                                          getlang(context,
                                                              'acceptorder'),
                                                          style:
                                                              GoogleFonts.tauri(
                                                                  fontSize:
                                                                      15.5,
                                                                  color: Colors
                                                                          .green[
                                                                      100],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : allorders.length == 0
                                    ? Container(
                                        child: Center(child: Text('no result')))
                                    : Container();
                          }))),
            ],
          );
        }
        return Container();
      })),
    );
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

  Future showAccesp() {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: const Text(
                "Action to be taken",
                style: TextStyle(fontSize: 20),
              ),
              content: Text(
                getlang(context, 'attendecmust'),
                style: const TextStyle(fontSize: 18),
              ),
              actions: [
                // getCheck(,id);
                // OkButton(okecn, orid, id),
                cancelButton(),
              ],
            ));
  }

  cancelButton() {
    return TextButton(
      child: const Text(
        "OK",
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
