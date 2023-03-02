// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:remaat/localiation/language_constants.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/widgets/phone/phone_wedgit.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

const completeColor = Color(0xff5F20A9);
final inProgressColor = const Color(0xff5F20A9).withOpacity(0.6);
const todoColor = Colors.white;

// ignore: must_be_immutable
class ProcessTimelinePage extends StatefulWidget {
  String? create, orderid;
  String? tokecn, status, phoneres;
  int? orid;
  int? id;
  bool? fish;
  String? paymothode;

  ProcessTimelinePage(
      {Key? key,
      this.orderid,
      this.orid,
      this.create,
      this.id,
      this.status,
      this.fish,
      this.phoneres,
      this.paymothode,
      this.tokecn})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProcessTimelinePageState createState() => _ProcessTimelinePageState();
}

class _ProcessTimelinePageState extends State<ProcessTimelinePage> {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int? processIndex = 0;
  Color getColor(int index) {
    if (index == processIndex) {
      return inProgressColor;
    } else if (index < processIndex!) {
      return completeColor;
    } else {
      return const Color(0xff5F20A9).withOpacity(0.3);
    }
  }

  @override
  void initState() {
    if (widget.status! == "Driver assigned") {
      processIndex = 1;
    } else if (widget.status! == 'Driver on his way') {
      processIndex = 2;
    } else if (widget.status! == 'Arrive') {
      processIndex = 3;
    } else if (widget.status! == 'Picked up') {
      processIndex = 4;
    } else if (widget.status! == 'Out for delivery') {
      processIndex = 5;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final processes = [
      getlang(context, "accepted"),
      getlang(context, "drivertopickup"),
      '',
      getlang(context, "pickedup"),
      getlang(context, "drivertocustomes"),
      getlang(context, "delivered"),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Timeline.tileBuilder(
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          color: Colors.transparent,
          connectorTheme: const ConnectorThemeData(
            space: 10.0,
            thickness: 5.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemExtentBuilder: (_, __) =>
              MediaQuery.of(context).size.width / processes.length,
          oppositeContentsBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Image.asset(
                'assets/process_timeline/status${index + 1}.png',
                width: 40.0,
                color: getColor(index),
              ),
            );
          },
          contentsBuilder: (context, index) {
            // setState(() {
            //   str = _processes[index];
            // });
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                processes[index],
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold,
                  color: getColor(index),
                ),
              ),
            );
          },
          indicatorBuilder: (_, index) {
            Color color;
            var child;
            if (index == processIndex) {
              color = inProgressColor;
              child = Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Lottie.asset(
                    'assets/images/loadin_location.json',
                  ));
            } else if (index < processIndex!) {
              color = completeColor;
              child = const Icon(
                Icons.check,
                color: Colors.white,
                size: 12.0,
              );
            } else {
              color = const Color(0xff5F20A9).withOpacity(0.5);
            }

