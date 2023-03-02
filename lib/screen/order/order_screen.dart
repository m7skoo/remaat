import 'dart:async';

// import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:remaat/Drawer/My_Drawer_Admin.dart';
import 'package:remaat/bloc/order/order_bloc.dart';
import 'package:remaat/const/padd.dart';
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
import 'package:remaat/screen/qr_details/qr_details.dart';
import 'package:remaat/util/colors.dart';
import 'package:remaat/util/design/drowpdon.dart';
import 'package:remaat/util/share_const.dart';
import 'package:remaat/util/styles.dart';
import 'package:remaat/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:remaat/screen/search/search_screen.dart';
import 'package:remaat/fornearlynotification/notification.dart' as notif;

class ScreenOrder extends StatefulWidget {
  const ScreenOrder({Key? key}) : super(key: key);

  @override
  State<ScreenOrder> createState() => _ScreenOrderState();
}

class _ScreenOrderState extends State<ScreenOrder> {
  final _debouncer = Debouncer();
  List<Orders> allorders = [];
  List<Orders> searchorder = [];
  bool _isSearching = false;
  final _searchController = TextEditingController();
  String pass = '';
  String email = '';
  String token = '';
  int driverId = 0;
  // bool attend = false;
  bool? attendance = false;
  bool isbuttsearch = false;
  TextEditingController searchControll = TextEditingController();
  late Timer timer;
  Location location = Location();
  LatLng? currentLatLng;
  List<Orders> selectedOrder = [];
  bool isShedual = true;

  double? lat, lag;
  bool? isnotif;
  String? name = '';

  @override
  void initState() {
    super.initState();
    inishareprefence();
    maplocation();

    // fetchnearly();
    searchorder = [];
  }

  // fetchnearly() {
  //   return contactOrder.forEach((data) {
  //     for (var element in data) {
  //       var lat = double.parse('${element.sender!.lat}');
  //       var lug = double.parse('${element.sender!.lng}');
  //       // print(lat);
  //       setState(() {
  //         lat = lat;
  //         lag = lug;
  //         // isnotif = element.notified!;
  //         name = element.sender!.name!;
  //       });
  //     }
  //   }).then((vale) => {
  //         print(lat!),
  //         // print(isnotif),
  //         // print(name),
  //         _initWorker(lat!, lag!, isnotif!, name),
  //       });
  // }

  // _initWorker(double llt, double llg, bool not, str) async {
  //   await BackgroundLocation.startLocationService();
  //   BackgroundLocation.getLocationUpdates((location) {
  //     print(location.speed.toString());

  //     // for (var desiredPosition in desiredPositions) {
  //     // var lat = double.parse(desiredPosition.sender!.lat!);
  //     // var lug = double.parse(desiredPosition.sender!.lng!);
  //     double distanceInMeters = Geolocator.distanceBetween(
  //         location.latitude!, location.longitude!, llt, llg);
  //     if (distanceInMeters <= 1000.0 && !not) {
  //       isnotif = true;
  //       notif.Notification notification = notif.Notification();
  //       notification.showNotificationWithoutSound(str);
  //     }
  //     // }
  //   });
  // }

  // GetDataFromAPI getDataFromAPI = GetDataFromAPI();
  // Stream<List<Orders>> get contactOrder async* {
  //   yield await getDataFromAPI.getData(token);
  // }

