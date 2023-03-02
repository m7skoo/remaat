import 'dart:io';

import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:haversine_distance/haversine_distance.dart';
import 'package:lottie/lottie.dart';

import 'package:maps_launcher/maps_launcher.dart';
import 'package:remaat/bloc/accept/accept_bloc.dart';
import 'package:remaat/const/padd.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/maps/direction_repository.dart';
import 'package:remaat/maps/map_screen.dart';
import 'package:remaat/model/accept_model.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/repository/globals.dart';
import 'package:remaat/screen/assept/status_driver.dart';
import 'package:remaat/screen/assept/status_driver_qr.dart';
import 'package:remaat/screen/details/details_screen.dart';
import 'package:remaat/screen/locationorder/location_accept.dart';
import 'package:remaat/screen/search/search_screen.dart';
import 'package:remaat/util/colors.dart';
import 'package:remaat/util/design/colors.dart';
import 'package:remaat/util/share_const.dart';
import 'package:remaat/widgets/location/mylocation.dart';
import 'package:remaat/widgets/timeline/timelinestate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:location/location.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenAssept extends StatefulWidget {
  const ScreenAssept({Key? key}) : super(key: key);

  @override
  State<ScreenAssept> createState() => _ScreenAsseptState();
}

class _ScreenAsseptState extends State<ScreenAssept> {
  final _debouncer = Debouncer();
  List<AcceptOrder> allorders = [];
  List<AcceptOrder> searchorder = [];
  bool _isSearching = false;
  final _searchController = TextEditingController();
  final bool finsh = false;

  String pass = '';
  String email = '';
  String token = '';
  int driverId = 1;

  final Location location = Location();
  LatLng? currentLatLng;

  // LocationData? _currentPosition;
  String? _address;
  bool isfoundLocat = false;
  List<AcceptOrder> selectedOrder = [];

