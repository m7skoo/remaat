import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';
import 'package:remaat/Drawer/language_page.dart';
import 'package:remaat/localiation/icon_language.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/localiation/languagewead.dart';
import 'package:remaat/screen/article_list_screen.dart';
import 'package:remaat/screen/assept/assetp_screen.dart';
import 'package:remaat/screen/brcode/brcode.dart';
import 'package:remaat/screen/complete/complete_screen.dart';
import 'package:remaat/screen/locationorder/location_accept.dart';
import 'package:remaat/screen/login/login_screen.dart';
import 'package:remaat/screen/order/order_screen.dart';
import 'package:remaat/screen/sheduled/sheduled_Screen.dart';
import 'package:remaat/util/share_const.dart';
import 'package:remaat/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class My_Drawer_Admin extends StatefulWidget {
  My_Drawer_Admin({Key? key}) : super(key: key);

  @override
  _My_Drawer_AdminState createState() => _My_Drawer_AdminState();
}

class _My_Drawer_AdminState extends State<My_Drawer_Admin> {
  Future<String>? _getUsername;
  String name = '';
  String email = '';
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        email = prefs.getString("email").toString();
        name = prefs.getString('name').toString();
      });
      return prefs.getString("email")!;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: const Color.fromARGB(255, 42, 24, 74).withOpacity(0.8)),
      child: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      color: const Color.fromARGB(255, 42, 24, 74)
                          .withOpacity(0.8),
                      padding: const EdgeInsets.all(8.0),
                      height: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white70.withOpacity(0.1),
                                  ),
                                  child: Lottie.asset(
                                      'assets/images/driver.json',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.fill)),
                              // Lottie.asset('assets/images/driver.json',
                              //     width: 100, height: 100, fit: BoxFit.fill),
                              Text(
                                name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                              Text(email,
                                  style: const TextStyle(color: Colors.white))
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 18.0,
                                  left: 6.0,
                                  right: 6.0,
                                  bottom: 8.0),
                              child: Image.asset(
                                'assets/images/logo/white_logo.png',
                                width: 140,
                                height: 140,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      )
                      //  UserAccountsDrawerHeader(
                      //   margin: const EdgeInsets.all(10.0),
                      //   accountName: Text(
                      //     name,
                      //     style:
                      //         const TextStyle(color: Colors.white, fontSize: 18.0),
                      //   ),
                      //   accountEmail: Text(email,
                      //       style: const TextStyle(color: Colors.white)),
                      //   currentAccountPicture: Container(
                      //       padding: const EdgeInsets.all(2),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(40),
                      //         color: Colors.white70.withOpacity(0.1),
                      //       ),
                      //       child: Lottie.asset('assets/images/driver.json',
                      //           width: size.width,
                      //           height: size.height,
                      //           fit: BoxFit.fill)),
                      //   decoration: const BoxDecoration(

                      //       color: sideBarColor,

                      //       image: DecorationImage(
                      //           centerSlice: Rect.zero,

                      //           scale: 7.1,
                      //           alignment: Alignment.center,

                      //           image: AssetImage(
                      //             'assets/images/logo/white_logo1.png',
                      //           ))),
                      // ),
                      ),
                  const Divider(color: whiteColor, height: 1),
                  listTileDrawer(
                    getlang(context, 'neworders'),
                    Icons.shopping_bag,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScreenOrder()),
                      );
                    },
                  ),
                  listTileDrawer(
                    getlang(context, 'myorders'),
                    Icons.my_library_books,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScreenAssept()),
                      );
                    },
                  ),
                  listTileDrawer(
                    getlang(context, 'sheduled'),
                    Icons.my_library_books,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScreenSheduled()),
                      );
                    },
                  ),
                  listTileDrawer(
                    getlang(context, 'ordercomplete'),
                    Icons.drive_eta_rounded,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScreenCompleted()),
                        // MaterialPageRoute(builder: (context) => const driver()),
                      );
                    },
                  ),

                  // listTileDrawer(
                  //   'QR',
                  //   Icons.drive_eta_rounded,
                  //   () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => BrCodeScreen()),
                  //       // MaterialPageRoute(builder: (context) => const driver()),
                  //     );
                  //   },
                  // ),
                  // listTileDrawer(
                  //     "Accept Orders", Icons.shopping_basket_outlined, () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => MainMapScreenMap()),
                  //   );
                  // }),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 30.0, bottom: 20.0),
                    child: LanguagePickerWidget(width: size.width * 0.6),
                  ),

                  // listTileDrawer("language", Icons.language, () {
                  //   showModalBottomSheet<void>(
                  //       context: context,
                  //       isScrollControlled: true,
                  //       builder: (BuildContext context) {
                  //         return const LanguagePage();
                  //       });
                  // }),
                ],
              ),

              //Line between all filde
              Container(
                color: Colors.red[200]!.withOpacity(0.2),
                child: listTileDrawer(
                    getlang(context, 'logout'), Icons.exit_to_app, () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    prefs.remove(ShareConst.email);
                    prefs.remove(ShareConst.driverId);
                    prefs.remove(ShareConst.name);
                    prefs.remove(ShareConst.token);
                    prefs.remove(ShareConst.attendance);
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  listTileDrawer(txt, icon, onPressed) {
    return ListTile(
      hoverColor: accentColor,
      title: Text(txt,
          style: GoogleFonts.tajawal(
              color: whiteColor, fontSize: 18, fontWeight: FontWeight.w500)),
      leading: Icon(icon, color: whiteColor),
      onTap: onPressed,
    );
  }
}
