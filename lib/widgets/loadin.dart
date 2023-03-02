import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LoadingConst extends StatelessWidget {
  const LoadingConst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Lottie.asset('assets/images/loadingmap.json'),
      ),
    );
  }
}
