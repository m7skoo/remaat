// import 'dart:async';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:remaat/model/order_model.dart';
// import 'package:remaat/repository/data_controller.dart';

// final orderDataProvider = FutureProvider<List<Orders>>(
//   (ref) async {
//     return ref.read(orderprovidr).getData();
//   },
// );

// // final acceptDataProvider = FutureProvider<List<AcceptOrder>>(
// //   (ref) async {
// //     return ref.read(orderprovidr).getDataAccept();
// //   },
// // );
// // final streamaccept = StreamProvider<List<AcceptOrder>>(
// //   (ref) {
// //     return ref.read(orderprovidr).getDataAccept();
// //   },
// // );

// // final example = StreamProvider.autoDispose((ref) {
// //   final streamController = StreamController<List<AcceptOrder>>();
// //   ref.read(orderprovidr).getDataAccept();
// //   ref.onDispose(() {
// //     // Closes the StreamController when the state of this provider is destroyed.
// //     streamController.close();
// //   });

// //   return streamController.stream;
// // });

// // final dataStreamProvider = StreamProvider.autoDispose<List<AcceptOrder>>((ref) {
// //   return ref.read(orderprovidr).getDataAccept();
// // });
