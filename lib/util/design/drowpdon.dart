import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/repository/check_api.dart';
import 'package:remaat/util/share_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendedDrowp extends StatefulWidget {
  final String? token;
  final int? driverId;
  final bool? attendance;
  final Function() ontap;
  const AttendedDrowp(
      {super.key,
      this.token,
      this.driverId,
      this.attendance,
      required this.ontap});

  @override
  State<AttendedDrowp> createState() => _AttendedDrowpState();
}

class _AttendedDrowpState extends State<AttendedDrowp> {
  @override
  Widget build(BuildContext context) {
    getChekout() async {
      SharedPreferences share = await SharedPreferences.getInstance();
      GetCheck.getCheckOut(widget.token!, widget.driverId!).then((value) {
        if (value != null) {
          showToast(value.message!, Colors.red);
          setState(() {
            widget.attendance == false;
            share.setBool(ShareConst.attendance, false);
          });
        }
      });
      // }
    }

    getCheck() async {
      SharedPreferences share = await SharedPreferences.getInstance();
      GetCheck.getCheck(widget.token!, widget.driverId!).then((value) {
        if (value != null) {
          showToast(value.message!, Colors.green);

          setState(() {
            widget.attendance == true;
            share.setBool(ShareConst.attendance, true);
          });
        }
      });
      // }
    }

    return DropdownButton(
      borderRadius: BorderRadius.circular(18),
      hint: Text(
        getlang(context, 'attedance'),
        style: GoogleFonts.tauri(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      underline: const SizedBox(),
      // items: dropDownOptions.map<DropdownMenuItem<String>>((String mascot) {
      //   return DropdownMenuItem<String>(child: Text(mascot), value: mascot);
      // }).toList(),
      // Alternative way to pass items
      items: [
        DropdownMenuItem(
            value: "off servoce",
            child: TextButton.icon(
                onPressed: () {
                  widget.ontap;
                  widget.attendance! == false;
                  getChekout();
                },
                icon: const Icon(
                  Icons.offline_bolt_outlined,
                  color: Colors.red,
                ),
                label: Text(
                  getlang(context, 'offservice'),
                  style: GoogleFonts.tauri(fontSize: 12, color: Colors.red),
                ))),
        DropdownMenuItem(
            value: "on servoce",
            child: TextButton.icon(
                onPressed: () {
                  widget.ontap;
                  widget.attendance! == true;
                  getCheck();
                },
                icon: const Icon(
                  Icons.task_outlined,
                  color: Colors.green,
                ),
                label: Text(
                  getlang(context, 'onservice'),
                  style: GoogleFonts.tauri(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ))),
      ],
      // value: _dropdownValue,
      onChanged: (value) {},
      // Customizatons
      //iconSize: 42.0,
      //iconEnabledColor: Colors.green,
      // icon: const Icon(Icons.flutter_dash),
      isExpanded: true,
      style: const TextStyle(
        color: Colors.blue,
      ),
    );
  }

  showToast(message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
