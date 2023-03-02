import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:remaat/Drawer/My_Drawer_Admin.dart';
import 'package:remaat/bloc/order/order_bloc.dart';
import 'package:remaat/localiation/icon_language.dart';
import 'package:remaat/localiation/languagewead.dart';
import 'package:remaat/localiation/language_constants.dart';

import 'package:remaat/model/order_model.dart';
import 'package:remaat/notification/local_notification_service.dart';
import 'package:remaat/repository/check_api.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/screen/assept/assetp_screen.dart';
import 'package:remaat/screen/details/details_screen.dart';
import 'package:remaat/screen/order/location_order.dart';
import 'package:remaat/util/colors.dart';
import 'package:remaat/util/design/drowpdon.dart';
import 'package:remaat/util/share_const.dart';
import 'package:remaat/util/styles.dart';
import 'package:remaat/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:haversine_distance/haversine_distance.dart';

class ScreenSheduled extends StatefulWidget {
  const ScreenSheduled({Key? key}) : super(key: key);

  @override
  State<ScreenSheduled> createState() => _ScreenSheduledState();
}

class _ScreenSheduledState extends State<ScreenSheduled> {
  String pass = '';
  String email = '';
  String token = '';
  int driverId = 0;
  // bool attend = false;
  bool? attendance = false;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        email = prefs.getString(ShareConst.email).toString();

        token = prefs.getString(ShareConst.token).toString();
        driverId = prefs.getInt(ShareConst.driverId)!;
        attendance = prefs.getBool(ShareConst.attendance)!;

        print(token);
        print(driverId);
        print(attendance);
      });
      return prefs.getString(ShareConst.email)!;
    });
    super.initState();
  }

  final bool finsh = false;

  // final haversineDistance = HaversineDistance();

  getChekout() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    GetCheck.getCheckOut(token, driverId).then((value) {
      if (value != null) {
        showToast(value.message!, Colors.red);
        setState(() {
          attendance = false;
          share.setBool(ShareConst.attendance, false);
        });
      }
    });
    // }
  }

  getCheck() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    GetCheck.getCheck(token, driverId).then((value) {
      if (value != null) {
        showToast(value.message!, Colors.green);

        setState(() {
          attendance = true;
          share.setBool(ShareConst.attendance, true);
        });
      }
    });
    // }
  }

  showToast(message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) =>
          OrderBloc(RepositoryProvider.of<GetDataFromAPI>(context), token)
            ..add(LoadOrder()),
      child: Scaffold(
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 28, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.deepPurple,
                  child: CircleAvatar(
                      radius: 26,
                      foregroundColor: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationOrder()));
                        },
                        child: Center(
                            child: Lottie.asset('assets/images/earth.json',
                                fit: BoxFit.fill)

                            // IconButton(
                            //     onPressed: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) => LocationOrder()));
                            //     },
                            //     icon: const Icon(
                            //       Icons.location_on,
                            //       size: 35,
                            //       color: whiteColor,
                            //     )),
                            ),
                      )),
                ),
                // SpeedDial(
                //   backgroundColor: primaryColor,
                //   label: isduty
                //       ? Text(dutyStatus)
                //       : wrong
                //           ? const Text(
                //               "Out of service",
                //               style: TextStyle(fontWeight: FontWeight.bold),
                //             )
                //           : const Text(
                //               "in service",
                //               style: TextStyle(fontWeight: FontWeight.bold),
                //             ),
                //   children: [
                //     SpeedDialChild(
                //         backgroundColor: Colors.green,
                //         child: const Icon(Icons.check_sharp),
                //         label: "check in",
                //         onTap: getCheck),
                //     SpeedDialChild(
                //         backgroundColor: Colors.red,
                //         child: const Icon(Icons.close_sharp),
                //         label: "check out",
                //         onTap: getChekout)
                //   ],
                // ),
              ],
            )
