// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:maps_launcher/maps_launcher.dart';
// import 'package:remaat/const/padd.dart';
// import 'package:remaat/localiation/language_constants.dart';
// import 'package:remaat/model/order_model.dart';
// import 'package:remaat/repository/data_controller.dart';
// import 'package:remaat/screen/assept/assetp_screen.dart';
// import 'package:remaat/screen/details/details_screen.dart';
// import 'package:remaat/util/colors.dart';
// import 'package:remaat/util/design/colors.dart';
// import 'package:remaat/util/styles.dart';

// class Ordersitem extends StatefulWidget {
//   final Orders item;
//   // final Function() ontap;
//   const Ordersitem({Key? key, required this.item}) : super(key: key);

//   @override
//   State<Ordersitem> createState() => _OrdersitemState();
// }

// class _OrdersitemState extends State<Ordersitem> {
//   String email = '';
//   String token = '';
//   int driverId = 0;
//   // bool attend = false;
//   bool? attendance = false;
//   bool isbuttsearch = false;
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Card(
//           elevation: 5,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8.0),
//                 topRight: Radius.circular(8.0),
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${getlang(context, 'idorder')}: ${widget.item.orderId}",
//                           style: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12),
//                         ),
//                         padd3,
//                         Text(
//                             "${getlang(context, 'Reference')}: ${widget.item.reference.toString()}",
//                             style: GoogleFonts.tajawal(
//                                 fontSize: 12, color: Colors.grey[700])),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Icon(Icons.date_range_outlined),
//                         Column(
//                           children: [
//                             Text(
//                               getlang(context, 'create'),
//                               style: const TextStyle(
//                                   color: Colors.black, fontSize: 10),
//                             ),
//                             Text(
//                               '${widget.item.createdAt}',
//                               style: const TextStyle(
//                                   color: Colors.black, fontSize: 10),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(
//                   color: Colors.grey[600],
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '${getlang(context, 'shipper')}: ${widget.item.sender!.name ?? ''}',
//                       style: const TextStyle(
//                           color: Colors.black38, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       '${getlang(context, 'type')}: ${widget.item.sender!.role ?? ''}',
//                       style: const TextStyle(
//                           color: Colors.black38, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Row(
//                         children: [
//                           Text(
//                             '${widget.item.sender!.street ?? ''}, ',
//                             style: const TextStyle(
//                                 color: Colors.black38,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             '${widget.item.sender!.city ?? ''}, ',
//                             style: const TextStyle(
//                                 color: Colors.black38,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Expanded(
//                             child: Text(
//                               '${widget.item.sender!.area ?? ''}, ',
//                               style: const TextStyle(
//                                   color: Colors.black38,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           // Expanded(
//                           //   child: Text(
//                           //     '${item.sender!.buildingNumber}',
//                           //     style: const TextStyle(
//                           //         color: Colors.black38,
//                           //         fontWeight:
//                           //             FontWeight.bold),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         var long2 = double.parse(widget.item.sender!.lat!);
//                         var lut = double.parse(widget.item.sender!.lng!);

//                         MapsLauncher.launchCoordinates(
//                             long2, lut, 'Google Headquarters are here');
//                       },
//                       child: Center(
//                           child: Lottie.asset('assets/images/location-pin.json',
//                               width: 40, height: 45)),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 // Divider(
//                 //   height: 2,
//                 //   color: Colors.grey[600],
//                 // ),
//                 Row(
//                   // alignment: WrapAlignment.center,
//                   // runSpacing: 18.0,
//                   // spacing: 18.0,
//                   // crossAxisAlignment:
//                   //     CrossAxisAlignment.center,
//                   // mainAxisAlignment:
//                   //     MainAxisAlignment.spaceAround,
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: const RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(
//                                     14,
//                                   ),
//                                   bottomRight: Radius.circular(14))),
//                           backgroundColor:
//                               const Color.fromARGB(26, 170, 146, 146),
//                           elevation: 0,
//                           minimumSize: Size(size.width, 40),
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => DetailsScreen(
//                                       issho: true,
//                                       idOrder: widget.item.orderId!.toString(),
//                                       status: widget.item.status,
//                                       namesender: widget.item.sender!.name,
//                                       phonenumbersen:
//                                           widget.item.sender!.phoneNumber!,
//                                       phonenumberres:
//                                           widget.item.receiver!.phoneNumber,
//                                       latsender: widget.item.sender!.lat!,
//                                       lutsender: widget.item.sender!.lng,
//                                       latres: widget.item.receiver!.lat,
//                                       lutres: widget.item.receiver!.lng,
//                                       citysen: widget.item.sender!.city,
//                                       areasen: widget.item.sender!.area,
//                                       streatsen: widget.item.sender!.street,
//                                       totalprice:
//                                           widget.item.total_Price!.toDouble(),
//                                       namereseriver: widget.item.receiver!.name,
//                                       typesen: widget.item.sender!.role,
//                                       paymentMethod: widget.item.paymentMethod,
//                                       typeres: widget.item.receiver!.role,
//                                       cityres: widget.item.receiver!.city,
//                                       areares: widget.item.receiver!.area,
//                                       streatres: widget.item.receiver!.street,
//                                       sername:
//                                           widget.item.package!.service!.name,
//                                       boccount: widget.item.boxCount,
//                                       itemvalue: widget.item.totalPrice,
//                                       weight: widget.item.sHWeight,
//                                       packagename: widget.item.package!.name,
//                                       token: token,
//                                       driverId: driverId,
//                                       itemid: widget.item.id,
//                                       reference:
//                                           widget.item.reference.toString())));
//                           // shownitf(
//                           //   item.id!,
//                           //   item.orderId!.toString(),
//                           //   item.sender!.city!,
//                           //   item.sender!.area!,
//                           // );
//                         },
//                         child: Text(
//                           getlang(context, 'details'),
//                           style: GoogleFonts.taviraj(
//                               fontSize: 13.5,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           elevation: 0,
//                           shape: const RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(
//                                     4,
//                                   ),
//                                   topRight: Radius.circular(
//                                     4,
//                                   ),
//                                   bottomLeft: Radius.circular(
//                                     14,
//                                   ),
//                                   bottomRight: Radius.circular(14))),
//                           backgroundColor: const Color.fromARGB(255, 9, 84, 1),
//                           minimumSize: Size(size.width, 40),
//                         ),
//                         onPressed: () async {
//                           attendance!
//                               ? acceptDialog(
//                                   ctx: context,
//                                   tokecn: token,
//                                   orid: widget.item.id,
//                                   id: driverId,
//                                   tap: () {
//                                     // widget.ontap;
//                                     // context.read<OrderBloc>().add(LoadOrder());
//                                   },
//                                 )
//                               : await showAccesp();
//                         },
//                         child: Text(
//                           getlang(context, 'acceptorder'),
//                           style: GoogleFonts.taviraj(
//                               fontSize: 13.5,
//                               color: Colors.green[200],
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // isshowline
//                 //     ? Container(
//                 //         width:
//                 //             MediaQuery.of(context).size.width,
//                 //         height: 260,
//                 //         color: Colors.green,
//                 //         child: ProcessTimelinePage(
//                 //           create: item.createdAt,
//                 //           orderid: item.orderId,
//                 //           id: driverId,
//                 //           orid: item.id,
//                 //           tokecn: token,
//                 //         ),
//                 //       )
//                 //     : Container(),
//               ],
//             ),
//           ),
//         ),
//         // Text(item.sender!.lat!),
//         // Text(item.sender!.lng!),
//         // Text(item.receiver!.lat!),
//         // Text(item.totalPrice!),
//         // Text(item.deliveryPrice!.toString()),
//       ],
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
