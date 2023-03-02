import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:rating/rating.dart';
import 'package:remaat/screen/order/order_screen.dart';
import 'package:remaat/widgets/Rating/RatingForDeliveryBoy.dart';

class SuccComplete extends StatefulWidget {
  const SuccComplete({Key? key}) : super(key: key);

  @override
  State<SuccComplete> createState() => _SuccCompleteState();
}

class _SuccCompleteState extends State<SuccComplete> {
  bool rate = false;
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      final ratingModel = RatingModel(
        id: 1,
        title: 'Shipper Feedback:',
        subtitle: '',
        ratingConfig: RatingConfigModel(
          id: 1,
          ratingSurvey1: 'Rate Shipper?',
          ratingSurvey2: 'Rate Shipper?',
          ratingSurvey3: 'Rate Shipper?',
          ratingSurvey4: 'Rate Shipper?',
          ratingSurvey5: 'Rate Shipper?',
          items: [
            RatingCriterionModel(id: 1, name: 'Store was closed'),
            RatingCriterionModel(id: 2, name: 'No one Attended the driver'),
            RatingCriterionModel(id: 3, name: 'Store took too long'),
            RatingCriterionModel(id: 4, name: 'Items not packed properly'),
          ],
        ),
      );

      showModalBottomSheet(
        context: context,
        builder: (context) =>
            RatingWidget(controller: MockRatingController(ratingModel)),
      ).then((value) => {
            setState(() {
              rate = true;
            }),
            rateing(),
          });
      // .whenComplete(() => Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const OrderScreen())));
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const OrderScreen()));
    });
    super.initState();
  }

  Future rateing() async {
    setState(() {});
    final ratingModel = RatingModel(
      id: 1,
      title: 'Customer Feedback:',
      subtitle: '',
      ratingConfig: RatingConfigModel(
        id: 1,
        ratingSurvey1: 'Rate Customer?',
        ratingSurvey2: 'Rate Customer?',
        ratingSurvey3: 'Rate Customer?',
        ratingSurvey4: 'Rate Customer?',
        ratingSurvey5: 'Rate Customer?',
        items: [
          RatingCriterionModel(id: 1, name: 'Customer took too long'),
          RatingCriterionModel(id: 2, name: 'Actual customer not availale'),
          RatingCriterionModel(id: 3, name: 'customer behaviour not good'),
          RatingCriterionModel(id: 4, name: 'customer was good'),
        ],
      ),
    );
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          RatingWidget(controller: MockRatingController(ratingModel)),
    ).then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ScreenOrder())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/images/successfully-plane.json',
              repeat: false,
              reverse: false,
              // animate: false,
            ),
            const Center(
              child: Text('successfull Completed Order'),
            ),
          ],
        ),
      ),
    );
  }
// Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
}
