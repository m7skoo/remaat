// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:remaat/localiation/language_constants.dart';
// import 'package:remaat/repository/data_controller.dart';
// import 'package:remaat/screen/order/order_screen.dart';
// import 'package:remaat/widgets/colors.dart';
// import 'package:remaat/widgets/phone/oth.dart';
// import 'package:remaat/widgets/phone/succes_complete.dart';
// import 'package:twilio_phone_verify/twilio_phone_verify.dart';

// class VeriyPhone extends StatefulWidget {
//   const VeriyPhone(
//       {Key? key, required this.title, this.id, this.orid, this.tokecn})
//       : super(key: key);

//   final String title;
//   final String? tokecn;
//   final int? orid;
//   final int? id;

//   @override
//   State<VeriyPhone> createState() => _VeriyPhoneState();
// }

// enum VerificationState { enterPhone, enterSmsCode }

// class _VeriyPhoneState extends State<VeriyPhone> {
//   TwilioPhoneVerify? _twilioPhoneVerify;

//   var verificationState = VerificationState.enterPhone;
//   // var phoneNumberController = TextEditingController();
//   var smsCodeController = TextEditingController();
//   bool loading = false;
//   String? errorMessage;
//   String? successMessage;
//   @override
//   void initState() {
//     _twilioPhoneVerify = TwilioPhoneVerify(
//         accountSid:
//             'ACd3e8997e07dac4dddaca92b436f10c83', // replace with Account SID
//         authToken:
//             'f4eb708583bbff067ffcaf48f080b90f', // replace with Auth Token
//         serviceSid:
//             'VA62b2b62c1087067601343e68ac282acd' // replace with Service SID
//         );
//     super.initState();
//   }

//   int timecode = 3;
//   @override
//   Widget build(BuildContext context) {
//     return _buildEnterPhoneNumber();
//     // : _buildEnterSmsCode();
//   }

//   // code() {
//   //   return timecode == 0 ? sendcode() : _buildEnterSmsCode();

//   //   // if (timecode == 0) {
//   //   //   _buildEnterPhoneNumber();
//   //   // if (verificationState == VerificationState.enterPhone) {
//   //   //   _buildEnterPhoneNumber();
//   //   // } else {
//   //   //   _buildEnterSmsCode();
//   //   // }
//   //   // } else {
//   //   //   _buildEnterSmsCode();
//   //   // }
//   // }

//   // sendcode() {
//   //   return verificationState == VerificationState.enterPhone
//   //       ? _buildEnterPhoneNumber()
//   //       : _buildEnterSmsCode();
//   // }

//   void changeErrorMessage(var message) =>
//       setState(() => errorMessage = message);

//   Future<void> changeSuccessMessage(var message) {
//     return successMessage = message;
//   }
//   // setState(() => successMessage = message);

//   void changeLoading(bool status) => setState(() => loading = status);

//   void switchToSmsCode() async {
//     changeSuccessMessage(null);
//     changeErrorMessage(null);
//     changeLoading(false);
//     setState(() {
//       verificationState = VerificationState.enterSmsCode;
//     });
//   }

//   void switchToPhoneNumber() {
//     if (loading) return;
//     changeSuccessMessage(null);
//     changeErrorMessage(null);
//     setState(() {
//       verificationState = VerificationState.enterPhone;
//     });
//   }

//   Future<void> sendCode(String numb) async {
//     if (numb.isEmpty || loading) return;
//     // changeLoading(true);
//     TwilioResponse twilioResponse = await _twilioPhoneVerify!.sendSmsCode(numb);

//     if (twilioResponse.successful!) {
//       // changeSuccessMessage('Code sent to $numb');
//       await Future.delayed(const Duration(seconds: 1)).whenComplete(() {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => OTPSCREEN(
//                     title: widget.title,
//                     id: widget.id,
//                     orid: widget.orid,
//                     tokecn: widget.tokecn)));
//       });
//       // switchToSmsCode();
//     } else {
//       changeErrorMessage(twilioResponse.errorMessage);
//     }
//     // changeLoading(false);
//   }

//   void verifyCode(String numb) async {
//     if (numb.isEmpty || smsCodeController.text.isEmpty || loading) return;
//     // changeLoading(true);
//     TwilioResponse twilioResponse = await _twilioPhoneVerify!
//         .verifySmsCode(phone: numb, code: smsCodeController.text);
//     if (twilioResponse.successful!) {
//       if (twilioResponse.verification!.status == VerificationStatus.approved) {
//         // changeSuccessMessage('Phone number is approved');
//         Fluttertoast.showToast(
//             msg: 'Phone number is approved',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 4,
//             backgroundColor: greenColor,
//             textColor: whiteColor,
//             fontSize: 16.0);
//         setState(() {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => const SuccComplete()));
//           StatusOrder.statuscheck(
//               token: widget.tokecn,
//               status: 'Delivered',
//               orderid: widget.orid,
//               id: widget.id);
//         });
//       } else {
//         // ignore: use_build_context_synchronously
//         changeSuccessMessage(getlang(context, 'errorcode'));
//       }
//     } else {
//       changeErrorMessage(twilioResponse.errorMessage);
//     }
//     changeLoading(false);
//   }

