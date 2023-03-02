// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:maps_launcher/maps_launcher.dart';
// import 'package:remaat/Drawer/My_Drawer_Admin.dart';
// import 'package:remaat/bloc/order/order_bloc.dart';

// import 'package:remaat/model/order_model.dart';
// import 'package:remaat/notification/local_notification_service.dart';
// import 'package:remaat/repository/data_controller.dart';
// import 'package:remaat/screen/assept/assetp_screen.dart';
// import 'package:remaat/screen/details/details_screen.dart';
// import 'package:remaat/util/colors.dart';
// import 'package:remaat/util/styles.dart';
// import 'package:remaat/widgets/colors.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LucationOrder extends StatefulWidget {
//   const LucationOrder({Key? key}) : super(key: key);

//   @override
//   State<LucationOrder> createState() => _LucationOrderState();
// }

// class _LucationOrderState extends State<LucationOrder>
//     with SingleTickerProviderStateMixin {
//   final bool finsh = false;
//   GoogleMapController? _controller;

//   List<Marker> allMarkers = [];

//   PageController? _pageController;
//   final String token =
//       'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMGU5MDA1NjFjMTg5MTlhODIwZGUzMjM1YWRmMGRhNzFlY2I0ZjkxZDUxMzcxNDNjYTE3NmYwNDkwMTJmNjUzMDdiZDM2NWY4YTg2ZDcxYjciLCJpYXQiOjE2NjE5NzY0NDguNzg2OTY1LCJuYmYiOjE2NjE5NzY0NDguNzg2OTY5LCJleHAiOjE2OTM1MTI0NDguNzgwMzE4LCJzdWIiOiIyMyIsInNjb3BlcyI6W119.g_3FCHgkbu_QzMRVxdx3HFlrQs-zebcMD2mPetWa9SLhxXoD0saRNgS75SXFaShuR2mjUQNgyN0554KdzUVtZ5BTuHL4E5zeqidf6DNZhuT9oTPXMKy-jm9kEjlsTa25NhUhbZz_pvJNvWXvARmXfQzi95tsIxukZGcGjR2W0gSXw-gDXh5pM_OYBD5r8cu7teNDZuTbHuj6PVjQ9j8TMk_oilpYkQkru0hlBBWcX3t9ZvlGCcKDjA8b9AjzkiB2kG1vEt9pIxmOA754hCLashfNrSrnzTVdcY_J2c_7P1-z088WReODprbCld7PdZRt2PqqIMjl_U7dpvgSRH1PAPTqoUC7mWsRWKLewxhgeVk5w4b5Es943nMy7ZrAy8hxgTPmh7Snnc67sBQUTl9303_sVeKVbJ3lOsr91x3Ve61qicA1VtSAlVXxBn9s3qSoUa3x6DygTYU-7HhNBDe5w9lAK93Y5Ua86KmcjBkQQaIv7l6albyhK-9JRGheSZed242Lu1C5BChxO3YwhR39QbR_EQ4br5P48CvpJcpY847s6ruZjOZfpGAnjhof5DlvPe0N15Drf8oZU2tOOR3iQFoxBwG3c6JSgxZlehGxejHzcXBRHVI865CDM8LkEyLio3qu0S3bhjy37269BGm7GXCcTO0LDWfpmeepKI9kubk';
// int? prevPage;

