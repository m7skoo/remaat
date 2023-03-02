import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:remaat/const/padd.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/util/colors.dart';
import 'package:remaat/util/design/colors.dart';
import 'package:remaat/widgets/phone/succes_complete.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';

class OTPSCREEN extends StatefulWidget {
  const OTPSCREEN(
      {Key? key, required this.title, this.id, this.orid, this.tokecn})
      : super(key: key);

  final String title;
  final String? tokecn;
  final int? orid;
  final int? id;

  @override
  State<OTPSCREEN> createState() => _OTPSCREENState();
}

class _OTPSCREENState extends State<OTPSCREEN> {
  int secondsRemaining = 120;
  bool enableResend = false;
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
    _twilioPhoneVerify = TwilioPhoneVerify(
        accountSid:
            'ACd3e8997e07dac4dddaca92b436f10c83', // replace with Account SID
        authToken:
            'f4eb708583bbff067ffcaf48f080b90f', // replace with Auth Token
        serviceSid:
            'VA62b2b62c1087067601343e68ac282acd' // replace with Service SID
        );
    super.initState();
  }

  @override
  // ignore: unused_element
  dispose() {
    timer!.cancel();
    super.dispose();
  }

  void _resendCode() {
    //other code here
    setState(() {
      sendCode('+966${widget.title}');

      secondsRemaining = 120;
      enableResend = false;
    });
  }

  TwilioPhoneVerify? _twilioPhoneVerify;
  bool _isLoading = false;
  // Repository repository = Repository();
  TextEditingController otpcontroll = TextEditingController();
  String currentText = "";

  Future<void> sendCode(String numb) async {
    if (numb.isEmpty || _isLoading) return;
    changeLoading(true);
    TwilioResponse twilioResponse = await _twilioPhoneVerify!.sendSmsCode(numb);

    if (twilioResponse.successful!) {
      Fluttertoast.showToast(
          msg: 'تم ارسال الرمز الى رقم $numb',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: greenColor,
          textColor: whiteColor,
          fontSize: 16.0);
      await Future.delayed(const Duration(seconds: 1));
    } else {
      setState(() {
        changeLoading(false);
      });
      Fluttertoast.showToast(
          msg: '${twilioResponse.errorMessage}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: whiteColor,
          fontSize: 16.0);
    }
    setState(() {
      changeLoading(false);
    });
  }

  void verifyCode(String numb) async {
    if (numb.isEmpty || otpcontroll.text.isEmpty || _isLoading) return;
    changeLoading(true);
    TwilioResponse twilioResponse = await _twilioPhoneVerify!
        .verifySmsCode(phone: numb, code: otpcontroll.text);
    if (twilioResponse.successful!) {
      if (twilioResponse.verification!.status == VerificationStatus.approved) {
        // changeSuccessMessage('Phone number is approved');
        Fluttertoast.showToast(
            msg: 'Phone number is approved',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: greenColor,
            textColor: whiteColor,
            fontSize: 16.0);
        setState(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SuccComplete()));
          StatusOrder.statuscheck(
              token: widget.tokecn,
              status: 'Delivered',
              orderid: widget.orid,
              id: widget.id);
        });
      } else {
        setState(() {
          changeLoading(false);
          Fluttertoast.showToast(
              msg: getlang(context, 'errorcode'),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: whiteColor,
              fontSize: 16.0);
        });
      }
    } else {
      setState(() {
        changeLoading(false);
        Fluttertoast.showToast(
            msg: '${twilioResponse.errorMessage}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: whiteColor,
            fontSize: 16.0);
      });
    }
    setState(() {
      changeLoading(false);
    });
  }

  void changeLoading(bool status) => setState(() => _isLoading = status);
  @override
  Widget build(BuildContext context) {
    var szie = MediaQuery.of(context).size;

    // login() async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   if (widget.phone.isNotEmpty) {
    //     await repository.login(context, widget.phone.trim(), otpcontroll.text);
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    // }
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            paddh20,
            paddh20,
            Text(getlang(context, 'check'),
                style: GoogleFonts.teko(
                    fontWeight: FontWeight.bold,
                    fontSize: 27.0,
                    color: deepPurpleColor)),
            paddh16,
            Text('${getlang(context, 'codevirt')} ${widget.title}',
                textAlign: TextAlign.center,
                style: GoogleFonts.teko(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: deepPurpleColor)),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),

                length: 6,
                animationCurve: Curves.easeIn,

                autoFocus: true,

                // obscureText: true,
                // obscuringCharacter: '*',
                // obscuringWidget: const FlutterLogo(
                //   size: 24,
                // ),
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                // validator: (v) {
                //   if (v!.length < 3) {
                //     return "I'm from validator";
                //   } else {
                //     return null;
                //   }
                // },
                autoUnfocus: true,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 48,
                    fieldWidth: 40,
                    activeColor: Colors.transparent,
                    activeFillColor: Colors.white,
                    disabledColor: Colors.transparent,
                    inactiveColor: Colors.transparent,
                    selectedColor: Colors.grey[100],
                    selectedFillColor: Colors.grey[100],
                    // selectedColor: Colors.grey,
                    inactiveFillColor: Colors.grey[100]),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                // errorAnimationController: errorController,
                controller: otpcontroll,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onCompleted: (v) {
                  debugPrint("Completed");
                  setState(() {
                    verifyCode('+966${widget.title}');
                  });
                },
                // onTap: () {
                //   print("Pressed");
                // },
                onChanged: (value) {
                  debugPrint(value);
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: deepPurpleColor,
                    animationDuration: const Duration(seconds: 1),
                    elevation: 0,
                    minimumSize: Size(szie.width * 0.8, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                onPressed: () {
                  setState(() {
                    verifyCode('+966${widget.title}');
                  });
                },
                child: _isLoading == true
                    ? const CircularProgressIndicator()
                    : const Text('رمز التحقق')),
            paddh14,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                enableResend
                    ? Text('لم تستلم رمز التحقق؟',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.teko(
                            // fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: deepPurpleColor))
                    : Text(
                        'يرجى  الانتظار $secondsRemaining ثواني لإعادة إرسال الرمز',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.teko(
                            // fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: deepPurpleColor)),
                enableResend
                    ? TextButton(
                        onPressed: () {
                          _resendCode();
                        },
                        child: Text('إعادة إرسال',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.teko(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: deepPurpleColor)),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
