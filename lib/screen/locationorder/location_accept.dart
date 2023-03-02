import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;

import 'package:maps_launcher/maps_launcher.dart';
import 'package:remaat/bloc/accept/accept_bloc.dart';
import 'package:remaat/model/accept_model.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/screen/details/details_screen.dart';
import 'package:remaat/screen/locationorder/utils.dart';
import 'package:remaat/util/share_const.dart';
import 'package:remaat/widgets/loadin.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

const LatLng _center = const LatLng(24.7136, 46.6753);
LatLng? newPosition;
CameraPosition newCameraPosition =
    const CameraPosition(target: LatLng(24.7136, 46.6753), zoom: 10);

Set<Marker> markers = {};
int? _index = 0;
int? indexMarker;
ValueNotifier valueNotifier = ValueNotifier(indexMarker);

//*********StatefulWidget */
class MainMapScreenMap extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainMapScreenMap> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
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
    getMarkers();
    setCustomMapPin();
    super.initState();
  }

  BitmapDescriptor? pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controllermap = Completer();

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void getMarkers() async {
    final Uint8List userMarkerIcon =
        await getBytesFromAsset('assets/images/pngegg1.png', 100);

    final Uint8List selectedMarkerIcon =
        await getBytesFromAsset('assets/images/pngegg.png', 200);

    markers = {};

    contactOrder.forEach((data) {
      for (var element in data) {
        LatLng locatio =
            //  LatLng(24.7136, 46.6753);
            LatLng(double.parse('${element.sender!.lat}'),
                double.parse('${element.sender!.lng}'));

        setState(() {
          if (element.id == indexMarker) {
            markers.add(Marker(
                draggable: false,
                markerId: MarkerId(element.orderId.toString()),
                icon: BitmapDescriptor.fromBytes(selectedMarkerIcon),
                infoWindow: InfoWindow(
                    title: '#${element.orderId.toString()}',
                    // anchor: element.sender!.area!,
                    onTap: () {},
                    snippet: element.sender!.area!),
                position: locatio));
          } else {
            markers.add(Marker(
                draggable: false,
                markerId: MarkerId(element.orderId.toString()),
                icon: BitmapDescriptor.fromBytes(userMarkerIcon),
                infoWindow: InfoWindow(
                    title: '#${element.orderId.toString()}',
                    // anchor: element.sender!.area!,
                    onTap: () {},
                    snippet: element.sender!.area!),
                position: locatio));
          }
        });
      }
    });

    valueNotifier.value = indexMarker;
  }

  final GetDataFromAPI getDataFromAPI = GetDataFromAPI();
  Future<String>? _getUsername;
  Stream<List<AcceptOrder>> get contactOrder async* {
    yield await getDataFromAPI.getDataAccept(token, driverId);
  }

  //******** OnMapCreated */
  void _onMapCreated(GoogleMapController controller) {
    // controller.setMapStyle(Utils.mapStyles);
    mapController = controller;
    _controller.complete(controller);
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
          title: const Text('Accept orders'),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: BlocBuilder<AcceptBloc, AcceptState>(
          builder: (context, state) {
            if (state is AcceptLoadingState) {
              return const Center(
                child: LoadingConst(),
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
                  : Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: ValueListenableBuilder(
                              valueListenable:
                                  valueNotifier, // that's the value we are listening to
                              builder: (context, value, child) {
                                return GoogleMap(
                                    zoomControlsEnabled: true,
                                    markers: markers,
                                    myLocationEnabled: true,
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: const CameraPosition(
                                      target: _center,
                                      zoom: 11.0,
                                    ));
                              }),
                        ),
                        // Here is tha PageView Builder
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: SizedBox(
                                height: 120, // card height
                                child: PageView.builder(
                                  itemCount: iitem.length,
                                  controller:
                                      PageController(viewportFraction: 0.9),
                                  onPageChanged: (int index) {
                                    setState(() => _index = index);
                                    indexMarker = iitem[index].id;
                                    var item = iitem[index];
                                    if (item.sender!.location != null) {
                                      newPosition = item.sender!.location;
                                      newCameraPosition = CameraPosition(
                                          target: newPosition!, zoom: 15);
                                    }
                                    getMarkers();
                                    mapController!
                                        .animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                newCameraPosition))
                                        .then((val) {
                                      setState(() {});
                                    });
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item = iitem[index];
                                    return Transform.scale(
                                      scale: index == _index ? 1 : 0.9,
                                      child: Container(
                                        height: 125.00,
                                        // width: 260.00,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffffffff),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: const Offset(0.5, 0.5),
                                              color: const Color(0xff000000)
                                                  .withOpacity(0.12),
                                              blurRadius: 20,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10.00),
                                        ),
                                        child: InkWell(
                                            onTap: () {
                                              // moveCamera();
                                            },
                                            child: Column(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.start,
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                        height: 80.0,
                                                        width: 250.0,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color:
                                                                Colors.white),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Flexible(
                                                                flex: 1,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                        height:
                                                                            90.0,
                                                                        width:
                                                                            60.0,
                                                                        decoration: const BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.only(bottomLeft: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
                                                                            image: DecorationImage(image: AssetImage('assets/images/PC.png'), fit: BoxFit.cover))),
                                                                    const SizedBox(
                                                                        width:
                                                                            5.0),
                                                                    Expanded(
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              '# ${item.orderId}',
                                                                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              item.sender!.name!,
                                                                              style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                                                                            ),
                                                                            SizedBox(
                                                                              // width: 170.0,
                                                                              child: Text(
                                                                                '${item.sender!.city!} , ${item.sender!.area!}',
                                                                                style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w300),
                                                                              ),
                                                                            )
                                                                          ]),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        1.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Flexible(
                                                                      flex: 1,
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        child: IconButton(
                                                                            color: Colors.blue[800],
                                                                            onPressed: () {
                                                                              _callNumber(item.sender!.phoneNumber!);
                                                                            },
                                                                            icon: const Icon(
                                                                              Icons.call,
                                                                              size: 18,
                                                                            )),
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      flex: 1,
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        child: IconButton(
                                                                            color: Colors.orange,
                                                                            onPressed: () {
                                                                              var long2 = double.parse(item.sender!.lat!);
                                                                              var lut = double.parse(item.sender!.lng!);

                                                                              MapsLauncher.launchCoordinates(long2, lut, 'Google Headquarters are here');
                                                                            },
                                                                            icon: const Icon(
                                                                              Icons.location_on,
                                                                              size: 18,
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ])),
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    18),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    18)),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .green,
                                                                minimumSize: Size(
                                                                    size.width *
                                                                        0.7,
                                                                    35)),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => DetailsScreen(
                                                                      dropOff: item
                                                                          .dropOff,
                                                                      pickup: item
                                                                          .pickUp,
                                                                      isnotcomplete:
                                                                          true,
                                                                      id: item
                                                                          .id,
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
                                                                      citysen: item.sender!.city,
                                                                      areasen: item.sender!.area,
                                                                      streatsen: item.sender!.street,
                                                                      totalprice: item.total_Price!.toDouble(),
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
                                                                      namereseriver: item.receiver!.name,
                                                                      reference: item.reference.toString())));
                                                        },
                                                        child: const Text(
                                                            'Details')),
                                                  ),
                                                ])),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ))
                      ],
                    );
            } else {
              return Center(
                  child: Column(
                children: [
                  Image.asset(
                    'assets/images/emptyorder1.png',
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          minimumSize: Size(size.width / 2, 40)),
                      onPressed: () {
                        setState(() {
                          // GetOrder.getOrder(token);
                        });
                        // GetOrder.getOrder(token);
                      },
                      child: const Text(
                        ' Reload ',
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              ));
            }
          },
        ),
      ),
    );
  }

  _callNumber(String numb) async {
    // const  number = widget.phonenumber; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber('0${numb}');
    return res;
  }
}