//   String currentText = "";
  // _buildEnterPhoneNumber() {
  //   return Scaffold(
  //     appBar: AppBar(
  //       elevation: 0,
  //       backgroundColor: Colors.transparent,
  //       // leading: IconButton(
  //       //   icon: Icon(
  //       //     Icons.arrow_back_ios,
  //       //     size: 18,
  //       //     color: Theme.of(context).primaryColor,
  //       //   ),
  //       //   onPressed: switchToPhoneNumber,
  //       // ),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(40.0),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const SizedBox(height: 20),
  //             Image.asset(
  //               'assets/images/verify_code.png',
  //               width: MediaQuery.of(context).size.width / 1,
  //               height: 180,
  //               fit: BoxFit.fill,
  //             ),
  //             const SizedBox(height: 30),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Text(getlang(context, 'laststep'),
  //                   style: GoogleFonts.aleo(
  //                       fontSize: 25,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.blue.shade900)),
  //             ),
  //             Text(getlang(context, 'sendto'),
  //                 style: GoogleFonts.aleo(
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.blue.shade900)),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Text('+966${widget.title}',
  //                   style: const TextStyle(
  //                       fontSize: 25,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.blue)),
  //             ),
  //             // TextField(
  //             //   controller: widget.title,
  //             //   keyboardType: TextInputType.phone,
  //             //   decoration: InputDecoration(
  //             //       hintText: widget.title, labelText: 'Enter Phone Number'),
  //             // ),

  //             const SizedBox(
  //               height: 30,
  //             ),

  //             SizedBox(
  //               width: double.infinity,
  //               height: 40,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(12),
  //                 child: TextButton(
  //                     onPressed: () {
  //                       setState(() {
  //                         sendCode('966${widget.title}');
  //                         // sendCode('+966506827499');/
  //                       });
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                         primary: Colors.deepPurple,
  //                         minimumSize:
  //                             Size(MediaQuery.of(context).size.width, 70)),
  //                     child: loading
  //                         ? _loader()
  //                         : Text(
  //                             getlang(context, 'sendCode'),
  //                             style: GoogleFonts.aleo(
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.white),
  //                           )),
  //               ),
  //             ),
  //             if (errorMessage != null) ...[
  //               const SizedBox(
  //                 height: 30,
  //               ),
  //               _errorWidget()
  //             ],
  //             if (successMessage != null) ...[
  //               const SizedBox(
  //                 height: 30,
  //               ),
  //               _successWidget()
  //             ]
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

