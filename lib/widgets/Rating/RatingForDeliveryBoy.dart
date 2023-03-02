// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:rating/rating.dart';
import 'package:remaat/screen/order/order_screen.dart';
import 'package:remaat/widgets/app_constants.dart';

class Rating_delivary_boy extends StatefulWidget {
  @override
  _Rating_delivary_boyState createState() => _Rating_delivary_boyState();
}

class _Rating_delivary_boyState extends State<Rating_delivary_boy>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double rating = 0;
  TextEditingController My_note = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Rate with modal bottom sheet'),
              onPressed: () {
                final ratingModel = RatingModel(
                  id: 1,
                  title: null,
                  subtitle: 'Shipper Feedback:',
                  ratingConfig: RatingConfigModel(
                    id: 1,
                    ratingSurvey1: 'Store was closed',
                    ratingSurvey2: 'Em que potests melhorar?',
                    ratingSurvey3: 'No one Attended the driver',
                    ratingSurvey4: 'Store took too long',
                    ratingSurvey5: 'Items not packed properly',
                    items: [
                      RatingCriterionModel(id: 1, name: 'Store was closed'),
                      RatingCriterionModel(
                          id: 2, name: 'No one Attended the driver'),
                      RatingCriterionModel(id: 3, name: 'Store took too long'),
                      RatingCriterionModel(
                          id: 4, name: 'Items not packed properly'),
                    ],
                  ),
                );
                showModalBottomSheet(
                  context: context,
                  builder: (context) => RatingWidget(
                      controller: MockRatingController(ratingModel)),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.only(top: kToolbarHeight + 70),
              width: double.infinity,
              height: kToolbarHeight + 70,
              decoration: const BoxDecoration(
                gradient: AppConstants.LINEAR_GRADIENT,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              // child: OrderStatusWidget(),
            ),
            const SizedBox(height: 50),
            show_Rating_Alert(context),
          ],
        ),
      ),
    );
  }

  CupertinoAlertDialog show_Rating_Alert(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Rating",
        style: TextStyle(fontSize: 21),
      ),
      // title: Text("Rating: $rating", style: TextStyle(fontSize: 40),),

      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            "Customer Feedback:",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 8,
          ),
          // Build_Rating(),
          Text(
            "Rating: $rating",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            // onSaved: (val){
            //   My_note = val;
            // },
            controller: My_note,
            // validator: Valid_UserName,

            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(4),
                hintText: "Your note",
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.grey,
                  style: BorderStyle.solid,
                  width: 1,
                )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromRGBO(70, 95, 229, .92),
                  style: BorderStyle.solid,
                  width: 1,
                ))),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () async {
              Map<String, dynamic> data = {
                "Rating_store": "$rating  stars",
                "Note_store": My_note.text,
              };
              // CollectionReference dbRef =
              //     FirebaseFirestore.instance.collection("Feedback for Store");
              // dbRef.add(data);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScreenOrder()),
              );
            },
            child: const Text("OK")),
      ],
    );
  }

  // RatingBar Build_Rating() => RatingBar.builder(
  //     initialRating: rating,
  //     minRating: 1,
  //     itemSize: 40, // size of stars
  //     itemPadding: EdgeInsets.symmetric(horizontal: 1), // spase between stars
  //     itemBuilder: (context, _) => Icon(
  //       Icons.star,
  //       color: Colors.amber,
  //     ),
  //     updateOnDrag: true,
  //     onRatingUpdate: (rating) => setState(() {
  //       this.rating = rating;
  //     })); //End Build_Rating()

}

class MockRatingController extends RatingController {
  MockRatingController(RatingModel ratingModel) : super(ratingModel);

  @override
  Future<void> ignoreForEverCallback() async {
    print('Rating ignored forever!');
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Future<void> saveRatingCallback(
      int rate, List<RatingCriterionModel> selectedCriterions) async {
    print('Rating saved!\nRate: $rate\nsSelectedItems: $selectedCriterions');
    await Future.delayed(const Duration(seconds: 3));
  }
}
