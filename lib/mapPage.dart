import 'dart:developer';
import 'dart:html';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart'
    as GWebMap;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/lostObject.dart';
import 'package:lost_found_steelhacks/lostObject.dart';
import 'package:lost_found_steelhacks/postPage.dart';
import 'package:lost_found_steelhacks/itemRequest.dart';


class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  late GoogleMapController mapController;
  var count = 0;

  final Stream<QuerySnapshot> _lostCollectionStream =
      FirebaseFirestore.instance.collection('Lost').snapshots();

  //University of Pittsburgh Coordinates
  final LatLng _center = const LatLng(40.4443533, -79.960835);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _lostCollectionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something Has Gone Wrong Please Refresh");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Waiting Getting Data");
          }

          List<Marker> listOfMarkers = [];
          List<LostObject> lostObjects = [];

          //query database, go through each item in database, and create list of lost objects
          // for (int i = 0; i < snapshot.data!.size; i++) {
          //   QueryDocumentSnapshot singleDoc = snapshot.requireData.docs[i];

          //   LostObject lostItem = LostObject.fromFirestore(singleDoc, null);
          //   lostObjects.add(lostItem);
          // }

          return Scaffold(
              body: Stack(alignment: Alignment.center, children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 16,
                ),
                
                onTap: (coords) {
                  //print(coords);
                  Navigator.push(context,MaterialPageRoute(builder: (context) => SwitchApp(coord: coords)));
                  //_onAddMarkerPress(coords);
                }, 
              ),
            //THESE ARE THE INDIVIDUAL POST AND POST CREATION BUTTONS
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: (() {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PostPage()));
                  }),
                ),

            ],
            ),

          ]));
        });
  }
}
