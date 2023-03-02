// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:maps_launcher/maps_launcher.dart';
// // import 'package:remaat/bloc/cubit/orders_cubit.dart';
// import 'package:remaat/bloc/order/order_bloc.dart';
// import 'package:remaat/const/padd.dart';
// import 'package:remaat/localiation/language_constants.dart';
// import 'package:remaat/model/order_model.dart';
// import 'package:remaat/repository/data_controller.dart';
// import 'package:remaat/screen/assept/assetp_screen.dart';
// import 'package:remaat/screen/details/details_screen.dart';
// import 'package:remaat/screen/order/orderitems.dart';
// import 'package:remaat/screen/search/search_screen.dart';
// import 'package:remaat/util/colors.dart';
// import 'package:remaat/util/design/colors.dart';
// import 'package:remaat/util/share_const.dart';
// import 'package:remaat/util/styles.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class article_list_screen extends StatefulWidget {
//   const article_list_screen({super.key});

//   @override
//   State<article_list_screen> createState() => _article_list_screenState();
// }

// class _article_list_screenState extends State<article_list_screen> {
//   final _debouncer = Debouncer();
//   late List<Orders> allorders;
//   late List<Orders> searchorder;
//   bool _isSearching = false;
//   final _searchController = TextEditingController();

//   String email = '';
//   String token =
//       'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNDkzNTE0ZDJlZTMxZTc2M2U1NmUyZWUwZDJhZGFmYTVhZjNiNDk3YzMxNjIxNTMxYmNmMWQ1MDJlYTQwZjQ2MDk5NTk0NjllMjJjMTZlMzEiLCJpYXQiOjE2NjU1NjQ2NTUuNDA1OTU2LCJuYmYiOjE2NjU1NjQ2NTUuNDA1OTYsImV4cCI6MTY5NzEwMDY1NS4zOTg5NzEsInN1YiI6IjYiLCJzY29wZXMiOltdfQ.mSsTRDJ70HjMeYPt0spWUNdclPhbEPuBhj5qfS4WKi7bDWnFlWvQT9l8Fboc5dDeCobp4M82uxKQisAjGQ3A_m2TOciMT5rKw7HxikIhdpiK_gMltEl_ZOiTXEJKLnFalW-4oPZU11oAPBAC-TEfyllPTanFZ7pLpcbUMe42sBb5wlV3lsK1a4UL1yLRjMnuUGlOP-kaill-5ZB186mCKuOvnb3nziut8Y_Ov7Z139mJxA8N75-Dj3bgOBaTiN4VS6bI4ldnx0AlyYDcZLtWgOsrtMCF4MRje0uGlq_daxNU5yZA5QdNRwpk7QuU8sJwxyBRKZaA9IsXAe8kqkK1wgD7AHbCxPVAUxGeOIMNqF-wFAYZMeHeRNonYfi55Sp_bE-VgvkNZlmyOqbeYHxASRY3HgMxDEMgmBxqw6-vNzGv71t7Hozlxpm9wXEMRiP10KpAuHkigFXCcFuG9PrVH8HHUCuOpr6T_gNh1pC0-GLvDkZN7-tIPlbof3wDmwGKUi4NktwF6EXXKnoOPwXTmaPSZNTlNxf6EahrEp6siLnjJKl1y5_ldObbYT8j8j6k-DpruX3RSnDP3fKZxh1s78MprCyIrbCTQZLIvtKfAtbWeCkB-gpzG9QWVtemh5pevMIGeHD9L6qanRET3krVQpg3BK5ym2vB6BzfaPJ7AjU';
//   int driverId = 0;
//   // bool attend = false;
//   bool? attendance = false;
//   bool isbuttsearch = false;
//   @override
//   void initState() {
//     // BlocProvider.of<OrdersCubit>(context).getallOrders(token);
//     // SharedPreferences.getInstance().then((prefs) {
//     //   setState(() {
//     //     email = prefs.getString(ShareConst.email).toString();

//     //     token = prefs.getString(ShareConst.token).toString();
//     //     driverId = prefs.getInt(ShareConst.driverId)!;
//     //     attendance = prefs.getBool(ShareConst.attendance)!;

//     //     print(token);
//     //     print(driverId);
//     //     print(attendance);
//     //   });
//     //   return prefs.getString(ShareConst.email)!;
//     // });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           OrderBloc(RepositoryProvider.of<GetDataFromAPI>(context), token)
//             ..add(LoadOrder()),
//       child: Scaffold(
//         appBar: AppBar(
//           title: _isSearching ? _buildsearchField() : _titleAppBar(),
//           leading: _isSearching
//               ? const BackButton(
//                   color: Colors.grey,
//                 )
//               : Container(),
//           actions: _buildAppBarAction(),
//         ),
//         body: buildBlocWidget(),
//       ),
//     );
//   }

//   Widget buildBlocWidget() {
//     return BlocBuilder<OrderBloc, OrderState>(
//       builder: (context, state) {
//         if (state is OrderLoadingState) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         if (state is OrderLoadedState) {
//           allorders = (state).data;
//           return buildLoadedListWidgets();
//         } else {
//           return showLoadingIndicator();
//         }
//       },
//     );
//   }

//   Widget showLoadingIndicator() {
//     return const Center(
//       child: CircularProgressIndicator(
//         color: Colors.yellow,
//       ),
//     );
//   }

//   Widget buildLoadedListWidgets() {
//     return buildCharactersList();
//   }

