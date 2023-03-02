// ignore_for_file: require_trailing_commas

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Manages & returns the users FCM token.
///
/// Also monitors token refreshes and updates state.
class TokenMonitor extends StatefulWidget {
  // ignore: public_member_api_docs
  TokenMonitor(this._builder);

  final Widget Function(String? token) _builder;

  @override
  State<StatefulWidget> createState() => _TokenMonitor();
}

class _TokenMonitor extends State<TokenMonitor> {
  String? _token;
  late Stream<String> _tokenStream;

  void setToken(String? token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    super.initState();
    //AIzaSyBY_Z5vNVEANji13YvCWoA5IWTfphKZjEg
    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                'AAAAtMEoVAY:APA91bGY8nmJTadYcHqrmB1zTKQk9E9LL3a-KdfbSD3w3JI5eNEej4VH8_UX7Bv8Ctf9g3aftslQ1aNTdV_sWiSmhLij1VfBZM3MD3dBBI3RinjZVZ4Xjvj3PfVG8lG6HdfNxb5MbWgi')
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(_token);
  }
}