  inishareprefence() async {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        email = prefs.getString(ShareConst.email).toString();

        token = prefs.getString(ShareConst.token).toString();
        driverId = prefs.getInt(ShareConst.driverId)!;
        attendance = prefs.getBool(ShareConst.attendance)!;
      });
      return prefs.getString(ShareConst.email)!;
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   timer.cancel();
  // }
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

  // final Uri _url = Uri.parse('https://wa.me/966506827499"');

  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw 'Could not launch $_url';
  //   }
  // }

  Widget _buildsearchField() {
    return SizedBox(
      height: 39.5,
      child: TextField(
        controller: _searchController,
        onChanged: (order) {
          _debouncer.run(() {
            setState(() {
              addsearchforitemList(order);
            });
          });
        },
        // onEditingComplete: () {
        //   searchControll.text;
        // },
        style: const TextStyle(height: 1.0, color: Colors.black),
        autocorrect: true,
        focusNode: FocusScopeNode(),
        autofocus: true,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            border: InputBorder.none,
            // prefixIcon: const Icon(Icons.search_outlined),
            hintText: getlang(context, 'search'),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            disabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none)),
      ),
    );
  }

  void addsearchforitemList(String order) {
    searchorder = allorders
        .where((u) =>
            u.orderId!.toLowerCase().contains(order) ||
            u.reference!.toLowerCase().contains(order) ||
            u.sender!.name!.toLowerCase().contains(order) ||
            '0${u.sender!.phoneNumber!}'.toLowerCase().contains(order) ||
            u.receiver!.name!.toLowerCase().contains(order) ||
            '0${u.receiver!.phoneNumber}'.toLowerCase().contains(order))
        .toList();
  }

  _buildAppBarAction() {
    if (_isSearching) {
      return [
        IconButton(
            onPressed: () {
              _clearSearching();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.clear_outlined, color: Colors.grey)),
      ];
    } else {
      return [
        IconButton(
            onPressed: _startSearch,
            icon: const Icon(Icons.search_outlined, color: Colors.grey)),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearching();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearching() {
    setState(() {
      _searchController.clear();
    });
  }

  _titleAppBar() {
    return Text(
      getlang(context, 'neworders'),
      // 'Driver\'s orders',
      style: GoogleFonts.tajawal(color: Colors.black, fontSize: 15),
    );
  }

  bool isnearly = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) =>
          OrderBloc(RepositoryProvider.of<GetDataFromAPI>(context), token)
            ..add(LoadOrder()),
      child: Scaffold(
        floatingActionButton: Container(
          // padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(bottom: 40.0, left: 10.0, right: 10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color.fromARGB(0, 234, 216, 216),
                  child: CircleAvatar(
                      radius: 24,
                      foregroundColor: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationOrder(
                                        token: token,
                                        driverId: driverId,
                                        // itemid: item!.id,
                                      )));
                        },
                        child: Center(
                            child: Lottie.asset('assets/images/earth.json')),
                      )),
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: InkWell(
                    onTap: () {
                      scanQR().whenComplete(() => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QrDetails(
                                      resultQR: _scanBarcode,
                                      token: token,
                                      driverId: driverId,
                                    )),
                            // MaterialPageRoute(builder: (context) => const driver()),
                          ));
                    },
                    child: Lottie.asset('assets/images/qr.json',
                        // reverse: false,
                        // repeat: false,
                        height: 50,
                        width: 50,
                        animate: false,
                        fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: _isSearching ? _buildsearchField() : _titleAppBar(),

          // centerTitle: true,
          backgroundColor: Colors.grey[200],
          elevation: 0,
          // leading: _isSearching
          //     ? const BackButton(
          //         color: Colors.grey,
          //       )
          //     : Container(),
          // actions: _buildAppBarAction(),
          actions: [
            _isSearching
                ? IconButton(
                    onPressed: () {
                      _clearSearching();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear_outlined, color: Colors.grey))
                : Row(
                    children: [
                      IconButton(
                          onPressed: _startSearch,
                          icon: const Icon(Icons.search_outlined,
                              color: Colors.black)),
                      PopupMenuButton(
                          // icon: const Icon(Icons.task_outlined),
                          child: Image.asset(
                            'assets/images/check.png',
                            height: 40,
                            width: 26,
                            fit: BoxFit.contain,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: "on servoce",
                                    enabled: false,
                                    child: InkWell(
                                      onTap: () {
                                        attendance! == true;
                                        getCheck();
                                      },
                                      child: SizedBox(
                                        width: 80,
                                        child: Row(
                                          children: [
                                            Text(
                                              getlang(context, 'startduty'),
                                              style: GoogleFonts.tajawal(
                                                  fontSize: 12,
                                                  color: Colors.green),
                                            ),
                                            const SizedBox(width: 1),
                                            Expanded(
                                              child: Image.asset(
                                                'assets/icons/checkin.png',
                                                height: 35,
                                                width: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                PopupMenuItem(
                                    value: "off servoce",
                                    child: InkWell(
                                      onTap: () {
                                        attendance! == false;
                                        getChekout();
                                      },
                                      child: SizedBox(
                                        width: 80,
                                        child: Row(
                                          children: [
                                            Text(
                                              getlang(context, 'stopduty'),
                                              style: GoogleFonts.tajawal(
                                                  fontSize: 12,
                                                  color: Colors.red),
                                            ),
                                            const SizedBox(width: 1),
                                            Expanded(
                                              child: Image.asset(
                                                'assets/icons/checkout.png',
                                                height: 35,
                                                width: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                              ]),
                      InkWell(
                        onTap: () {
                          scanQR().whenComplete(() => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QrDetails(
                                          resultQR: _scanBarcode,
                                          token: token,
                                          driverId: driverId,
                                        )),
                                // MaterialPageRoute(builder: (context) => const driver()),
                              ));
                        },
                        child: Lottie.asset('assets/images/qr.json'),
                      )
                    ],
                  ),
          ],
        ),
        drawer: My_Drawer_Admin(),
        body: BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderLoadedState) {
              allorders = state.data;

              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text("To Do Added Successfuly"),
              //   ),
              // );
            }
          },
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is OrderLoadedState) {
                allorders = state.data;

                var count = allorders.length;
                return state.data.isEmpty
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 1, right: 1, bottom: 4),
                        child: SingleChildScrollView(
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
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )
                                        : Text(
                                            getlang(context, 'offservice'),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )),
                              ),
                              Image.asset(
                                'assets/images/empty.png',
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "No order for now",
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.grey[200],
                                      minimumSize: const Size(100, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0))),
                                  onPressed: () async {
                                    context.read<OrderBloc>().add(LoadOrder());
                                    // GetOrder.getOrder(token);
                                  },
                                  child: SizedBox(
                                    width: 120,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.refresh_sharp),
                                        Text(
                                          getlang(context, 'Reloading'),
                                          style: TextStyle(
                                              // fontSize: 18,
                                              color: Colors.grey[800]),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          )),
                        ),
                      )
                    : Column(children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 28,
                          color: attendance! ? Colors.green : Colors.red,
                          child: Center(
                              child: attendance!
                                  ? Text(
                                      getlang(context, 'onservice'),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  : Text(
                                      getlang(context, 'offservice'),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                        ),
                        padd3,
                        Text(
                          'عدد الطلبات :${count.toString()}',
                          style: GoogleFonts.tajawal(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(''),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 33,
                                    child: Stack(
                                      children: [
                                        isShedual == true
                                            ? const Positioned(
                                                child: Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 16.0,
                                              ))
                                            : Container(),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                animationDuration:
                                                    const Duration(seconds: 2),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.0),
                                                    side: const BorderSide(
                                                        width: 0.5,
                                                        color: Colors
                                                            .deepPurpleAccent))),
                                            onPressed: () {
                                              setState(() {
                                                isShedual = true;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0, left: 4.0),
                                              child: Text(
                                                getlang(context, 'fast'),
                                                style: GoogleFonts.tajawal(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15.0),
                                  SizedBox(
                                    height: 33,
                                    child: Stack(
                                      children: [
                                        isShedual == false
                                            ? const Positioned(
                                                child: Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 16.0,
                                              ))
                                            : Container(),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                animationDuration:
                                                    const Duration(seconds: 2),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.0),
                                                    side: const BorderSide(
                                                        width: 0.5,
                                                        color: Colors
                                                            .deepPurpleAccent))),
                                            onPressed: () {
                                              setState(() {
                                                isShedual = false;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0, left: 4.0),
                                              child: Text(
                                                getlang(context, 'scheduled'),
                                                style: GoogleFonts.tajawal(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 33,
                                child: Stack(
                                  children: [
                                    isnearly == true
                                        ? const Positioned(
                                            child: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 16.0,
                                          ))
                                        : Container(),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            animationDuration:
                                                const Duration(seconds: 2),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                side: BorderSide.none)),
                                        onPressed: () {
                                          setState(() {
                                            isnearly = !isnearly;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 4.0, left: 4.0),
                                          child: Text(
                                            getlang(context, 'Nearby'),
                                            style: GoogleFonts.tajawal(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        padd3,
                        Expanded(
                            child: RefreshIndicator(
                                onRefresh: () async =>
                                    context.read<OrderBloc>().add(LoadOrder()),
                                child: ListView.builder(
                                    itemCount: _searchController.text.isEmpty
                                        ? allorders.length
                                        : searchorder.length,
                                    itemBuilder: (context, index) {
                                      final sortitem = allorders
                                        ..sort(
                                          (a, b) => b.id!.compareTo(a.id!),
                                        );
                                      final sortitemkm = allorders
                                        ..sort(
                                          (a, b) => a.distance!.compareTo(
                                              isnearly ? b.distance! : b.id!),
                                        );
                                      var itemx = sortitemkm[index];
                                      var item = _searchController.text.isEmpty
                                          ? itemx
                                          : searchorder[index];
                                      // final item = itemOrder[index];
                                      final lat =
                                          double.parse(item.sender!.lat!);
                                      final lag =
                                          double.parse(item.sender!.lng!);
                                      // final latr = double.parse(item.receiver!.lat!);
                                      final lagr =
                                          double.parse(item.receiver!.lng!);

                                      // double distance = 0.0;

                                      item.distance = currentLatLng == null
                                          ? 0.0
                                          : calculateDistance(
                                              currentLatLng!.latitude,
                                              currentLatLng!.longitude,
                                              lat,
                                              lag);

                                      //for nearlu notification
                                      // if (item.distance! <= 100) {
                                      //   // setState(() {
                                      //   item.notified = true;
                                      //   notif.Notification notification =
                                      //       notif.Notification();
                                      //   notification
                                      //       .showNotificationWithoutSound(
                                      //           item.sender!.name)
                                      //       .whenComplete(
                                      //           () => item.notified = false);

                                      //   // });
                                      // }
                                      // BackgroundLocation.getLocationUpdates(
                                      //     (location) {
                                      //   if (item.distance! < 0.20) {
                                      //     item.notified = true;
                                      //     print(item.notified);
                                      //     notif.Notification notification =
                                      //         notif.Notification();
                                      //     notification
                                      //         .showNotificationWithoutSound(
                                      //             item);
                                      //   }
                                      // });
                                      return isShedual
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
                                                                idOrder: item
                                                                    .orderId!
                                                                    .toString(),
                                                                status:
                                                                    item.status,
                                                                namesender: item
                                                                    .sender!
                                                                    .name,
                                                                phonenumbersen: item
                                                                    .sender!
                                                                    .phoneNumber!,
                                                                phonenumberres: item
                                                                    .receiver!
                                                                    .phoneNumber,
                                                                latsender: item
                                                                    .sender!
                                                                    .lat!,
                                                                lutsender: item
                                                                    .sender!
                                                                    .lng,
                                                                latres: item
                                                                    .receiver!
                                                                    .lat,
                                                                lutres: item
                                                                    .receiver!
                                                                    .lng,
                                                                citysen: item
                                                                    .sender!
                                                                    .city,
                                                                dropOff: item.dropOff,
                                                                pickup: item.pickUp,
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
                                                                token: token,
                                                                driverId: driverId,
                                                                itemid: item.id,
                                                                reference: item.reference.toString())));
                                                  },
                                                  child: Card(
                                                    elevation: 5,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      8.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      8.0),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              left: 8.0,
                                                              right: 8.0),
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
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  padd3,
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "${getlang(context, 'Reference')}: ${item.reference.toString()}",
                                                                          style: GoogleFonts.tajawal(
                                                                              fontSize: 12,
                                                                              color: Colors.grey[700])),
                                                                      Text(
                                                                          "PickUp Date: ${item.pickUp.toString()}",
                                                                          style: GoogleFonts.tajawal(
                                                                              fontSize: 12,
                                                                              color: Colors.grey[800],
                                                                              fontWeight: FontWeight.bold)),
                                                                    ],
                                                                  ),
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
                                                                        getlang(
                                                                            context,
                                                                            'create'),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 10),
                                                                      ),
                                                                      Text(
                                                                        '${item.createdAt}',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 10),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 25,
                                                                    child: IconButton(
                                                                        splashRadius: 8,
                                                                        onPressed: () {
                                                                          setState(
                                                                              () {
                                                                            item.isSelected =
                                                                                !item.isSelected!;
                                                                            if (item.isSelected ==
                                                                                true) {
                                                                              selectedOrder.add(Orders(id: item.id));
                                                                            } else if (item.isSelected ==
                                                                                false) {
                                                                              selectedOrder.removeWhere((element) => element.id == item.id);
                                                                            }
                                                                          });
                                                                        },
                                                                        icon: item.isSelected!
                                                                            ? const Icon(
                                                                                Icons.check_box,
                                                                                color: Colors.green,
                                                                              )
                                                                            : const Icon(Icons.check_box_outlined)),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Colors
                                                                .grey[600],
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
                                                                '${getlang(context, 'shipper')}: ${item.sender!.name ?? ''}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                '${getlang(context, 'type')}: ${item.sender!.role ?? ''}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 2),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
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
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
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
                                                                      style: GoogleFonts.tajawal(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                          .grey[
                                                                      200],
                                                                  child: Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          var long2 = double.parse(item
                                                                              .sender!
                                                                              .lat!);
                                                                          var lut = double.parse(item
                                                                              .sender!
                                                                              .lng!);

                                                                          MapsLauncher.launchCoordinates(
                                                                              long2,
                                                                              lut,
                                                                              'Google Headquarters are here');
                                                                        },
                                                                        child: Center(
                                                                            child: Lottie.asset('assets/images/location-pin.json',
                                                                                width: 25,
                                                                                height: 25)),
                                                                      ),
                                                                      Text(
                                                                        "${item.distance!.toStringAsFixed(2)} ${getlang(context, 'km')}",
                                                                        style: GoogleFonts.tauri(
                                                                            fontSize:
                                                                                12.0,
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 2),
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
                                                              const SizedBox(
                                                                  width: 8),
                                                              Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    elevation:
                                                                        0,
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
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            9,
                                                                            84,
                                                                            1),
                                                                    minimumSize: Size(
                                                                        size.width,
                                                                        38.0),
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
                                                                  },
                                                                  child: Text(
                                                                    getlang(
                                                                        context,
                                                                        'acceptorder'),
                                                                    style: GoogleFonts.tauri(
                                                                        fontSize:
                                                                            15.5,
                                                                        color: Colors.green[
                                                                            100],
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
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
                                                ),
                                                // Text(item.sender!.lat!),
                                                // Text(item.sender!.lng!),
                                                // Text(item.receiver!.lat!),
                                                // Text(item.totalPrice!),
                                                // Text(item.deliveryPrice!.toString()),
                                              ],
                                            )
                                          : item.pickUpDate != ''
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => DetailsScreen(
                                                                    pickup: item
                                                                        .pickUp,
                                                                    dropOff: item
                                                                        .dropOff,
                                                                    issho: true,
                                                                    idOrder: item
                                                                        .orderId!
                                                                        .toString(),
                                                                    status: item
                                                                        .status,
                                                                    namesender: item
                                                                        .sender!
                                                                        .name,
                                                                    phonenumbersen: item
                                                                        .sender!
                                                                        .phoneNumber!,
                                                                    phonenumberres: item
                                                                        .receiver!
                                                                        .phoneNumber,
                                                                    latsender: item
                                                                        .sender!
                                                                        .lat!,
                                                                    lutsender: item
                                                                        .sender!
                                                                        .lng,
                                                                    latres: item
                                                                        .receiver!
                                                                        .lat,
                                                                    lutres: item
                                                                        .receiver!
                                                                        .lng,
                                                                    citysen: item
                                                                        .sender!
                                                                        .city,
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
                                                                    token: token,
                                                                    driverId: driverId,
                                                                    itemid: item.id,
                                                                    reference: item.reference.toString())));
                                                      },
                                                      child: Card(
                                                        elevation: 5,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      8.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      8.0),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0,
                                                                  left: 8.0,
                                                                  right: 8.0),
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
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 12),
                                                                      ),
                                                                      padd3,
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              "${getlang(context, 'Reference')}: ${item.reference.toString()}",
                                                                              style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey[700])),
                                                                          Text(
                                                                              "PickUp Date: ${item.pickUp.toString()}",
                                                                              style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey[800], fontWeight: FontWeight.bold)),
                                                                        ],
                                                                      ),
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
                                                                      const Icon(
                                                                          Icons
                                                                              .date_range_outlined),
                                                                      Column(
                                                                        children: [
                                                                          Text(
                                                                            getlang(context,
                                                                                'create'),
                                                                            style:
                                                                                const TextStyle(color: Colors.black, fontSize: 10),
                                                                          ),
                                                                          Text(
                                                                            '${item.createdAt}',
                                                                            style:
                                                                                const TextStyle(color: Colors.black, fontSize: 10),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            25,
                                                                        child: IconButton(
                                                                            splashRadius: 8,
                                                                            onPressed: () {
                                                                              setState(() {
                                                                                item.isSelected = !item.isSelected!;
                                                                                if (item.isSelected == true) {
                                                                                  selectedOrder.add(Orders(id: item.id));
                                                                                } else if (item.isSelected == false) {
                                                                                  selectedOrder.removeWhere((element) => element.id == item.id);
                                                                                }
                                                                              });
                                                                            },
                                                                            icon: item.isSelected!
                                                                                ? const Icon(
                                                                                    Icons.check_box,
                                                                                    color: Colors.green,
                                                                                  )
                                                                                : const Icon(Icons.check_box_outlined)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Divider(
                                                                color: Colors
                                                                    .grey[600],
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
                                                                    '${getlang(context, 'shipper')}: ${item.sender!.name ?? ''}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black38,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    '${getlang(context, 'type')}: ${item.sender!.role ?? ''}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black38,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 2),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
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
                                                                                color: Colors.grey,
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.bold)),
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
                                                                          style: GoogleFonts.tajawal(
                                                                              color: Colors.grey,
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.bold),
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
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                              .grey[
                                                                          200],
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              var long2 = double.parse(item.sender!.lat!);
                                                                              var lut = double.parse(item.sender!.lng!);

                                                                              MapsLauncher.launchCoordinates(long2, lut, 'Google Headquarters are here');
                                                                            },
                                                                            child:
                                                                                Center(child: Lottie.asset('assets/images/location-pin.json', width: 25, height: 25)),
                                                                          ),
                                                                          Text(
                                                                            "${item.distance!.toStringAsFixed(2)} ${getlang(context, 'km')}",
                                                                            style:
                                                                                GoogleFonts.tauri(fontSize: 12.0, color: Colors.grey),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 2),
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
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Expanded(
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        elevation:
                                                                            0,
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
                                                                        backgroundColor: const Color.fromARGB(
                                                                            255,
                                                                            9,
                                                                            84,
                                                                            1),
                                                                        minimumSize: Size(
                                                                            size.width,
                                                                            38.0),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        attendance!
                                                                            ? acceptDialog(
                                                                                ctx: context,
                                                                                tokecn: token,
                                                                                orid: item.id,
                                                                                id: driverId)
                                                                            : await showAccesp();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        getlang(
                                                                            context,
                                                                            'acceptorder'),
                                                                        style: GoogleFonts.tauri(
                                                                            fontSize:
                                                                                15.5,
                                                                            color:
                                                                                Colors.green[100],
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
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
                                                    ),
                                                    // Text(item.sender!.lat!),
                                                    // Text(item.sender!.lng!),
                                                    // Text(item.receiver!.lat!),
                                                    // Text(item.totalPrice!),
                                                    // Text(item.deliveryPrice!.toString()),
                                                  ],
                                                )
                                              : Container();
                                    }))),
                        selectedOrder.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green[700]),
                                      onPressed: () {
                                        //  openwhatsapp(item.receiver!.phoneNumber!);
                                        selectedOrder.forEach((element) async {
                                          attendance!
                                              ? showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                        titlePadding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        title: Stack(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/dialog_header.png',
                                                              color:
                                                                  deepPurpleColor,
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: Center(
                                                                  child: Text(
                                                                'Accept (${selectedOrder.length}) Orders',
                                                                style: AppStyles
                                                                    .DialogTitle,
                                                              )),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Text(
                                                            'Are you sure that the Order will be (${selectedOrder.length}) accepted?',
                                                            style: GoogleFonts.tajawal(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.grey[
                                                                        800])),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Container(
                                                              width: 100,
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    deepPurpleColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0),
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .blue),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Accept',
                                                                  style: GoogleFonts.tajawal(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              StatusOrder.statuscheck(
                                                                      token:
                                                                          token,
                                                                      status:
                                                                          "Driver assigned",
                                                                      orderid:
                                                                          element
                                                                              .id,
                                                                      id:
                                                                          driverId)
                                                                  .whenComplete(
                                                                      () async => context
                                                                          .read<
                                                                              OrderBloc>()
                                                                          .add(
                                                                              LoadOrder()))
                                                                  .then((value) =>
                                                                      selectedOrder
                                                                          .clear())
                                                                  .whenComplete(() =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop());
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Container(
                                                              width: 100,
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                // color: deepPurpleColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: GoogleFonts.tajawal(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                              .grey[
                                                                          600]),
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      ))
                                              : await showAccesp();
                                        });
                                      },
                                      child: Text(
                                          'selected All (${selectedOrder.length})')),
                                ),
                              )
                            : Container()
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
      ),
    );
  }

  // Future showdi({item}) async {
  //   return attendance!
  //       ? acceptDialog(
  //           ctx: context,
  //           tokecn: token,
  //           orid: item,
  //           id: driverId,
  //         )
  //           .whenComplete(() async => {
  //                 Navigator.of(context).pop(),
  //                 context.read<OrderBloc>().add(LoadOrder()),
  //               })
  //           .then(
  //             (value) => Navigator.of(context).pop(),
  //           )
  //       : await showAccesp();
  // }

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
              .then((value) => context.read<OrderBloc>().add(LoadOrder()));
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

  String _scanBarcode = 'Unknown';
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
}