//   Widget buildCharactersList() {
//     var size = MediaQuery.of(context).size;
//     return ListView.builder(
//         itemCount: _searchController.text.isEmpty
//             ? allorders.length
//             : searchorder.length,
//         physics: const ClampingScrollPhysics(),
//         itemBuilder: (context, index) {
//           final sortitem = allorders
//             ..sort(
//               (a, b) => b.id!.compareTo(a.id!),
//             );
//           var item = sortitem[index];
//           // print(allorders.length);
//           // final item = itemOrder[index];
//           // final lat = double.parse(item.sender!.lat!);
//           // final lag = double.parse(item.sender!.lat!);
//           // final latr = double.parse(item.receiver!.lat!);
//           // final lagr = double.parse(item.receiver!.lat!);
//           // final startCoordinate = Location(lat, lag);
//           // final endCoordinate = Location(latr, lagr);
//           // final distanceInMeter = haversineDistance.haversine(
//           //     startCoordinate, endCoordinate, Unit.METER);
//           // final distanceInKm = haversineDistance.haversine(
//           //     startCoordinate, endCoordinate, Unit.KM);
//           return Ordersitem(
//             item: _searchController.text.isEmpty ? item : searchorder[index],
//           );
//         });
//   }

//   Widget _buildsearchField() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//       child: SizedBox(
//         height: 39.5,
//         child: TextField(
//           controller: _searchController,
//           onChanged: (order) {
//             _debouncer.run(() {
//               setState(() {
//                 addsearchforitemList(order);
//               });
//             });
//           },
//           // onEditingComplete: () {
//           //   searchControll.text;
//           // },
//           style:
//               const TextStyle(fontSize: 13.0, height: 2.0, color: Colors.black),
//           decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.grey[200],
//               border: InputBorder.none,
//               prefixIcon: const Icon(Icons.search_outlined),
//               hintText: getlang(context, 'search'),
//               enabledBorder: UnderlineInputBorder(
//                   borderRadius: BorderRadius.circular(18),
//                   borderSide: BorderSide.none),
//               disabledBorder: UnderlineInputBorder(
//                   borderRadius: BorderRadius.circular(18),
//                   borderSide: BorderSide.none),
//               focusedBorder: UnderlineInputBorder(
//                   borderRadius: BorderRadius.circular(18),
//                   borderSide: BorderSide.none)),
//         ),
//       ),
//     );
//   }

//   void addsearchforitemList(String order) {
//     searchorder = allorders
//         .where((u) =>
//             u.orderId!.toLowerCase().contains(order) ||
//             u.reference!.toLowerCase().contains(order) ||
//             u.sender!.name!.toLowerCase().contains(order) ||
//             '0${u.sender!.phoneNumber!}'.toLowerCase().contains(order) ||
//             u.receiver!.name!.toLowerCase().contains(order) ||
//             '0${u.receiver!.phoneNumber}'.toLowerCase().contains(order))
//         .toList();
//   }

//   _buildAppBarAction() {
//     if (_isSearching) {
//       return [
//         IconButton(
//             onPressed: () {
//               _clearSearching();
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.clear_outlined, color: Colors.grey)),
//       ];
//     } else {
//       return [
//         IconButton(
//             onPressed: _startSearch,
//             icon: const Icon(Icons.search_outlined, color: Colors.grey)),
//       ];
//     }
//   }

//   void _startSearch() {
//     ModalRoute.of(context)!
//         .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
//     setState(() {
//       _isSearching = true;
//     });
//   }

//   void _stopSearching() {
//     _clearSearching();
//     setState(() {
//       _isSearching = false;
//     });
//   }

//   void _clearSearching() {
//     setState(() {
//       _searchController.clear();
//     });
//   }

//   _titleAppBar() {
//     return Text(
//       getlang(context, 'neworders'),
//       // 'Driver\'s orders',
//       style: GoogleFonts.tajawal(
//         color: Colors.grey,
//       ),
//     );
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
//         "OK",
//         style: TextStyle(fontSize: 20),
//       ),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );
//   }

//   void acceptDialog({BuildContext? ctx, tokecn, orid, id, Function()? tap}) {
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
//               content: Text('Are you sure that the Order will be accepted?',
//                   style: GoogleFonts.tajawal(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[800])),
//               actions: <Widget>[
//                 TextButton(
//                   child: Container(
//                     width: 100,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: deepPurpleColor,
//                       borderRadius: BorderRadius.circular(30.0),
//                       border: Border.all(color: AppColors.blue),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Accept',
//                         style: GoogleFonts.tajawal(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       print(tokecn);
//                       print(orid);
//                       print(id);
//                       StatusOrder.statuscheck(
//                               token: tokecn,
//                               status: "Driver assigned", //Driver assigned
//                               orderid: orid,
//                               id: id)
//                           .then((value) => tap);
//                     });
//                   },
//                 ),
//                 TextButton(
//                   child: Container(
//                     width: 100,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       // color: deepPurpleColor,
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Cancel',
//                         style: GoogleFonts.tajawal(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                             color: Colors.grey[600]),
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

//   Future showAccesp() {
//     return showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//               shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(20))),
//               title: const Text(
//                 "Action to be taken",
//                 style: TextStyle(fontSize: 20),
//               ),
//               content: Text(
//                 getlang(context, 'attendecmust'),
//                 style: const TextStyle(fontSize: 18),
//               ),
//               actions: [
//                 // getCheck(,id);
//                 // OkButton(okecn, orid, id),
//                 cancelButton(),
//               ],
//             ));
//   }
// }