  @override
  void initState() {
    searchorder = [];
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        email = prefs.getString(ShareConst.email).toString();

        token = prefs.getString(ShareConst.token).toString();
        driverId = prefs.getInt(ShareConst.driverId)!;
      });
      return prefs.getString(ShareConst.email)!;
    });
    // setState(() {
    maplocation();
    // });
    // fetchLocation();

    // kmMap();
    super.initState();
  }

  // GetDataFromAPI _getDataFromAPI = GetDataFromAPI();
  // Stream<List<AcceptOrder>> get kmtOrder async* {
  //   yield await _getDataFromAPI.getDataAccept(token, driverId);
  // }

  // fetchLocation() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   // _currentPosition = await location.getLocation();
  //   location.onLocationChanged.listen((LocationData currentLocation) {
  //     setState(() {
  //       // _currentPosition = currentLocation;

  //       // final datalocation =
  //       //     LatLng(currentLocation.latitude!, currentLocation.longitude!);
  //       currentLocation.time;

  //       if (datalocation != null) {
  //         setState(() {
  //           isfoundLocat == true;
  //         });
  //       } else {}
  //       // getAddress(_currentPosition!.latitude!, _currentPosition!.longitude!)
  //       //     .then((value) {
  //       //   setState(() {
  //       //     _address = "＄{value.first.addressLine}";
  //       //   });
  //       // });
  //     });
  //   });
  // }

  // Future<List<Address>> getAddress(double lat, double lang) async {
  //   final coordinates = Coordinates(lat, lang);
  //   List<Address> address =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   return address;
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

  // var count = 0;
  // String? constdata;
  // void kmMap() async {
  //   await kmtOrder.forEach((data) async {
  //     for (var element in data) {
  //       final lat = double.parse(element.sender!.lat!);
  //       final lag = double.parse(element.sender!.lng!);
  //       final latr = double.parse(element.receiver!.lat!);
  //       final lagr = double.parse(element.receiver!.lng!);
  //       // print(lat + lag);

  //       final startCoordinate = LatLng(lat, lag);
  //       final endCoordinate = LatLng(latr, lagr);

  //       setState(() {
  //         constdata = element.status!;

  //         data.length;
  //       });

  //       // await getDirections(
  //       //     LatLng(l.latitude, l.longitude), LatLng(latr, lagr));

  //       // mapsde(startCoordinate, endCoordinate);
  //     }
  //   });
  // }

  // var currentLocation = myLocation;
  //   dynamic coordinates =
  //       new Coordinates(myLocation.latitude, myLocation.longitude);

  // mapsde({required lat, required lag, required latres, required lagres}) async {
  //   await DirectionsRepository()
  //       .getDirections(lat: lat, lag: lag, latres: latres, lagres: lagres)
  //       .then((value) {
  //     setState(() {
  //       km = value!.totalDistance;
  //       print(km);
  //     });
  //   });
  //   return km;
  // }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

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
        // autocorrect: true,
        // enableIMEPersonalizedLearning: true,
        // enableSuggestions: true,

        // enableInteractiveSelection: true,
        style: const TextStyle(height: 1.0, color: Colors.black),
        autofocus: true,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: InputBorder.none,
            // prefixIcon: const Icon(Icons.search_outlined),
            hintText: getlang(context, 'search'),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            disabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(18),
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
      style: GoogleFonts.tajawal(
        color: Colors.grey,
      ),
    );
  }

  bool isnearly = false;
  bool isShedual = true;

  var sortorder = [
    "All",
    "Driver assigned",
    "Driver on his way",
    "Arrive",
    "Picked up",
    "Out for delivery",
    "Delivered",
    "Returned"
  ];

  String? sortorders = '';
  bool isselectd = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // var ll = sortorders.splitMapJoin(sortorder.toString());

    return BlocProvider(
      create: (context) => AcceptBloc(
          RepositoryProvider.of<GetDataFromAPI>(context), token, driverId)
        ..add(LoadAccetpt()),
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
                                  builder: (context) => MainMapScreenMap()));
                        },
                        child: Center(
                            child: Lottie.asset('assets/images/earth.json')

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
                              builder: (context) => StatsScreenQR(
                                    resultQR: _scanBarcode,
                                  ))));
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
          title: _isSearching
              ? _buildsearchField()
              : Text("Accept's Orders",
                  style: GoogleFonts.tauri(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
          // centerTitle: true,
          backgroundColor: Color.fromARGB(0, 234, 216, 216),
          elevation: 0,
          actions: [
            // IconButton(
            //     onPressed: () async {
            //       context.read<AcceptBloc>().add(LoadAccetpt());
            //     },
            //     icon: Icon(Icons.refresh_outlined)),
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
                      IconButton(
                          onPressed: () {
                            scanQR().whenComplete(() => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StatsScreenQR(
                                          resultQR: _scanBarcode,
                                        ))));
                          },
                          icon: const Icon(Icons.qr_code_2_outlined)),
                      IconButton(
                          onPressed: () {
                            showMapLocation();
                          },
                          icon: const Icon(Icons.location_history)),
                    ],
                  ),
          ],
        ),
        body: isfoundLocat
            ? Center(
                child: Column(
                  children: [
                    padd20,
                    padd20,
                    padd20,
                    const Icon(
                      Icons.location_off_outlined,
                      size: 80,
                    ),
                    padd20,
                    Text(
                      '!لم نتمكن من الوصول لموقعك \n \n يرجاء تفعيل الموقع',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            : BlocListener<AcceptBloc, AcceptState>(
                listener: (context, state) {
                  if (state is AcceptLoadedState) {
                    allorders = state.data;

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text("To Do Added Successfuly"),
                    //   ),
                    // );
                  }
                },
                child: BlocBuilder<AcceptBloc, AcceptState>(
                  builder: (context, state) {
                    if (state is AcceptLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is AcceptLoadedState) {
                      allorders = state.data;

                      var countmain = allorders.length;

                      return state.data.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SingleChildScrollView(
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
                                            backgroundColor: Colors.deepPurple,
                                            minimumSize:
                                                Size(size.width / 2, 40)),
                                        onPressed: () async {
                                          context
                                              .read<AcceptBloc>()
                                              .add(LoadAccetpt());
                                          // GetOrder.getOrder(token);
                                        },
                                        child: const Text(
                                          "Reload",
                                          style: TextStyle(fontSize: 18),
                                        ))
                                  ],
                                )),
                              ),
                            )
                          : Column(
                              children: [
                                padd3,
                                // constdata == "Delivered"
                                //     ? Container()
                                //     :
                                Text(
                                  'عدد الطلبات :${countmain.toString()}',
                                  style: GoogleFonts.tajawal(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                            const Duration(
                                                                seconds: 1),
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4.0,
                                                              left: 4.0),
                                                      child: Text(
                                                        getlang(
                                                            context, 'fast'),
                                                        style:
                                                            GoogleFonts.tajawal(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                        // backgroundColor:
                                                        // isShedual == false
                                                        //     ? Color.fromARGB(
                                                        //         255, 71, 5, 184)
                                                        //     : null,
                                                        animationDuration:
                                                            const Duration(
                                                                seconds: 1),
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4.0,
                                                              left: 4.0),
                                                      child: Text(
                                                        getlang(context,
                                                            'scheduled'),
                                                        style: GoogleFonts.tajawal(
                                                            // color: isShedual ==
                                                            //         false
                                                            //     ? Colors.white
                                                            //     : Colors
                                                            //         .deepPurple,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 33,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Stack(
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
                                                            const Duration(
                                                                seconds: 2),
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7.0),
                                                            side: BorderSide
                                                                .none)),
                                                    onPressed: () {
                                                      setState(() {
                                                        isnearly = !isnearly;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4.0,
                                                              left: 4.0),
                                                      child: Text(
                                                        getlang(
                                                            context, 'Nearby'),
                                                        style:
                                                            GoogleFonts.tajawal(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    )),
                                              ],
                                            ),

                                            //sort for state
                                            PopupMenuButton(
                                                icon: const Icon(
                                                    Icons.sort_outlined),
                                                initialValue: sortorders,
                                                onSelected: (String? value) {
                                                  setState(() {
                                                    isselectd = true;
                                                    sortorders = value!;
                                                    if (sortorders == 'All') {
                                                      setState(() {
                                                        isselectd = false;
                                                      });
                                                    }
                                                    print(sortorders);
                                                  });
                                                },
                                                itemBuilder: (context) =>
                                                    sortorder
                                                        .map(
                                                          (e) => PopupMenuItem(
                                                            value: e,
                                                            child: Text(
                                                                e.toString()),
                                                          ),
                                                        )
                                                        .toList()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                padd3,
                                Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async => context
                                        .read<AcceptBloc>()
                                        .add(LoadAccetpt()),
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
                                            (a, b) => isnearly
                                                ? a.distance!
                                                    .compareTo(b.distance!)
                                                : b.id!.compareTo(a.id!),
                                          );
                                        var itemx = sortitemkm[index];
                                        var item =
                                            _searchController.text.isEmpty
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

                                        // if (distance < 4.67) {
                                        //   setState(() {
                                        //     // print(item.orderId);
                                        //     // errorSnaokBar(context, 'there order',
                                        //     //     Colors.green);
                                        //   });
                                        // }

                                        // if (item.status == "Delivered") {
                                        //   setState(() {
                                        //     iitem.length = count;
                                        //   });
                                        // }

                                        if (isShedual) {
                                          if (item.status == "Delivered" ||
                                              item.status == "Cancelled") {
                                            return Container();
                                          } else {
                                            return isselectd == false
                                                ? CardIm(context, item, size)
                                                : item.status == sortorders
                                                    ? CardIm(
                                                        context, item, size)
                                                    : Container();
                                          }
                                        } else {
                                          if (item.pickUpDate != '') {
                                            if (item.status == "Delivered" ||
                                                item.status == "Cancelled") {
                                              return Container();
                                            } else {
                                              return isselectd == false
                                                  ? cardorderSh(
                                                      context, item, size)
                                                  : item.status == sortorders
                                                      ? CardIm(
                                                          context, item, size)
                                                      : Container();
                                            }
                                          } else {
                                            return Container();
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                selectedOrder.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 10),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.green[700]),
                                              onPressed: () {
                                                //  openwhatsapp(item.receiver!.phoneNumber!);
                                                selectedOrder
                                                    .forEach((element) {
                                                  StatusOrder.statuscheck(
                                                          token: token,
                                                          status:
                                                              "Driver on his way",
                                                          orderid: element.id,
                                                          id: driverId)
                                                      .whenComplete(() async =>
                                                          context
                                                              .read<
                                                                  AcceptBloc>()
                                                              .add(
                                                                  LoadAccetpt()))
                                                      .then((value) =>
                                                          selectedOrder
                                                              .clear());
                                                });
                                              },
                                              child: Text(
                                                  'selected ${selectedOrder.length}')),
                                        ),
                                      )
                                    : Container()
                              ],
                            );
                    }
                    if (state is AcceptErrorState) {
                      return Container(
                        padding: const EdgeInsets.all(30.0),
                        margin: const EdgeInsets.only(top: 200, bottom: 30),
                        child: Center(
                          child: Column(
                            children: [
                              const Text(
                                  'Somthing error please try again later'),
                              const SizedBox(height: 15.0),
                              TextButton(
                                  onPressed: () {
                                    context
                                        .read<AcceptBloc>()
                                        .add(LoadAccetpt());
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
              ),
      ),
    );
  }

  Padding CardIm(BuildContext context, AcceptOrder item, Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                          id: item.id,
                          isnotcomplete: true,
                          issho: false,
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
                          typesen: item.sender!.role,
                          paymentMethod: item.paymentMethod,
                          namereseriver: item.receiver!.name,
                          typeres: item.receiver!.role,
                          cityres: item.receiver!.city,
                          areares: item.receiver!.area,
                          streatres: item.receiver!.street,
                          sername: item.package!.service!.name,
                          boccount: item.boxCount,
                          itemvalue: item.totalPrice,
                          weight: item.sHWeight,
                          packagename: item.package!.name,
                          dropOff: item.dropOff,
                          pickup: item.pickUp,
                          reference: item.reference.toString())));
            },
            child: Card(
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
                padding:
                    const EdgeInsets.only(left: 6, right: 6, top: 5, bottom: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Order Id: ${item.orderId}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            padd10,
                            Text("Reference: ${item.reference.toString()}",
                                style: GoogleFonts.tajawal(color: Colors.grey)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.date_range_outlined),
                            Column(
                              // mainAxisAlignment:
                              //     MainAxisAlignment
                              //         .start,
                              // crossAxisAlignment:
                              //     CrossAxisAlignment
                              //         .start,
                              children: [
                                Text(
                                  getlang(context, 'create'),
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 10),
                                ),
                                Text(
                                  '${item.createdAt}',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                              ],
                            ),
                            // IconButton(
                            //     splashRadius:
                            //         15,
                            //     onPressed:
                            //         () {
                            //       setState(
                            //           () {
                            //         item.isSelected =
                            //             !item.isSelected!;
                            //         if (item.isSelected ==
                            //             true) {
                            //           selectedOrder.add(AcceptOrder(id: item.id));
                            //         } else if (item.isSelected ==
                            //             false) {
                            //           selectedOrder.removeWhere((element) => element.id == item.id);
                            //         }
                            //       });
                            //     },
                            //     icon: item.isSelected!
                            //         ? const Icon(
                            //             Icons.check_box,
                            //             color: Colors.green,
                            //           )
                            //         : const Icon(Icons.check_box_outlined))
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.blue,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${getlang(context, 'shipper')}:${item.sender!.name}",
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "${getlang(context, 'type')}: ${item.sender!.role}",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${item.distance!.toStringAsFixed(2)} ${getlang(context, 'km')}",
                              style: GoogleFonts.tauri(
                                  fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    RichText(
                        text: TextSpan(
                            text: '${item.sender!.street ?? ''}  ',
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
                            text: '${item.sender!.buildingNumber ?? ''}  ',
                            style: const TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                    padd5,
                    const Divider(height: 2),
                    padd3,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(),
                        item.status! == 'Delivered'
                            ? Text(
                                getlang(context, 'delivered'),
                                style: GoogleFonts.tajawal(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            : item.status == 'Driver assigned'
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(14),
                                                bottomRight:
                                                    Radius.circular(14))),
                                        backgroundColor: const Color.fromARGB(
                                            255, 105, 133, 147),
                                        minimumSize: Size(size.width, 45)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NewScreenAssept(id: item.id!),
                                        ),
                                      );

                                      // orders();
                                    },
                                    child: Text(
                                      getlang(context, 'startdelivery'),
                                      style: GoogleFonts.tauri(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(14),
                                                bottomRight:
                                                    Radius.circular(14))),
                                        backgroundColor: const Color.fromARGB(
                                            255, 98, 187, 101),
                                        minimumSize: Size(size.width, 43)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NewScreenAssept(id: item.id!),
                                        ),
                                      );

                                      // orders();
                                    },
                                    child: Text(
                                      item.status!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Padding cardorderSh(BuildContext context, AcceptOrder item, Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                          id: item.id,
                          isnotcomplete: true,
                          issho: false,
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
                          typesen: item.sender!.role,
                          paymentMethod: item.paymentMethod,
                          namereseriver: item.receiver!.name,
                          typeres: item.receiver!.role,
                          cityres: item.receiver!.city,
                          areares: item.receiver!.area,
                          streatres: item.receiver!.street,
                          sername: item.package!.service!.name,
                          boccount: item.boxCount,
                          itemvalue: item.totalPrice,
                          weight: item.sHWeight,
                          packagename: item.package!.name,
                          dropOff: item.dropOff,
                          pickup: item.pickUp,
                          reference: item.reference.toString())));
            },
            child: Card(
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
                padding:
                    const EdgeInsets.only(left: 6, right: 6, top: 5, bottom: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Order Id: ${item.orderId}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            padd5,
                            Text("Reference: ${item.reference.toString()}",
                                style: GoogleFonts.tajawal(
                                    color: Colors.grey[800])),
                            Text("PickUp Date: ${item.pickUp.toString()}",
                                style: GoogleFonts.tajawal(
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.date_range_outlined),
                            Column(
                              // mainAxisAlignment:
                              //     MainAxisAlignment
                              //         .start,
                              // crossAxisAlignment:
                              //     CrossAxisAlignment
                              //         .start,
                              children: [
                                Text(
                                  getlang(context, 'create'),
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 10),
                                ),
                                Text(
                                  '${item.createdAt}',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                              ],
                            ),
                            // IconButton(
                            //     splashRadius:
                            //         15,
                            //     onPressed:
                            //         () {
                            //       setState(
                            //           () {
                            //         item.isSelected =
                            //             !item.isSelected!;
                            //         if (item.isSelected ==
                            //             true) {
                            //           selectedOrder.add(AcceptOrder(id: item.id));
                            //         } else if (item.isSelected ==
                            //             false) {
                            //           selectedOrder.removeWhere((element) => element.id == item.id);
                            //         }
                            //       });
                            //     },
                            //     icon: item.isSelected!
                            //         ? const Icon(
                            //             Icons.check_box,
                            //             color: Colors.green,
                            //           )
                            //         : const Icon(Icons.check_box_outlined))
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.blue,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${getlang(context, 'shipper')}:${item.sender!.name}",
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "${getlang(context, 'type')}: ${item.sender!.role}",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${item.distance!.toStringAsFixed(2)} ${getlang(context, 'km')}",
                              style: GoogleFonts.tauri(
                                  fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    RichText(
                        text: TextSpan(
                            text: '${item.sender!.street ?? ''}  ',
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
                            text: '${item.sender!.buildingNumber ?? ''}  ',
                            style: const TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                    padd5,
                    const Divider(height: 2),
                    padd3,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(),
                        item.status! == 'Delivered'
                            ? Text(
                                getlang(context, 'delivered'),
                                style: GoogleFonts.tajawal(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            : item.status == 'Driver assigned'
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(14),
                                                bottomRight:
                                                    Radius.circular(14))),
                                        backgroundColor: const Color.fromARGB(
                                            255, 105, 133, 147),
                                        minimumSize: Size(size.width, 45)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NewScreenAssept(id: item.id!),
                                        ),
                                      );

                                      // orders();
                                    },
                                    child: Text(
                                      getlang(context, 'startdelivery'),
                                      style: GoogleFonts.tauri(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(14),
                                                bottomRight:
                                                    Radius.circular(14))),
                                        backgroundColor: const Color.fromARGB(
                                            255, 98, 187, 101),
                                        minimumSize: Size(size.width, 43)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NewScreenAssept(id: item.id!),
                                        ),
                                      );

                                      // orders();
                                    },
                                    child: Text(
                                      item.status!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
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
      ),
    );
  }

  void showMapLocation() {
    var size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              titlePadding: const EdgeInsets.all(0),
              // title: Text('data'),
              content: SizedBox(
                height: size.height * 0.6,
                width: size.width,
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: const MapActivity()),
                  ],
                ),
              ),
            ));
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (!await launchUrl(whatsappURlandroid)) {
        await launchUrl(whatsappURlandroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    }
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
