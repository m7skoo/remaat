import 'dart:io';
import 'dart:math';

import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:maps_launcher/maps_launcher.dart';
import 'package:remaat/bloc/accept/accept_bloc.dart';
import 'package:remaat/const/colors.dart';
import 'package:remaat/const/padd.dart';
import 'package:remaat/const/text_style.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/model/accept_model.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/repository/globals.dart';
import 'package:remaat/screen/details/details_screen.dart';
import 'package:remaat/util/colors.dart';
import 'package:remaat/util/design/colors.dart';
import 'package:remaat/util/share_const.dart';
import 'package:remaat/util/styles.dart';
import 'package:remaat/widgets/phone/phone_wedgit.dart';
import 'package:remaat/widgets/slideraction.dart';
import 'package:remaat/widgets/timeline/timelinestate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class NewScreenAssept extends StatefulWidget {
  final int? id;
  const NewScreenAssept({Key? key, required this.id}) : super(key: key);

  @override
  State<NewScreenAssept> createState() => _NewScreenAsseptState();
}

class _NewScreenAsseptState extends State<NewScreenAssept> {
  final bool finsh = false;
  String pass = '';
  String email = '';
  String token = '';
  int driverId = 1;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        email = prefs.getString(ShareConst.email).toString();

        token = prefs.getString(ShareConst.token).toString();
        driverId = prefs.getInt(ShareConst.driverId)!;
        print(token);
        print(driverId);
      });
      return prefs.getString(ShareConst.email)!;
    });
    maplocation();
    super.initState();
  }

  final Location _location = Location();
  LatLng? currentLatLng;
  double distance = 0.0;

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
        create: (context) => AcceptBloc(
            RepositoryProvider.of<GetDataFromAPI>(context), token, driverId)
          ..add(LoadAccetpt()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Accept's Orders"),
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
          ),
          body: BlocBuilder<AcceptBloc, AcceptState>(
            builder: (context, state) {
              if (state is AcceptLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is AcceptLoadedState) {
                List<AcceptOrder> iitem = state.data;

                return state.data.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                            child: Column(
                          children: [
                            Image.asset(
                              'assets/images/empty.png',
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "No Accept's orders",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple,
                                    minimumSize: Size(size.width / 2, 40)),
                                onPressed: () async {
                                  context.read<AcceptBloc>().add(LoadAccetpt());
                                  // GetOrder.getOrder(token);
                                },
                                child: const Text(
                                  "Reload",
                                  style: TextStyle(fontSize: 18),
                                ))
                          ],
                        )),
                      )
                    : RefreshIndicator(
                        onRefresh: () async =>
                            context.read<AcceptBloc>().add(LoadAccetpt()),
                        child: ListView.builder(
                          itemCount: iitem.length,
                          itemBuilder: (context, index) {
                            final sortitem = iitem
                              ..sort(
                                (a, b) => b.id!.compareTo(a.id!),
                              );
                            var item = sortitem[index];
                            // final item = itemOrder[index];
                            // final lat = double.parse(item.sender!.lat!);
                            // final lag = double.parse(item.sender!.lng!);
                            // final latr = double.parse(item.receiver!.lat!);
                            // final lagr = double.parse(item.receiver!.lng!);

                            // distance = currentLatLng == null
                            //     ? 0.0
                            //     : calculateDistance(currentLatLng!.latitude,
                            //         currentLatLng!.longitude, latr, lagr);
                            return item.id == widget.id
                                ? SizedBox(
                                    width: size.width,
                                    height: size.height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                          color: Colors.white,
                                          elevation: 5,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
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
                                                    Text(
                                                      'Order Id: ${item.orderId}',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons
                                                            .date_range_outlined),
                                                        Column(
                                                          children: [
                                                            const Text(
                                                              "Create Order",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue,
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Shipper: ${item.sender!.name}',
                                                      style: const TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "Type: ${item.sender!.role}",
                                                      style: const TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                padd5,
                                                RichText(
                                                    text: TextSpan(
                                                        text:
                                                            '${item.sender!.street ?? ''}  ',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black38,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        children: [
                                                      TextSpan(
                                                        text:
                                                            '${item.sender!.city ?? ''}  ',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black38,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${item.sender!.area ?? ''}  ',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black38,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${item.sender!.buildingNumber ?? ''}  ',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black38,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ])),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        normalText(
                                                            text: 'Shipper',
                                                            color: deepPurple),
                                                        padd5,
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              Colors.green
                                                                  .withOpacity(
                                                                      0.8),
                                                          child: IconButton(
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () {
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
                                                              icon: const Icon(
                                                                  UniconsLine
                                                                      .map_marker)),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "Receiver",
                                                        ),
                                                        padd5,
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              Colors.deepPurple,
                                                          child: IconButton(
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                var long2 = double
                                                                    .parse(item
                                                                        .receiver!
                                                                        .lat!);
                                                                var lut = double
                                                                    .parse(item
                                                                        .receiver!
                                                                        .lng!);

                                                                MapsLauncher
                                                                    .launchCoordinates(
                                                                        long2,
                                                                        lut,
                                                                        'Google Headquarters are here');
                                                              },
                                                              icon: const Icon(
                                                                  UniconsLine
                                                                      .map_marker_alt)),
                                                        ),
                                                        // Text(
                                                        //     "${distance.toStringAsFixed(2)} KM",
                                                        //     style: GoogleFonts.tajawal(
                                                        //         color: Colors
                                                        //             .grey[600],
                                                        //         fontSize: 16,
                                                        //         fontWeight:
                                                        //             FontWeight
                                                        //                 .bold)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 3),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // TextButton.icon(
                                                    //   style: ElevatedButton
                                                    //       .styleFrom(
                                                    //     primary:
                                                    //         Colors.transparent,
                                                    //     elevation: 0,
                                                    //     // minimumSize: Size(
                                                    //     //     size.width /
                                                    //     //         0.5,
                                                    //     //     35)
                                                    //   ),
                                                    //   onPressed: () {
                                                    //     Navigator.push(
                                                    //         context,
                                                    //         MaterialPageRoute(
                                                    //             builder:
                                                    //                 (context) =>
                                                    //                     DetailsScreen(
                                                    //                       id: item
                                                    //                           .orderId!
                                                    //                           .toString(),
                                                    //                       status:
                                                    //                           item.status,
                                                    //                       namesender: item
                                                    //                           .sender!
                                                    //                           .name,
                                                    //                       phonenumbersen: item
                                                    //                           .sender!
                                                    //                           .phoneNumber!,
                                                    //                       phonenumberres: item
                                                    //                           .receiver!
                                                    //                           .phoneNumber,
                                                    //                       latsender: item
                                                    //                           .sender!
                                                    //                           .lat!,
                                                    //                       lutsender: item
                                                    //                           .sender!
                                                    //                           .lng,
                                                    //                       namereseriver: item
                                                    //                           .receiver!
                                                    //                           .name!,
                                                    //                       latres: item
                                                    //                           .receiver!
                                                    //                           .lat,
                                                    //                       lutres: item
                                                    //                           .receiver!
                                                    //                           .lng,
                                                    //                       citysen: item
                                                    //                           .sender!
                                                    //                           .city,
                                                    //                       areasen: item
                                                    //                           .sender!
                                                    //                           .area,
                                                    //                       streatsen: item
                                                    //                           .sender!
                                                    //                           .street,
                                                    //                       totalprice: item
                                                    //                           .total_Price!
                                                    //                           .toDouble(),
                                                    //                       typesen: item
                                                    //                           .sender!
                                                    //                           .role,
                                                    //                       paymentMethod:
                                                    //                           item.paymentMethod,
                                                    //                       typeres: item
                                                    //                           .receiver!
                                                    //                           .role,
                                                    //                       cityres: item
                                                    //                           .receiver!
                                                    //                           .city,
                                                    //                       areares: item
                                                    //                           .receiver!
                                                    //                           .area,
                                                    //                       streatres: item
                                                    //                           .receiver!
                                                    //                           .street,
                                                    //                       sername: item
                                                    //                           .package!
                                                    //                           .service!
                                                    //                           .name,
                                                    //                       boccount:
                                                    //                           item.boxCount,
                                                    //                       itemvalue:
                                                    //                           item.totalPrice,
                                                    //                       weight:
                                                    //                           item.sHWeight,
                                                    //                     )));
                                                    //   },
                                                    //   icon: const Icon(
                                                    //     Icons.arrow_drop_down,
                                                    //     color: Colors.black54,
                                                    //   ),
                                                    //   label: Text(
                                                    //     "Order Detail",
                                                    //     style:
                                                    //         GoogleFonts.taviraj(
                                                    //       fontSize: 16,
                                                    //       color: Colors.black45,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    Text(
                                                        "Reference: ${item.reference.toString()}",
                                                        style:
                                                            GoogleFonts.tajawal(
                                                                color: Colors
                                                                    .grey)),
                                                  ],
                                                ),
                                                const Divider(height: 2),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(),
                                                    item.status! == 'Delivered'
                                                        ? const Text(
                                                            "Completed Order",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : ClipRRect(
                                                            // decoration: BoxDecoration(
                                                            //     color: const Color.fromARGB(
                                                            //         255, 10, 78, 12),
                                                            //     borderRadius:
                                                            //         BorderRadius.circular(12.0)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                            child:
                                                                ExpansionWidget(
                                                              initiallyExpanded:
                                                                  true,
                                                              titleBuilder: (double
                                                                      animationValue,
                                                                  _,
                                                                  bool
                                                                      isExpaned,
                                                                  toogleFunction) {
                                                                return Container();
                                                              },
                                                              content:
                                                                  Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 240,
                                                                color: Colors
                                                                    .green,
                                                                child:
                                                                    ProcessTimelinePage(
                                                                  create: item
                                                                      .createdAt,
                                                                  orderid: item
                                                                      .orderId,
                                                                  id: driverId,
                                                                  orid: item.id,
                                                                  tokecn: token,
                                                                  fish: finsh,
                                                                  phoneres: item
                                                                      .receiver!
                                                                      .phoneNumber,
                                                                  status: item
                                                                      .status,
                                                                  paymothode: item
                                                                      .paymentMethod,
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
                                        const SizedBox(height: 20),
                                        item.status == "Driver on his way"
                                            ? Card(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      headingText(
                                                          text: 'Info Shipper',
                                                          color: deepPurple),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 18,
                                                            backgroundColor:
                                                                Colors.deepPurple[
                                                                    200],
                                                            child: IconButton(
                                                              splashRadius: 25,
                                                              hoverColor:
                                                                  Colors.orange,
                                                              focusColor:
                                                                  Colors.orange,
                                                              disabledColor:
                                                                  Colors.orange,
                                                              splashColor:
                                                                  Colors.orange,
                                                              color: Colors
                                                                  .blueGrey,
                                                              onPressed: () {
                                                                _callNumber(item
                                                                    .sender!
                                                                    .phoneNumber!);
                                                              },
                                                              icon: const Icon(
                                                                Icons.call,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              iconSize: 19,
                                                              highlightColor:
                                                                  Colors.orange,
                                                            ),
                                                          ),
                                                          CircleAvatar(
                                                            radius: 20,
                                                            backgroundColor:
                                                                Colors
                                                                    .deepPurple,
                                                            child: IconButton(
                                                                color: Colors
                                                                    .white,
                                                                onPressed: () {
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
                                                                icon: const Icon(
                                                                    Icons
                                                                        .location_on_outlined)),
                                                          ),
                                                          CircleAvatar(
                                                            radius: 18,
                                                            backgroundColor:
                                                                Colors.green,
                                                            // child: IconButton(
                                                            //   splashRadius: 25,
                                                            //   onPressed: () {
                                                            //     openwhatsapp(item
                                                            //         .sender!
                                                            //         .phoneNumber!);
                                                            //     // openwhatsapp(item
                                                            //     //     .sender!
                                                            //     //     .phoneNumber!);
                                                            //   },
                                                            //   // icon: const Icon(Icons
                                                            //   //     .whatsapp_outlined),
                                                            //   iconSize: 19,
                                                            //   color:
                                                            //       Colors.white,
                                                            // ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        item.status == "Out for delivery"
                                            ? Card(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      headingText(
                                                          text: 'Info Receiver',
                                                          color: deepPurple),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 18,
                                                            backgroundColor:
                                                                Colors.deepPurple[
                                                                    200],
                                                            child: IconButton(
                                                              splashRadius: 25,
                                                              hoverColor:
                                                                  Colors.orange,
                                                              focusColor:
                                                                  Colors.orange,
                                                              disabledColor:
                                                                  Colors.orange,
                                                              splashColor:
                                                                  Colors.orange,
                                                              color: Colors
                                                                  .blueGrey,
                                                              onPressed: () {
                                                                _callNumber(item
                                                                    .receiver!
                                                                    .phoneNumber!);
                                                              },
                                                              icon: const Icon(
                                                                Icons.call,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              iconSize: 19,
                                                              highlightColor:
                                                                  Colors.orange,
                                                            ),
                                                          ),
                                                          CircleAvatar(
                                                            radius: 20,
                                                            backgroundColor:
                                                                Colors
                                                                    .deepPurple,
                                                            child: IconButton(
                                                                color: Colors
                                                                    .white,
                                                                onPressed: () {
                                                                  var long2 = double
                                                                      .parse(item
                                                                          .receiver!
                                                                          .lat!);
                                                                  var lut = double
                                                                      .parse(item
                                                                          .receiver!
                                                                          .lng!);

                                                                  MapsLauncher
                                                                      .launchCoordinates(
                                                                          long2,
                                                                          lut,
                                                                          'Google Headquarters are here');
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .location_on_outlined)),
                                                          ),
                                                          CircleAvatar(
                                                            radius: 18,
                                                            backgroundColor:
                                                                Colors.green,
                                                            // child: IconButton(
                                                            //   splashRadius: 25,
                                                            //   onPressed: () {
                                                            //     openwhatsapp(item
                                                            //         .receiver!
                                                            //         .phoneNumber!);
                                                            //     // openwhatsapp(item
                                                            //     //     .receiver!
                                                            //     //     .phoneNumber!);
                                                            //   },
                                                            //   // icon: const Icon(Icons
                                                            //   //     .whatsapp_outlined),
                                                            //   iconSize: 19,
                                                            //   color:
                                                            //       Colors.white,
                                                            // ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        const SizedBox(height: 12.0),
                                        item.status == "Returned"
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: SliderActionButton(
                                                  onConfirm: () {
                                                    setState(() {
                                                      // proccinde + 1;

                                                      StatusOrder.statuscheck(
                                                              token: token,
                                                              status:
                                                                  "Driver assigned",
                                                              orderid: item.id,
                                                              id: driverId)
                                                          .whenComplete(
                                                              () async => context
                                                                  .read<
                                                                      AcceptBloc>()
                                                                  .add(
                                                                      LoadAccetpt()));
                                                    });
                                                  },
                                                  color:
                                                      const Color(0xff1F41DF),
                                                  text: item.status,
                                                ),
                                              )
                                            : item.status ==
                                                    "Assign to courier company"
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: SliderActionButton(
                                                      onConfirm: () {
                                                        setState(() {
                                                          // proccinde + 1;

                                                          StatusOrder.statuscheck(
                                                                  token: token,
                                                                  status:
                                                                      "Driver assigned",
                                                                  orderid:
                                                                      item.id,
                                                                  id: driverId)
                                                              .whenComplete(
                                                                  () async => context
                                                                      .read<
                                                                          AcceptBloc>()
                                                                      .add(
                                                                          LoadAccetpt()));
                                                        });
                                                      },
                                                      color: const Color(
                                                          0xff1F41DF),
                                                      text: item.status,
                                                    ),
                                                  )
                                                : item.status ==
                                                        "Driver assigned"
                                                    ? SliderActionButton(
                                                        onConfirm: () {
                                                          setState(() {
                                                            // proccinde + 1;

                                                            StatusOrder.statuscheck(
                                                                    token:
                                                                        token,
                                                                    status:
                                                                        "Driver on his way",
                                                                    orderid:
                                                                        item.id,
                                                                    id:
                                                                        driverId)
                                                                .whenComplete(
                                                                    () async => context
                                                                        .read<
                                                                            AcceptBloc>()
                                                                        .add(
                                                                            LoadAccetpt()));
                                                          });
                                                        },
                                                        color: const Color(
                                                            0xff5F20A9),
                                                        text: getlang(context,
                                                            'onwaystatus'),
                                                      )
                                                    : item.status ==
                                                            "Driver on his way"
                                                        ? SliderActionButton(
                                                            onConfirm: () {
                                                              setState(() {
                                                                // proccinde + 1;
                                                                StatusOrder.statuscheck(
                                                                        token:
                                                                            token,
                                                                        status:
                                                                            "Arrive",
                                                                        orderid:
                                                                            item
                                                                                .id,
                                                                        id:
                                                                            driverId)
                                                                    .whenComplete(() async => context
                                                                        .read<
                                                                            AcceptBloc>()
                                                                        .add(
                                                                            LoadAccetpt()));
                                                              });
                                                            },
                                                            text: getlang(
                                                                context,
                                                                'arrivstatus'),
                                                            color: const Color(
                                                                0xff572CB3),
                                                          )
                                                        : item.status ==
                                                                "Arrive"
                                                            ? SliderActionButton(
                                                                onConfirm: () {
                                                                  setState(() {
                                                                    // proccinde + 1;
                                                                    StatusOrder.statuscheck(
                                                                            token:
                                                                                token,
                                                                            status:
                                                                                "Picked up",
                                                                            orderid: item
                                                                                .id,
                                                                            id:
                                                                                driverId)
                                                                        .whenComplete(() async => context
                                                                            .read<AcceptBloc>()
                                                                            .add(LoadAccetpt()));
                                                                  });
                                                                },
                                                                text: getlang(
                                                                    context,
                                                                    'pickedstatus'),
                                                                color: const Color(
                                                                    0xff5433B8),
                                                              )
                                                            : item.status ==
                                                                    "Picked up"
                                                                ? SliderActionButton(
                                                                    onConfirm:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        // proccinde + 1;
                                                                        StatusOrder.statuscheck(token: token, status: "Out for delivery", orderid: item.id, id: driverId).whenComplete(() async => context
                                                                            .read<AcceptBloc>()
                                                                            .add(LoadAccetpt()));

                                                                        ///here add whatsapp
                                                                      });
                                                                    },
                                                                    color: const Color(
                                                                        0xff5039BD),
                                                                    text: getlang(
                                                                        context,
                                                                        'outofstatus'),
                                                                  )
                                                                : item.status ==
                                                                        "Out for delivery"
                                                                    ? SliderActionButton(
                                                                        color: const Color(
                                                                            0xff4A42C5),
                                                                        text: getlang(
                                                                            context,
                                                                            'delivstatus'),
                                                                        onConfirm:
                                                                            () {
                                                                          if (distance <=
                                                                              1.0) {
                                                                            setState(() {
                                                                              if (item.paymentMethod == 'COD') {
                                                                                showDialog(
                                                                                    barrierDismissible: false,
                                                                                    context: context,
                                                                                    builder: (_) => AlertDialog(
                                                                                          backgroundColor: Colors.white,
                                                                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                                          titlePadding: const EdgeInsets.all(0),
                                                                                          title: Stack(
                                                                                            children: [
                                                                                              Image.asset(
                                                                                                'assets/images/dialog_header.png',
                                                                                                color: deepPurpleColor,
                                                                                              ),
                                                                                              Container(
                                                                                                margin: const EdgeInsets.only(top: 10),
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  getlang(context, 'conform'),
                                                                                                  style: AppStyles.DialogTitle,
                                                                                                )),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          content: SizedBox(
                                                                                            height: 100,
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(getlang(context, 'textconform'), style: const TextStyle(color: AppColors.card)),
                                                                                                Row(
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      getlang(context, 'amount'),
                                                                                                      style: GoogleFonts.tauri(fontWeight: FontWeight.bold),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      ':${item.cODAmount} SR',
                                                                                                      style: GoogleFonts.tauri(fontWeight: FontWeight.bold),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          actions: <Widget>[
                                                                                            TextButton(
                                                                                              child: Container(
                                                                                                width: 100,
                                                                                                height: 40,
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(30.0),
                                                                                                  border: Border.all(color: AppColors.blue),
                                                                                                ),
                                                                                                child: Center(
                                                                                                  child: Text(
                                                                                                    'Collected',
                                                                                                    style: GoogleFonts.acme(fontWeight: FontWeight.bold, fontSize: 18),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              onPressed: () {
                                                                                                setState(() {
                                                                                                  Navigator.push(
                                                                                                      context,
                                                                                                      MaterialPageRoute(
                                                                                                          builder: (context) => VeriyPhone(
                                                                                                                title: item.receiver!.phoneNumber!,
                                                                                                                id: driverId,
                                                                                                                orid: item.id,
                                                                                                                tokecn: token,
                                                                                                              )));
                                                                                                });
                                                                                              },
                                                                                            ),
                                                                                            TextButton(
                                                                                              child: Container(
                                                                                                width: 100,
                                                                                                height: 40,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Colors.orange,
                                                                                                  borderRadius: BorderRadius.circular(30.0),
                                                                                                ),
                                                                                                child: const Center(
                                                                                                  child: Text(
                                                                                                    'Cancel',
                                                                                                    style: AppStyles.DialogValid,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ));
                                                                              } else {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => VeriyPhone(
                                                                                              title: item.receiver!.phoneNumber!,
                                                                                              id: driverId,
                                                                                              orid: item.id,
                                                                                              tokecn: token,
                                                                                            )));
                                                                              }
                                                                            });
                                                                          } else {
                                                                            errorSnaokBar(
                                                                                context,
                                                                                'ليس في مكان القريب',
                                                                                Colors.orange);
                                                                          }
                                                                        })
                                                                    : Container(),
                                        padd16,
                                      ],
                                    ),
                                  )
                                : Container();
                          },
                        ),
                      );
              }
              if (state is AcceptErrorState) {
                return Container(
                  padding: const EdgeInsets.all(30.0),
                  margin: const EdgeInsets.only(top: 200, bottom: 30),
                  child: Center(
                    child: Column(
                      children: [
                        const Text('Somthing error please try again later'),
                        const SizedBox(height: 15.0),
                        TextButton(
                            onPressed: () {
                              context.read<AcceptBloc>().add(LoadAccetpt());
                            },
                            child: const Text('try again'))
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: Text('data'));
            },
          ),
        ));
  }

  _callNumber(String numb) async {
    // const  number = widget.phonenumber; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber('0$numb');
    return res;
  }

  openwhatsapp(String phone) async {
    // var whatsapp = "506827499";
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

  // void whatsAppOpen(String phone) async {
  //   const String ss =
  //       "أنا مندوب التوصيل🙋🏻‍♂لشركة  (كولدت ) . أود إعلامك بأني سأقوم بتوصيل شحنتك📦🚐  .الرجاء مشاركة عنوان التوصيل. كما نود تأكيد التواجد اليوم في موقع التسليم.";
  //   await FlutterLaunch.launchWhatsapp(phone: phone, message: ss).onError(
  //       (error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("whatsapp no installed"))));
  // }

  // openwhatsapp(number) async {
  //   var whatsapp = "+966$number";
  //   var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
  //   var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
  //   if (Platform.isIOS) {
  //     // for iOS phone only
  //     // ignore: deprecated_member_use
  //     if (await canLaunch(whatappURLIos)) {
  //       // ignore: deprecated_member_use
  //       await launch(whatappURLIos, forceSafariVC: false);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("whatsapp no installed")));
  //     }
  //   } else {
  //     // android , web
  //     // ignore: deprecated_member_use
  //     if (await canLaunch(whatsappURlAndroid)) {
  //       // ignore: deprecated_member_use
  //       await launch(whatsappURlAndroid);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("whatsapp no installed")));
  //     }
  //   }
  // }
}