//   // _buildEnterSmsCode() {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       backgroundColor: deepPurpleColor,
//   //       elevation: 0,
//   //       title: const Text(
//   //         "vrification code ",
//   //         style: TextStyle(color: Colors.deepPurple),
//   //       ),
//   //       centerTitle: true,
//   //       // backgroundColor: Colors.transparent,
//   //       leading: IconButton(
//   //         icon: const Icon(
//   //           Icons.arrow_back_ios,
//   //           size: 18,
//   //           color: Colors.white,
//   //         ),
//   //         onPressed: () {
//   //           Navigator.push(context,
//   //               MaterialPageRoute(builder: (context) => const ScreenOrder()));
//   //         },
//   //       ),
//   //     ),
//   //     body: Padding(
//   //       padding: const EdgeInsets.all(40.0),
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: [
//   //           // TextField(
//   //           //   controller: smsCodeController,
//   //           //   keyboardType: TextInputType.number,
//   //           //   decoration: InputDecoration(labelText: 'Enter Sms Code'),
//   //           // ),
//   //           const SizedBox(
//   //             height: 15,
//   //           ),

//   //           // Container(
//   //           //   child: Lottie.asset(
//   //           //     'assets/images/verify_code.json',
//   //           //     width: 150,
//   //           //     height: 150,
//   //           //     fit: BoxFit.cover,
//   //           //   ),
//   //           // ),
//   //           const SizedBox(
//   //             height: 20,
//   //           ),
//   //           Padding(
//   //             padding: const EdgeInsets.all(8.0),
//   //             child: Text(
//   //               'Please Enter the PIN code sent to : +966${widget.title}',
//   //               style: TextStyle(
//   //                   fontWeight: FontWeight.bold,
//   //                   color: Colors.blue.shade900,
//   //                   fontSize: 16),
//   //             ),
//   //           ),

//   //           PinCodeTextField(
//   //             appContext: context,
//   //             pastedTextStyle: TextStyle(
//   //               color: Colors.green.shade600,
//   //               fontWeight: FontWeight.bold,
//   //             ),

//   //             length: 6,
//   //             // obscureText: true,
//   //             // obscuringCharacter: '*',
//   //             // obscuringWidget: const FlutterLogo(
//   //             //   size: 24,
//   //             // ),
//   //             blinkWhenObscuring: true,
//   //             animationType: AnimationType.fade,
//   //             validator: (v) {
//   //               if (v!.length < 3) {
//   //                 return "I'm from validator";
//   //               } else {
//   //                 return null;
//   //               }
//   //             },
//   //             pinTheme: PinTheme(
//   //                 shape: PinCodeFieldShape.box,
//   //                 borderRadius: BorderRadius.circular(5),
//   //                 fieldHeight: 50,
//   //                 fieldWidth: 40,
//   //                 activeColor: Colors.white,
//   //                 activeFillColor: Colors.white,
//   //                 disabledColor: Colors.grey,
//   //                 inactiveColor: Colors.grey,
//   //                 // selectedColor: Colors.grey,
//   //                 inactiveFillColor: Colors.grey),
//   //             cursorColor: Colors.black,
//   //             animationDuration: const Duration(milliseconds: 300),
//   //             enableActiveFill: true,
//   //             // errorAnimationController: errorController,
//   //             controller: smsCodeController,
//   //             keyboardType: TextInputType.number,
//   //             boxShadows: const [
//   //               BoxShadow(
//   //                 offset: Offset(0, 1),
//   //                 color: Colors.black12,
//   //                 blurRadius: 10,
//   //               )
//   //             ],
//   //             onCompleted: (v) {
//   //               debugPrint("Completed");
//   //             },
//   //             // onTap: () {
//   //             //   print("Pressed");
//   //             // },
//   //             onChanged: (value) {
//   //               debugPrint(value);
//   //               setState(() {
//   //                 currentText = value;
//   //               });
//   //             },
//   //             beforeTextPaste: (text) {
//   //               debugPrint("Allowing to paste $text");
//   //               //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//   //               //but you can show anything you want here, like your pop up saying wrong paste format or etc
//   //               return true;
//   //             },
//   //           ),
//   //           const SizedBox(
//   //             height: 20,
//   //           ),
//   //           SizedBox(
//   //             width: double.infinity,
//   //             height: 40,
//   //             child: ElevatedButton(
//   //                 onPressed: () {
//   //                   setState(() {
//   //                     verifyCode('+966${widget.title}');
//   //                   });
//   //                   if (successMessage != null) {
//   //                     setState(() {
//   //                       Navigator.push(
//   //                           context,
//   //                           MaterialPageRoute(
//   //                               builder: (context) => const SuccComplete()));
//   //                     });
//   //                   }
//   //                 },
//   //                 style: ElevatedButton.styleFrom(
//   //                   minimumSize: Size(MediaQuery.of(context).size.width, 50),
//   //                 ),
//   //                 child: loading
//   //                     ? _loader()
//   //                     : const Text(
//   //                         'Verify',
//   //                         style: TextStyle(color: Colors.black),
//   //                       )),
//   //           ),
//   //           if (errorMessage != null) ...[
//   //             SizedBox(
//   //               height: 30,
//   //             ),
//   //             _errorWidget()
//   //           ],
//   //           if (successMessage != null) ...[
//   //             SizedBox(
//   //               height: 30,
//   //             ),
//   //             _successWidget()
//   //           ]
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   _loader() => SizedBox(
//         height: 15,
//         width: 15,
//         child: CircularProgressIndicator(
//           strokeWidth: 2,
//           valueColor: AlwaysStoppedAnimation(Colors.white),
//         ),
//       );

//   _errorWidget() => Material(
//         borderRadius: BorderRadius.circular(5),
//         color: Colors.red.withOpacity(.1),
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//           child: Row(
//             children: [
//               Expanded(
//                   child: Text(
//                 errorMessage!,
//                 style: TextStyle(color: Colors.red),
//               )),
//               IconButton(
//                   icon: Icon(
//                     Icons.close,
//                     size: 16,
//                   ),
//                   onPressed: () => changeErrorMessage(null))
//             ],
//           ),
//         ),
//       );

//   _successWidget() => Material(
//         borderRadius: BorderRadius.circular(5),
//         color: Colors.green.withOpacity(.1),
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//           child: Row(
//             children: [
//               Expanded(
//                   child: Text(
//                 successMessage!,
//                 style: TextStyle(color: Colors.green),
//               )),
//               IconButton(
//                   icon: Icon(
//                     Icons.close,
//                     size: 16,
//                   ),
//                   onPressed: () => changeSuccessMessage(null))
//             ],
//           ),
//         ),
//       );
// }