/*      floatingActionButton: SpeedDial(
        backgroundColor: backgroundColor,
        label: Text(dutyStatus),
        children: [
          SpeedDialChild(
              backgroundColor: greenColor,
              child: const Icon(Icons.check_sharp),
              label: 'check in ',
              onTap: getCheck),
          SpeedDialChild(
              backgroundColor: redColor,
              child: const Icon(Icons.close_sharp),
              label: 'check out ',
              onTap: getChekout)
        ],*/
            ),
        appBar: AppBar(
          title: Text(
            getlang(context, 'sheduled'),
            // 'Driver\'s orders',
            style: GoogleFonts.tajawal(
              color: Colors.grey,
            ),
          ),
          // centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            // Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: SizedBox(
            //         width: 100,
            //         height: 50,
            //         child: DropdownButton(
            //           borderRadius: BorderRadius.circular(18),
            //           hint: Text(
            //             getlang(context, 'attedance'),
            //             style: GoogleFonts.tajawal(
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 12),
            //           ),
            //           underline: const SizedBox(),
            //           // items: dropDownOptions.map<DropdownMenuItem<String>>((String mascot) {
            //           //   return DropdownMenuItem<String>(child: Text(mascot), value: mascot);
            //           // }).toList(),
            //           // Alternative way to pass items
            //           items: [
            //             DropdownMenuItem(
            //                 value: "off servoce",
            //                 child: TextButton.icon(
            //                     onPressed: () {
            //                       attendance! == false;
            //                       getChekout();
            //                     },
            //                     icon: const Icon(
            //                       Icons.offline_bolt_outlined,
            //                       color: Colors.red,
            //                     ),
            //                     label: Text(
            //                       getlang(context, 'stopduty'),
            //                       style: GoogleFonts.tauri(
            //                           fontSize: 12, color: Colors.red),
            //                     ))),
            //             DropdownMenuItem(
            //                 value: "on servoce",
            //                 child: TextButton.icon(
            //                     onPressed: () {
            //                       attendance! == true;
            //                       getCheck();
            //                     },
            //                     icon: const Icon(
            //                       Icons.task_outlined,
            //                       color: Colors.green,
            //                     ),
            //                     label: Text(
            //                       getlang(context, 'startduty'),
            //                       style: GoogleFonts.tauri(
            //                         fontSize: 12,
            //                         color: Colors.green,
            //                       ),
            //                     ))),
            //           ],
            //           // value: _dropdownValue,
            //           onChanged: (value) {},
            //           // Customizatons
            //           //iconSize: 42.0,
            //           //iconEnabledColor: Colors.green,
            //           // icon: const Icon(Icons.flutter_dash),
            //           isExpanded: true,
            //           style: const TextStyle(
            //             color: Colors.blue,
            //           ),
            //         ))
            //     // LanguagePickericon(width: size.width * 0.2),
            //     ),
          ],
        ),
        // drawer: My_Drawer_Admin(),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is OrderLoadedState) {
              List<Orders> iitem = state.data;

              return state.data.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 1, right: 1, bottom: 4),
                      child: Center(
                          child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            color: attendance! ? Colors.green : Colors.red,
                            child: Center(
                                child: attendance!
                                    ? Text(
                                        getlang(context, 'onservice'),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        getlang(context, 'offservice'),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                          ),
                          Image.asset(
                            'assets/images/empty.png',
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "There are no scheduled requests",
                            style: GoogleFonts.tajawal(
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
                                context.read<OrderBloc>().add(LoadOrder());
                                // GetOrder.getOrder(token);
                              },
                              child: Text(
                                "Reload",
                                style: GoogleFonts.tauri(
                                  fontSize: 18,
                                ),
                              ))
                        ],
                      )),
                    )
                  : Column(children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                        color: attendance! ? Colors.green : Colors.red,
                        child: Center(
                            child: attendance!
                                ? Text(
                                    getlang(context, 'onservice'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    getlang(context, 'offservice'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                      ),
                      Expanded(
                          child: RefreshIndicator(
                              onRefresh: () async =>
                                  context.read<OrderBloc>().add(LoadOrder()),
                              child: ListView.builder(
                                  itemCount: iitem.length,
                                  itemBuilder: (context, index) {
                                    final sortitem = iitem
                                      ..sort(
                                        (a, b) => b.id!.compareTo(a.id!),
                                      );
                                    var item = sortitem[index];
                                    // final item = itemOrder[index];
                                    final lat = double.parse(item.sender!.lat!);
                                    final lag = double.parse(item.sender!.lat!);
                                    final latr =
                                        double.parse(item.receiver!.lat!);
                                    final lagr =
                                        double.parse(item.receiver!.lat!);
                                    // final startCoordinate = Location(lat, lag);
                                    // final endCoordinate = Location(latr, lagr);
                                    // final distanceInMeter =
                                    //     haversineDistance.haversine(
                                    //         startCoordinate,
                                    //         endCoordinate,
                                    //         Unit.METER);
                                    // final distanceInKm =
                                    //     haversineDistance.haversine(
                                    //         startCoordinate,
                                    //         endCoordinate,
                                    //         Unit.KM);
                                    return item.pickUpDate != ''
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Card(
                                                elevation: 5,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(8.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  8.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "Order Id: ${item.orderId}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(Icons
                                                                  .date_range_outlined),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    getlang(
                                                                        context,
                                                                        'pickupdate'),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                  Text(
                                                                    '${item.pickUpDate}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(
                                                        color: Colors.grey[600],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Shipper: ${item.sender!.name ?? ''}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black38,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            'Type: ${item.sender!.role ?? ''}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black38,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  '${item.sender!.street ?? ''}, ',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black38,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                  '${item.sender!.city ?? ''}, ',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black38,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    '${item.sender!.area ?? ''}, ',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black38,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                // Expanded(
                                                                //   child: Text(
                                                                //     '${item.sender!.buildingNumber}',
                                                                //     style: const TextStyle(
                                                                //         color: Colors.black38,
                                                                //         fontWeight:
                                                                //             FontWeight.bold),
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
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
                                                                    width: 40,
                                                                    height:
                                                                        45)),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 2),
                                                      // Divider(
                                                      //   height: 2,
                                                      //   color: Colors.grey[600],
                                                      // ),
                                                      Row(
                                                        // alignment: WrapAlignment.center,
                                                        // runSpacing: 18.0,
                                                        // spacing: 18.0,
                                                        // crossAxisAlignment:
                                                        //     CrossAxisAlignment.center,
                                                        // mainAxisAlignment:
                                                        //     MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Expanded(
                                                            child: ClipRRect(
                                                              // borderRadius:
                                                              //     BorderRadius.circular(12.0),
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary: Color
                                                                      .fromARGB(
                                                                          26,
                                                                          170,
                                                                          146,
                                                                          146),
                                                                  elevation: 0,
                                                                  minimumSize: Size(
                                                                      size.width,
                                                                      40),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => DetailsScreen(
                                                                              idOrder: item.orderId!.toString(),
                                                                              status: item.status,
                                                                              namesender: item.sender!.name,
                                                                              phonenumbersen: item.sender!.phoneNumber!,
                                                                              phonenumberres: item.receiver!.phoneNumber,
                                                                              latsender: item.sender!.lat!,
                                                                              lutsender: item.sender!.lng,
                                                                              latres: item.receiver!.lat,
                                                                              lutres: item.receiver!.lng,
                                                                              citysen: item.sender!.city,
                                                                              areasen: item.sender!.area,
                                                                              streatsen: item.sender!.street,
                                                                              totalprice: item.total_Price!.toDouble(),
                                                                              namereseriver: item.receiver!.name,
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
                                                                              reference: item.reference.toString())));
                                                                  // shownitf(
                                                                  //   item.id!,
                                                                  //   item.orderId!.toString(),
                                                                  //   item.sender!.city!,
                                                                  //   item.sender!.area!,
                                                                  // );
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Order Detail",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          // Text(distanceInKm
                                                          //     .toString()),
                                                          const SizedBox(
                                                              width: 8),
                                                          Expanded(
                                                            child: ClipRRect(
                                                              // decoration: BoxDecoration(
                                                              //     color: const Color.fromARGB(
                                                              //         255, 10, 78, 12),
                                                              //     borderRadius:
                                                              //         BorderRadius.circular(12.0)),
                                                              // borderRadius:
                                                              //     BorderRadius.circular(12.0),
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  elevation: 0,
                                                                  primary:
                                                                      const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          9,
                                                                          84,
                                                                          1),
                                                                  minimumSize: Size(
                                                                      size.width,
                                                                      40),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  attendance!
                                                                      ? acceptDialog(
                                                                          ctx:
                                                                              context,
                                                                          tokecn:
                                                                              token,
                                                                          orid:
                                                                              item.id,
                                                                          id: driverId)
                                                                      : await showAccesp();
                                                                  // .then((value) =>
                                                                  //     shownitf(
                                                                  //       item.id!,
                                                                  //       'I accepted the request ${item.orderId!}',
                                                                  //       item.sender!
                                                                  //           .city!,
                                                                  //       item.sender!
                                                                  //           .area!,
                                                                  ;
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "ACCEPT ORDER",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          // Text(
                                                          //   item.status!,
                                                          //   style: const TextStyle(
                                                          //       fontSize: 16,
                                                          //       color: Colors.green,
                                                          //       fontWeight: FontWeight.bold),
                                                          // ),
                                                        ],
                                                      ),
                                                      // isshowline
                                                      //     ? Container(
                                                      //         width:
                                                      //             MediaQuery.of(context).size.width,
                                                      //         height: 260,
                                                      //         color: Colors.green,
                                                      //         child: ProcessTimelinePage(
                                                      //           create: item.createdAt,
                                                      //           orderid: item.orderId,
                                                      //           id: driverId,
                                                      //           orid: item.id,
                                                      //           tokecn: token,
                                                      //         ),
                                                      //       )
                                                      //     : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Text(item.sender!.lat!),
                                              // Text(item.sender!.lng!),
                                              // Text(item.receiver!.lat!),
                                              // Text(item.totalPrice!),
                                              // Text(item.deliveryPrice!.toString()),
                                            ],
                                          )
                                        : Container();
                                  })))
                    ]);
            }
            if (state is OrderErrorState) {
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
                            context.read<OrderBloc>().add(LoadOrder());
                          },
                          child: const Text('try again'))
                    ],
                  ),
                ),
              );
            }
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
                          context.read<OrderBloc>().add(LoadOrder());
                        },
                        child: const Text('try again'))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // shownitf(int id, String title, String body, String des) async {
  //   return await service.showNotificationWithPayload(
  //       id: id, title: title, body: body, payload: des);
  // }

  // late final LocalNotificationService service;
  // void listenToNotification() =>
  //     service.onNotificationClick.stream.listen(onNoticationListener);

  // void onNoticationListener(String? payload) {
  //   if (payload != null && payload.isNotEmpty) {
  //     // Navigator.push(
  //     //     context,
  //     //     MaterialPageRoute(
  //     //         builder: ((context) => AcceptScreen(payload: payload))));
  //   }
  // }

  // ignore: non_constant_identifier_names
  OkButton(String tokecn, orid, id) {
    return TextButton(
      child: const Text(
        "Accept",
        style: TextStyle(fontSize: 20),
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
    );
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
              content: const Text(
                  'Are you sure that the Order will be accepted?',
                  style: TextStyle(color: AppColors.card)),
              actions: <Widget>[
                TextButton(
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: AppColors.blue),
                    ),
                    child: const Center(
                      child: Text(
                        'Accept',
                        style: AppStyles.DialogCancel,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      print(tokecn);
                      print(orid);
                      print(id);
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
                      color: deepPurpleColor,
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
}
