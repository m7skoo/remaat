import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:remaat/bloc/order/order_bloc.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/model/order_model.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/screen/assept/assetp_screen.dart';
import 'package:remaat/util/colors.dart';
import 'package:remaat/util/design/app_bar_design.dart';
import 'package:remaat/util/design/colors.dart';
import 'package:remaat/util/design/loadin.dart';
import 'package:remaat/util/share_const.dart';
import 'package:remaat/util/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LocationOrder extends StatefulWidget {
  String? token;
  int? driverId;
  LocationOrder({Key? key, this.token, this.driverId}) : super(key: key);
  @override
  _LocationOrderState createState() => _LocationOrderState();
}

class _LocationOrderState extends State<LocationOrder>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _controller;

  List<Marker> allMarkers = [];

  PageController? _pageController;
  // String token =
  //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMjBhNDljYTJhNjI1NzI1ZjVhODU5MzJiOWVhMThjZWZlOWJjNTU3ZDBlMWU1NjhlYTYzODJhZDU5YzFiMjhmNGE2MTAwYjdlZWEwMWRjNjkiLCJpYXQiOjE2NjE4ODY5NDEuMDA3NDI0LCJuYmYiOjE2NjE4ODY5NDEuMDA3NDI2LCJleHAiOjE2OTM0MjI5NDEuMDA2MDI0LCJzdWIiOiIyMyIsInNjb3BlcyI6W119.BEVkY6oJK8odaIHDzZZqo-cmJQQoMktxIVFsjIYDfK-VqsOKopwOnQ8XoUhQ9tY7R7InFF1xrxCN5ry959bnS9kQEYgpkbmkZ80faVNIMwrhr1QrBXe2XUNb2HmgqvB7vcD-LiRDoyBy-Ty9yMzhf_a7Is1UgwJU4wIKWLfJ7myzwzlKgiclM2dUkKoMVOSi78rJAi6HYDz_CPI2AQdRELBsZ74Xu8aeUieOFa4fOAjGWqYZyN4ZcWjdkKL373_o0irJPw2irDRcWYXHkTKLmAFfbTe8cx32awTz3iJeD2n8snp5GJoGtbbnsq-Y5FI35MJPf4DRTnzvpkuLp-U7Mznkm8zpWR_zysAlaeRme182iub385GFNyHEBnvRuP9DGUR25nINPFkhQUNjLscUAgfiU_GVUzYFR3mg7jRNUkKt9sv0d9zz4Qz3aKudZNiju4YrSsFURsZlPk34SzQ9XVXdbzSMrSbOmZdYgeW0bf2FCcEK94vHHG9UNByz5ZoU3rMym_bL0gVS6IIYO7cJ_9ehP3-tN50-6BexBW7MdakCqJfL-kmc_mp8I4vICPiCdsvITn7X-g0Yb8htuEiDt2JXrQHcQ29Ho8FaeVV1Mp7kzKlOFkTK7nfyasYTguQnk82zShAq2idxD2LJMPZYKvSjFANT0jMtT30YLHG-5FA';
  Future<String>? _getUsername;
  int? prevPage;
  BitmapDescriptor? mark;

  void setcustomerMar() async {
    mark = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/images/PC.png');
  }

  GetDataFromAPI getDataFromAPI = GetDataFromAPI();
  Stream<List<Orders>> get contactOrder async* {
    yield await getDataFromAPI.getData(token);
  }

  void _onScroll() {
    if (_pageController!.page!.toInt() != prevPage) {
      prevPage = _pageController!.page!.toInt();
      moveCamera();
    }
  }

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
    contactOrder.forEach((data) {
      for (var element in data) {
        print('addddd${element.id}');
        LatLng locatio =
            //  LatLng(24.7136, 46.6753);
            LatLng(double.parse('${element.sender!.lat}'),
                double.parse('${element.sender!.lng}'));
        print('lll $locatio');
        setState(() {
          allMarkers.add(Marker(
              // zIndex: 150.0,
              markerId: MarkerId(element.orderId.toString()),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              draggable: false,
              infoWindow: InfoWindow(
                  title: '#${element.orderId.toString()}',
                  // anchor: element.sender!.area!,
                  onTap: () {},
                  snippet: element.sender!.area!),
              position: locatio));
        });
      }
    });
    // });

    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) =>
          OrderBloc(RepositoryProvider.of<GetDataFromAPI>(context), token)
            ..add(LoadOrder()),
      child: Scaffold(
        appBar: appBarDesign('New orders'),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoadingState) {
              return const LoadingConst();
            }
            if (state is OrderLoadedState) {
              List<Orders> iitem = state.data;

              return state.data.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                      child: Center(
                          child: Column(
                        children: [
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
                                  primary: Colors.deepPurple,
                                  minimumSize: Size(size.width / 2, 40)),
                              onPressed: () async {
                                context.read<OrderBloc>().add(LoadOrder());
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 50.0,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            zoomGesturesEnabled: true,
                            myLocationEnabled: true,
                            zoomControlsEnabled: true,
                            initialCameraPosition: const CameraPosition(
                                target: LatLng(24.7136, 46.6753), zoom: 12.0),
                            markers: Set.from(allMarkers),
                            onMapCreated: mapCreated,
                          ),
                        ),
                        Positioned(
                          bottom: 20.0,
                          child: SizedBox(
                            height: 150.0,
                            width: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                              physics: const ScrollPhysics(),
                              controller: _pageController,
                              itemCount: iitem.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item = iitem[index];
                                return AnimatedBuilder(
                                  animation: _pageController!,
                                  builder:
                                      (BuildContext context, Widget? widget) {
                                    double value = 1;
                                    if (_pageController!
                                        .position.haveDimensions) {
                                      value = (_pageController!.page! - index);
                                      value = (1 - (value.abs() * 0.3) + 0.06)
                                          .clamp(0.0, 1.0);
                                    }
                                    return Center(
                                      child: SizedBox(
                                        height:
                                            Curves.easeInOut.transform(value) *
                                                125.0,
                                        width:
                                            Curves.easeInOut.transform(value) *
                                                350.0,
                                        child: widget,
                                      ),
                                    );
                                  },
                                  child: InkWell(
                                      onTap: () {
                                        moveCamera();
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Stack(children: [
                                              Center(
                                                  child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10.0,
                                                        // vertical: 20.0,
                                                      ),
                                                      height: 125.0,
                                                      width: 275.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color:
                                                                  primaryColor,
                                                              offset: Offset(
                                                                  0.0, 4.0),
                                                              blurRadius: 10.0,
                                                            ),
                                                          ]),
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color:
                                                                  whiteColor),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
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
                                                                    Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceEvenly,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            '# ${item.orderId} ',
                                                                            style:
                                                                                const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text(
                                                                            item.sender!.name!,
                                                                            style:
                                                                                const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                                                                          ),
                                                                          // SizedBox(
                                                                          //   // width: 170.0,
                                                                          //   child:
                                                                          //       Text(
                                                                          //     '${item.sender!.city!} , ${item.sender!.area!}',
                                                                          //     style: const TextStyle(
                                                                          //         fontSize:
                                                                          //             11.0,
                                                                          //         fontWeight:
                                                                          //             FontWeight.w300),
                                                                          //   ),
                                                                          // )
                                                                        ]),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
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
                                                                              color: primaryColor,
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
                                                                              color: accentColor,
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
                                                              ]))))
                                            ]),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  minimumSize: Size(
                                                      size.width * 0.7, 40),
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(16),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      16)))),
                                              onPressed: () {
                                                acceptDialog(
                                                    ctx: context,
                                                    tokecn: widget.token,
                                                    orid: item.id,
                                                    id: widget.driverId);
                                              },
                                              child: Text(getlang(
                                                  context, 'acceptorder')))
                                        ],
                                      )),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    );
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

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  _callNumber(String numb) async {
    // const  number = widget.phonenumber; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber('0${numb}');
    return res;
  }

  moveCamera() {
    contactOrder.forEach((data) {
      for (var element in data) {
        print(element.sender!.location);
        _controller!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: data[_pageController!.page!.toInt()].sender!.location!,
                zoom: 12.0,
                bearing: 45.0,
                tilt: 45.0)));
      }
    });
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
