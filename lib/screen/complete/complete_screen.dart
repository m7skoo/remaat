import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:maps_launcher/maps_launcher.dart';
import 'package:remaat/bloc/accept/accept_bloc.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/maps/map_screen.dart';
import 'package:remaat/maps/mapvew.dart';
import 'package:remaat/maps/newnew.dart';
import 'package:remaat/model/accept_model.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/screen/assept/status_driver.dart';
import 'package:remaat/screen/details/details_screen.dart';
import 'package:remaat/screen/locationorder/location_accept.dart';
import 'package:remaat/util/share_const.dart';
import 'package:remaat/widgets/timeline/timelinestate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenCompleted extends StatefulWidget {
  const ScreenCompleted({Key? key}) : super(key: key);

  @override
  State<ScreenCompleted> createState() => _ScreenCompletedState();
}

class _ScreenCompletedState extends State<ScreenCompleted> {
  final bool finsh = false;

  // final String token =
  //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMGU5MDA1NjFjMTg5MTlhODIwZGUzMjM1YWRmMGRhNzFlY2I0ZjkxZDUxMzcxNDNjYTE3NmYwNDkwMTJmNjUzMDdiZDM2NWY4YTg2ZDcxYjciLCJpYXQiOjE2NjE5NzY0NDguNzg2OTY1LCJuYmYiOjE2NjE5NzY0NDguNzg2OTY5LCJleHAiOjE2OTM1MTI0NDguNzgwMzE4LCJzdWIiOiIyMyIsInNjb3BlcyI6W119.g_3FCHgkbu_QzMRVxdx3HFlrQs-zebcMD2mPetWa9SLhxXoD0saRNgS75SXFaShuR2mjUQNgyN0554KdzUVtZ5BTuHL4E5zeqidf6DNZhuT9oTPXMKy-jm9kEjlsTa25NhUhbZz_pvJNvWXvARmXfQzi95tsIxukZGcGjR2W0gSXw-gDXh5pM_OYBD5r8cu7teNDZuTbHuj6PVjQ9j8TMk_oilpYkQkru0hlBBWcX3t9ZvlGCcKDjA8b9AjzkiB2kG1vEt9pIxmOA754hCLashfNrSrnzTVdcY_J2c_7P1-z088WReODprbCld7PdZRt2PqqIMjl_U7dpvgSRH1PAPTqoUC7mWsRWKLewxhgeVk5w4b5Es943nMy7ZrAy8hxgTPmh7Snnc67sBQUTl9303_sVeKVbJ3lOsr91x3Ve61qicA1VtSAlVXxBn9s3qSoUa3x6DygTYU-7HhNBDe5w9lAK93Y5Ua86KmcjBkQQaIv7l6albyhK-9JRGheSZed242Lu1C5BChxO3YwhR39QbR_EQ4br5P48CvpJcpY847s6ruZjOZfpGAnjhof5DlvPe0N15Drf8oZU2tOOR3iQFoxBwG3c6JSgxZlehGxejHzcXBRHVI865CDM8LkEyLio3qu0S3bhjy37269BGm7GXCcTO0LDWfpmeepKI9kubk';

  // var driverId = 1;
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
      });
      return prefs.getString(ShareConst.email)!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AcceptBloc(
          RepositoryProvider.of<GetDataFromAPI>(context), token, driverId)
        ..add(LoadAccetpt()),
      child: Scaffold(
        floatingActionButton: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.deepPurple,
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
                child: Center(child: Lottie.asset('assets/images/earth.json')

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
        appBar: AppBar(
          title: const Text("Completed Orders"),
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
                            "No Completed orders",
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
                  : Column(
                      children: [
                        Expanded(
                            child: RefreshIndicator(
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

                              return item.status == "Delivered"
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4, top: 2, bottom: 2),
                                      child: Column(
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
                                                          idOrder: item.orderId!
                                                              .toString(),
                                                          status: item.status,
                                                          namesender:
                                                              item.sender!.name,
                                                          phonenumbersen: item
                                                              .sender!
                                                              .phoneNumber!,
                                                          namereseriver: item
                                                              .receiver!.name!,
                                                          phonenumberres: item
                                                              .receiver!
                                                              .phoneNumber,
                                                          latsender:
                                                              item.sender!.lat!,
                                                          lutsender:
                                                              item.sender!.lng,
                                                          latres: item
                                                              .receiver!.lat,
                                                          lutres: item
                                                              .receiver!.lng,
                                                          citysen:
                                                              item.sender!.city,
                                                          areasen:
                                                              item.sender!.area,
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
                                                          dropOff: item.dropOff,
                                                          pickup: item.pickUp,
                                                          reference: item.reference.toString())));
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 5,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(2),
                                                    topRight:
                                                        Radius.circular(2),
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Order Id: ${item.orderId}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                                      'create'),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                                Text(
                                                                  '${item.createdAt}',
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
                                                    const Divider(
                                                      color: Colors.blue,
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
                                                          'Shipper: ${item.sender!.name}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          "Type: ${item.sender!.role}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    const Divider(),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          getlang(context,
                                                              'delivered'),
                                                          style: GoogleFonts
                                                              .tajawal(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        const Icon(
                                                          Icons
                                                              .check_circle_outline,
                                                          color: Colors.green,
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
                                    )
                                  : Container();
                            },
                          ),
                        ))
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
      ),
    );
  }
}