            if (index <= processIndex!) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomPaint(
                    size: const Size(30.0, 30.0),
                    painter: _BezierPainter(
                      color: color,
                      drawStart: index > 0,
                      drawEnd: index < processIndex!,
                    ),
                  ),
                  DotIndicator(
                    size: 30.0,
                    color: color,
                    child: child,
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomPaint(
                    size: const Size(15.0, 15.0),
                    painter: _BezierPainter(
                      color: color,
                      drawEnd: index < processes.length - 1,
                    ),
                  ),
                  OutlinedDotIndicator(
                    borderWidth: 4.0,
                    color: color,
                  ),
                ],
              );
            }
          },
          connectorBuilder: (_, index, type) {
            if (index > 0) {
              if (index == processIndex) {
                final prevColor = getColor(index - 1);
                final color = getColor(index);
                List<Color> gradientColors;
                if (type == ConnectorType.start) {
                  gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
                } else {
                  gradientColors = [
                    prevColor,
                    Color.lerp(prevColor, color, 0.5)!
                  ];
                }
                return DecoratedLineConnector(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                  ),
                );
              } else {
                return SolidLineConnector(
                  color: getColor(index),
                );
              }
            } else {
              return null;
            }
          },
          itemCount: processes.length,
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   icon: const Icon(FontAwesomeIcons.chevronRight),
      //   label: const Text(''),
      //   elevation: 0,
      //   onPressed: () async {
      //     // final SharedPreferences prefs = await _prefs;
      //     setState(() {
      //       processIndex = (processIndex! + 1);
      //     });
      //     final isLDriver = processIndex == 1;
      //     if (isLDriver) {
      //       setState(() {
      //         try {
      //           // prefs.setInt('assigned', processIndex!);

      //           StatusOrder.statuscheck(
      //               token: widget.tokecn,
      //               status: "Driver assigned", //Driver assigned
      //               orderid: widget.orid,
      //               id: widget.id);
      //         } catch (e) {
      //           throw Exception(e.toString());
      //         }
      //       });
      //     }
      //     final isLDriverWay = processIndex == 2;
      //     if (isLDriverWay) {
      //       setState(() {
      //         try {
      //           // prefs.setInt('way', processIndex!);

      //           StatusOrder.statuscheck(
      //               token: widget.tokecn,
      //               status: "Driver on his way",
      //               orderid: widget.orid,
      //               id: widget.id);
      //         } catch (e) {
      //           throw Exception(e.toString());
      //         }
      //       });
      //     }
      //     final isLDriverArr = processIndex == 3;
      //     if (isLDriverArr) {
      //       setState(() {
      //         StatusOrder.statuscheck(
      //             token: widget.tokecn,
      //             status: "Arrive",
      //             orderid: widget.orid,
      //             id: widget.id);
      //       });
      //     }

      //     final isLDriverPack = processIndex == 4;
      //     if (isLDriverPack) {
      //       setState(() {
      //         StatusOrder.statuscheck(
      //             token: widget.tokecn,
      //             status: "Picked up",
      //             orderid: widget.orid,
      //             id: widget.id);
      //       });
      //     }
      //     final isLDriverOut = processIndex == 4;
      //     if (isLDriverOut) {
      //       setState(() {
      //         StatusOrder.statuscheck(
      //                 token: widget.tokecn,
      //                 status: "Out for delivery",
      //                 orderid: widget.orid,
      //                 id: widget.id)
      //             .then((value) {
      //           if (widget.paymothode == 'COD') {
      //             showDialog(
      //               barrierDismissible: false,
      //               context: context,
      //               builder: (context) {
      //                 return AlertDialog(
      //                   // scrollable: false,

      //                   insetPadding: const EdgeInsets.all(12.0),
      //                   title: const Text(
      //                     "Confirm COD collection",
      //                   ),
      //                   // content: const Text('Confirm COD collection'),
      //                   actions: [
      //                     ElevatedButton(
      //                         style: ElevatedButton.styleFrom(
      //                             primary: Colors.green),
      //                         onPressed: () {
      //                           // Navigator.push(
      //                           //     context,
      //                           //     MaterialPageRoute(
      //                           //         builder: (context) => VeriyPhone(
      //                           //               title: widget.phoneres!,
      //                           //               id: widget.id,
      //                           //               orid: widget.orid,
      //                           //               tokecn: widget.tokecn,
      //                           //             )));
      //                         },
      //                         child: const Text(
      //                           "Collected",
      //                         )),
      //                     const SizedBox(width: 10),
      //                     ElevatedButton(
      //                         style: ElevatedButton.styleFrom(
      //                             primary: Colors.grey),
      //                         onPressed: () {
      //                           setState(() {
      //                             processIndex = (processIndex! - 1);
      //                           });
      //                           Navigator.pop(context);
      //                         },
      //                         child: const Text(
      //                           "Cancel",
      //                         ))
      //                   ],
      //                 );
      //               },
      //             );
      //           } else {
      //             // Navigator.push(
      //             //     context,
      //             //     MaterialPageRoute(
      //             //         builder: (context) => VeriyPhone(
      //             //               title: widget.phoneres!,
      //             //               id: widget.id,
      //             //               orid: widget.orid,
      //             //               tokecn: widget.tokecn,
      //             //             )));
      //           }
      //         });
      //       });
      //     }
      //     final isLDriverOut1 = processIndex == 6;
      //     if (isLDriverOut1) {
      //       setState(() {
      //         StatusOrder.statuscheck(
      //                 token: widget.tokecn,
      //                 status: "Out for delivery",
      //                 orderid: widget.orid,
      //                 id: widget.id)
      //             .then((value) {
      //           if (widget.paymothode == 'COD') {
      //             showDialog(
      //               barrierDismissible: false,
      //               context: context,
      //               builder: (context) {
      //                 return AlertDialog(
      //                   // scrollable: false,

      //                   insetPadding: const EdgeInsets.all(12.0),
      //                   title: const Text(
      //                     "Confirm COD collection",
      //                   ),
      //                   // content: const Text('Confirm COD collection'),
      //                   actions: [
      //                     ElevatedButton(
      //                         style: ElevatedButton.styleFrom(
      //                             primary: Colors.green),
      //                         onPressed: () {
      //                           setState(() {
      //                             Navigator.push(
      //                                 context,
      //                                 MaterialPageRoute(
      //                                     builder: (context) => VeriyPhone(
      //                                           title: widget.phoneres!,
      //                                           id: widget.id,
      //                                           orid: widget.orid,
      //                                           tokecn: widget.tokecn,
      //                                         )));
      //                           });
      //                         },
      //                         child: const Text(
      //                           "Collected",
      //                         )),
      //                     const SizedBox(width: 10),
      //                     ElevatedButton(
      //                         style: ElevatedButton.styleFrom(
      //                             primary: Colors.grey),
      //                         onPressed: () {
      //                           setState(() {
      //                             processIndex = (processIndex! - 1);
      //                           });
      //                           Navigator.pop(context);
      //                         },
      //                         child: const Text(
      //                           "Cancel",
      //                         ))
      //                   ],
      //                 );
      //               },
      //             );
      //           } else {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => VeriyPhone(
      //                           title: widget.phoneres!,
      //                           id: widget.id,
      //                           orid: widget.orid,
      //                           tokecn: widget.tokecn,
      //                         )));
      //           }
      //         });
      //       });
      //     }
      //   },
      //   backgroundColor: inProgressColor,
      // ),
    );
  }
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius)
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(
            size.width, size.height / 2, size.width + radius, radius)
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}
