import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remaat/bloc/auth/auth_bloc.dart';
import 'package:remaat/const/fadeanimation.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/repository/globals.dart';
import 'package:remaat/screen/order/order_screen.dart';
import 'package:remaat/util/design/button_design.dart';

import 'package:remaat/util/design/colors.dart';
import 'package:remaat/util/design/general_design.dart';
import 'package:remaat/util/design/text_fields.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  // String userName;
  // String password;
  TextEditingController email = TextEditingController();
  TextEditingController passwordc = TextEditingController();
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
  }

  Future loginauth() async {
    setState(() {
      isApiCallProcess = true;
    });
    if (email.text.isNotEmpty || passwordc.text.isNotEmpty) {
      await GetDataFromAPI.login(
          context, email.text.trim(), passwordc.text.toString());
      setState(() {
        isApiCallProcess = false;
      });
    } else {
      setState(() {
        isApiCallProcess = false;
      });
      errorSnaokBar(context, '  found', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      height: size.height,
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(gradient: LINEAR_GRADIENT1),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  FadeAnimation(
                      1, logoDesign('assets/images/logo/white_logo.png')),
                  const SizedBox(
                    height: 28,
                  ),
                  FadeAnimation(2, centerLabel(getlang(context, 'drivlogin'))),
                  const SizedBox(
                    height: 30,
                  ),
                  // _labelTextInput(
                  //     "Email", "yourname@example.com", false, email),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeAnimation(
                          1, textFieldText(getlang(context, 'email'))),
                      FadeAnimation(
                        1,
                        textFieldDesign(
                          controller: email,
                          validator: (value) {
                            return value != null && value.length <= 6
                                ? 'please enter email'
                                : null;
                          },
                          hintTxt: getlang(context, 'enterEmail'),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeAnimation(
                          2, textFieldText(getlang(context, 'password'))),
                      const SizedBox(height: 10),
                      FadeAnimation(
                        2,
                        textFieldDesignWithIcon(
                            obscureText: _passwordVisible,
                            controller: passwordc,
                            icon: _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            validator: (value) {
                              return value != null && value.length < 5
                                  ? 'Minimum password length 6'
                                  : null;
                            },
                            iconAction: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            hintTxt: getlang(context, 'enterPassword')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  FadeAnimation(
                    1,
                    isApiCallProcess
                        ? const CircularProgressIndicator(
                            strokeWidth: 5.0,
                            color: Colors.deepPurple,
                          )
                        : primaryButton(
                            onPressed: () {
                              loginauth()
                                  .timeout(const Duration(seconds: 8))
                                  .then((value) => isApiCallProcess = false);
                            },
                            txt: getlang(context, 'login')),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  // _signUpLabel("Don't have an account yet?",
                  //     const Color(0xff909090)),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // _signUpLabel(
                  //     "Sign Up", Color.fromARGB(255, 6, 112, 242)),
                  // const SizedBox(
                  //   height: 35,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  // child: loginweght(size),

}
