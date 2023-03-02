import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remaat/firebase_options.dart';
import 'package:remaat/localiation/demo_localization.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/model/order_model.dart';
import 'package:remaat/notificationnew/homenotif.dart';
import 'package:remaat/notificationnew/key_notifi.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/screen/login/login_screen.dart';
import 'package:remaat/screen/order/order_screen.dart';
import 'package:remaat/util/share_const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }

//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );

//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   /// Create an Android Notification Channel.
//   ///
//   /// We use this channel in the `AndroidManifest.xml` file to override the
//   /// default FCM channel to enable heads up notifications.
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }

void main() async {
  // ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
  //       body: Center(
  //         child: Text(
  //           'Make sure that your current location is activated and connected to the Internet, then try again',
  //           style: GoogleFonts.tajawal(
  //               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
  //         ),
  //       ),
  //     );
  WidgetsFlutterBinding.ensureInitialized();

  //with lareveal
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set the background messaging handler early on, as a named top-level function
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true, 
        sound: true,
      );
  // if (!kIsWeb) {
  //   await setupFlutterNotifications();
  // }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString(ShareConst.email);
  var token = prefs.getString(ShareConst.token);
  var id = prefs.getInt(ShareConst.driverId);
  var attend = prefs.getBool(ShareConst.attendance);

  runApp(
    MyApp(
      email: email,
      token: token,
      driverId: id,
      attend: attend,
    ),
  );
}

var sound = 'positive.wav';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('notification'),
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  final String? email, token;
  final int? driverId;
  final attend;
  const MyApp({Key? key, this.email, this.token, this.driverId, this.attend})
      : super(key: key);
  static void setLoocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var sound = 'positive.wav';
  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    sound: const RawResourceAndroidNotificationSound(
                        'notification'),
                    playSound: true,
                    importance: Importance.max,
                    priority: Priority.high),
                // sound: RawResourceAndroidNotificationSound('new_auction_notification')),

                iOS: IOSNotificationDetails(sound: sound)));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });

    inishareprefence();
  }

  String? token;
  inishareprefence() async {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        token = prefs.getString(ShareConst.token).toString();
      });
      return prefs.getString(ShareConst.email)!;
    });
  }

  // AppRouter appRouter = AppRouter();
  RouteSettings? settings;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  Locale? _locale;
  // LocalProvider localProvider = LocalProvider();'
  Future<void> getDivecToken() async {
    // this is for topic same in api
    await FirebaseMessaging.instance.subscribeToTopic(topicKey);
    // final token = await _fm.subscribeToTopic('all');
    // // final divecetoekn = token;
    // print('token device $divecetoekn');
  }

  // List<Orders> selectedOrder = [];

  //for nearly
  // _initWorker() async {
  //   await BackgroundLocation.startLocationService();
  //   BackgroundLocation.getLocationUpdates((location) {
  //     print(location.speed.toString());

  //     for (var desiredPosition in selectedOrder) {
  //       var lat = double.parse(desiredPosition.sender!.lat!);
  //       var lug = double.parse(desiredPosition.sender!.lat!);
  //       print(lat);
  //       double distanceInMeters = Geolocator.distanceBetween(
  //           location.latitude!, location.longitude!, lat, lug);
  //       if (distanceInMeters <= 1000.0 && !desiredPosition.notified!) {
  //         desiredPosition.notified = true;
  //         notif.Notification notification = notif.Notification();
  //         notification.showNotificationWithoutSound(desiredPosition);
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    getDivecToken();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => GetDataFromAPI()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: _locale,
        supportedLocales: const [
          Locale('en', 'US'), // English, no country code
          Locale('ar', 'SA'),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        title: 'Remaat App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              color: Colors.deepPurple,
              iconTheme:
                  IconThemeData(color: Color.fromARGB(255, 63, 31, 119))),
          drawerTheme: const DrawerThemeData(elevation: 0),
        ),
        home: widget.email == null ? const LoginScreen() : const ScreenOrder(),
      ),
    );
  }
}