// void _onScroll() {
//     if (_pageController!.page!.toInt() != prevPage) {
//       prevPage = _pageController!.page!.toInt();
//       moveCamera();
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return BlocProvider(
//         create: (context) =>
//             OrderBloc(RepositoryProvider.of<GetDataFromAPI>(context), token)
//               ..add(LoadOrder()),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               'Driver\'s orders',
//               style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
//             ),
//             centerTitle: true,
//             backgroundColor: const Color.fromARGB(255, 87, 47, 157),
//             elevation: 0,
//           ),
//           drawer: My_Drawer_Admin(),
//           body: BlocListener<OrderBloc, OrderState>(
//             listener: (context, state) {
//               if (state is OrderLoadedState) {
//                 Fluttertoast.showToast(msg: 'new');
//               }
//             },
//             child: BlocBuilder<OrderBloc, OrderState>(
//               builder: (context, state) {
//                 if (state is OrderLoadingState) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 if (state is OrderLoadedState) {
//                   List<Orders> iitem = state.data;

//                   return state.data.isEmpty
//                       ? Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Center(
//                               child: Column(
//                             children: [
//                               Image.asset(
//                                 'assets/images/empty.png',
//                               ),
//                               const SizedBox(height: 12),
//                               const Text(
//                                 "No order for now",
//                                 style: TextStyle(
//                                     color: Colors.black45,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18),
//                               ),
//                               const SizedBox(height: 30),
//                               ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       primary: Colors.deepPurple,
//                                       minimumSize: Size(size.width / 2, 40)),
//                                   onPressed: () async {
//                                     context.read<OrderBloc>().add(LoadOrder());
//                                     // GetOrder.getOrder(token);
//                                   },
//                                   child: const Text(
//                                     "Reload",
//                                     style: TextStyle(fontSize: 18),
//                                   ))
//                             ],
//                           )),
//                         )
//                       : Column(children: [
//                           Expanded(
//                               child: RefreshIndicator(
//                                   onRefresh: () async => context
//                                       .read<OrderBloc>()
//                                       .add(LoadOrder()),
//                                   child: ListView.builder(
//                                       itemCount: iitem.length,
//                                       itemBuilder: (context, index) {
//                                         final sortitem = iitem
//                                           ..sort(
//                                             (a, b) => b.id!.compareTo(a.id!),
//                                           );
//                                         var item = sortitem[index];
//                                         // final item = itemOrder[index];
//                                         //  item.((data) {
//                                         //     for (var i in data) {
//                                         //       print('addddd${element.id}');
//                                         LatLng locatio =
//                                             //  LatLng(24.7136, 46.6753);
//                                             LatLng(
//                                                 double.parse(
//                                                     '${item.sender!.lat}'),
//                                                 double.parse(
//                                                     '${item.sender!.lng}'));

//                                         // setState(() {
//                                         allMarkers.add(Marker(
//                                             // zIndex: 150.0,
//                                             markerId: MarkerId(
//                                                 item.orderId.toString()),
//                                             icon: BitmapDescriptor
//                                                 .defaultMarkerWithHue(
//                                                     BitmapDescriptor.hueRed),
//                                             draggable: false,
//                                             infoWindow: InfoWindow(
//                                                 title:
//                                                     '#${item.orderId.toString()}',
//                                                 // anchor: element.sender!.area!,
//                                                 onTap: () {},
//                                                 snippet: item.sender!.area!),
//                                             position: locatio));
//  _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
//       ..addListener(_onScroll);
//                                         // }
//                                         // });
//                                         return Container();
//                                       })))
//                         ]);
//                 }
//                 if (state is OrderErrorState) {
//                   return Container(
//                     padding: const EdgeInsets.all(30.0),
//                     margin: const EdgeInsets.only(top: 200, bottom: 30),
//                     child: Center(
//                       child: Column(
//                         children: [
//                           const Text('Somthing error please try again later'),
//                           const SizedBox(height: 15.0),
//                           TextButton(
//                               onPressed: () {
//                                 context.read<OrderBloc>().add(LoadOrder());
//                               },
//                               child: const Text('try again'))
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//                 return Container(
//                   padding: const EdgeInsets.all(30.0),
//                   margin: const EdgeInsets.only(top: 200, bottom: 30),
//                   child: Center(
//                     child: Column(
//                       children: [
//                         const Text('Somthing error please try again later'),
//                         const SizedBox(height: 15.0),
//                         TextButton(
//                             onPressed: () {
//                               context.read<OrderBloc>().add(LoadOrder());
//                             },
//                             child: const Text('try again'))
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ));
//   }

//   shownitf(int id, String title, String body, String des) async {
//     return await service.showNotificationWithPayload(
//         id: id, title: title, body: body, payload: des);
//   }

//   late final LocalNotificationService service;
//   void listenToNotification() =>
//       service.onNotificationClick.stream.listen(onNoticationListener);

//   void onNoticationListener(String? payload) {
//     if (payload != null && payload.isNotEmpty) {
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: ((context) => AcceptScreen(payload: payload))));
//     }
//   }

//   // ignore: non_constant_identifier_names
//   OkButton(String tokecn, orid, id) {
//     return TextButton(
//       child: const Text(
//         "Accept",
//         style: TextStyle(fontSize: 20),
//       ),
//       onPressed: () {
//         setState(() {
//           StatusOrder.statuscheck(
//                   token: tokecn,
//                   status: "Driver assigned", //Driver assigned
//                   orderid: orid,
//                   id: id)
//               .then((value) => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ScreenAssept())));
//         });
//       },
//     );
//   }

//   cancelButton() {
//     return TextButton(
//       child: const Text(
//         "Cancel",
//         style: TextStyle(fontSize: 20),
//       ),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );
//   }

//   void acceptDialog({BuildContext? ctx, tokecn, orid, id}) {
//     showDialog(
//         context: ctx!,
//         builder: (_) => AlertDialog(
//               backgroundColor: Colors.white,
//               shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(20))),
//               titlePadding: const EdgeInsets.all(0),
//               title: Stack(
//                 children: [
//                   Image.asset(
//                     'assets/images/dialog_header.png',
//                     color: deepPurpleColor,
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 10),
//                     child: const Center(
//                         child: Text(
//                       'Accept Orders',
//                       style: AppStyles.DialogTitle,
//                     )),
//                   ),
//                 ],
//               ),
//               content: const Text(
//                   'Are you sure that the Order will be accepted?',
//                   style: TextStyle(color: AppColors.card)),
//               actions: <Widget>[
//                 TextButton(
//                   child: Container(
//                     width: 100,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30.0),
//                       border: Border.all(color: AppColors.blue),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Accept',
//                         style: AppStyles.DialogCancel,
//                       ),
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       StatusOrder.statuscheck(
//                               token: tokecn,
//                               status: "Driver assigned", //Driver assigned
//                               orderid: orid,
//                               id: id)
//                           .then((value) => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const ScreenAssept())));
//                     });
//                   },
//                 ),
//                 TextButton(
//                   child: Container(
//                     width: 100,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: deepPurpleColor,
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Cancel',
//                         style: AppStyles.DialogValid,
//                       ),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ));
//   }

//   // Future showAccesp({okecn, orid, id}) {
//   //   return showDialog(
//   //       context: context,
//   //       builder: (_) => CupertinoAlertDialog(
//   //             title: const Text(
//   //               "Accept Orders",
//   //               style: TextStyle(fontSize: 20),
//   //             ),
//   //             content: const Text(
//   //               "Are you sure that the Order will be accepted",
//   //               style: TextStyle(fontSize: 18),
//   //             ),
//   //             actions: [
//   //               OkButton(okecn, orid, id),
//   //               cancelButton(),
//   //             ],
//   //           ));
//   // }
// }
