import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maps_launcher/maps_launcher.dart';

class Expansional extends StatefulWidget {
  const Expansional({super.key});

  @override
  State<Expansional> createState() => _ExpansionalState();
}

class ItemMode{
   bool isExpanded;
  final String header;
  final Widget body;
  

  ItemMode({required this.isExpanded,required this.header,required this.body});

}
class _ExpansionalState extends State<Expansional> {

  List<ItemMode> itemResult = [
    ItemMode(isExpanded:  false,header:  'Order detail',body:  Padding(padding:const  EdgeInsets.all(6.0),child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
   Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "Shipper",
                                                        ),
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              Colors.green,
                                                          child: IconButton(
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                // var long2 = double
                                                                //     .parse(item
                                                                //         .sender!
                                                                //         .lat!);
                                                                // var lut = double
                                                                //     .parse(item
                                                                //         .sender!
                                                                //         .lng!);

                                                                // MapsLauncher
                                                                //     .launchCoordinates(
                                                                //         long2,
                                                                //         lut,
                                                                //         'Google Headquarters are here');
                                                              },
                                                              icon: const Icon(Icons
                                                                  .location_on_outlined)),
                                                        ),
                                                      ],
                                                    ),
                                                   
                                                    const SizedBox(width: 10.0),
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "Receiver",
                                                        ),
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              Colors.deepPurple,
                                                          child: IconButton(
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                // var long2 = double
                                                                //     .parse(item
                                                                //         .receiver!
                                                                //         .lat!);
                                                                // var lut = double
                                                                //     .parse(item
                                                                //         .receiver!
                                                                //         .lng!);

                                                                // MapsLauncher
                                                                //     .launchCoordinates(
                                                                //         long2,
                                                                //         lut,
                                                                //         'Google Headquarters are here');
                                                              },
                                                              icon: const Icon(Icons
                                                                  .location_on_outlined)),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
      ],
    ),),
    // iconpic: const Icon(Icons.image)
     )
  ];
  @override
  Widget build(BuildContext context) {
    return  ExpansionPanelList(
      dividerColor: Colors.grey,
      expandedHeaderPadding: const  EdgeInsets.all(8.0),
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              itemResult[panelIndex].isExpanded = !itemResult[panelIndex].isExpanded;
            });
            
          },
          elevation: 0,
          children: itemResult.map((ItemMode item) {
return ExpansionPanel(
  canTapOnHeader: true,

  headerBuilder: (context, isExpanded) {

 return ListTile(
  // leading: item.iconpic,
  title: Text(item.header),
 ); 
},
isExpanded: item.isExpanded,
 body: item.body);
          }).toList(),
        );
        
      
  }
}