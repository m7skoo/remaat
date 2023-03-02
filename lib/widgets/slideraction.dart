import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:slide_to_act/slide_to_act.dart';

class SliderActionButton extends StatefulWidget {
  final Function()? onConfirm;
  final String? text;
  final Color? color;
  const SliderActionButton({Key? key, this.onConfirm, this.text, this.color})
      : super(key: key);

  @override
  State<SliderActionButton> createState() => _SliderActionButtonState();
}

class _SliderActionButtonState extends State<SliderActionButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: SlideAction(
          borderRadius: 12,
          elevation: 0,
          height: 62,
          innerColor: Colors.white.withOpacity(0.4),
          outerColor: widget.color,
          text: widget.text,
          textStyle: GoogleFonts.tajawal(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          sliderRotate: false,
          sliderButtonIcon: Stack(
            children: [
              Lottie.asset('assets/images/arrowstatus.json',
                  height: 20, width: 30),
              const Icon(Icons.double_arrow),
            ],
          ),

          // reversed: true,
          onSubmit: widget.onConfirm),
    );
  }
}
