import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/routing/hero_dialog_route.dart';
import 'package:lost_found_steelhacks/utils.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/pages/item_request.dart';
import 'package:lost_found_steelhacks/routing/nav_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int currentPageIndex = 0;
  late GoogleMapController mapController;
  BitmapDescriptor lostMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor foundMarkerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    setFoundIcon();
    setLostIcon();
  }

  void setFoundIcon() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(40, 40)),
            'assets/location-pin.png')
        .then((icon) {
      setState(() {
        foundMarkerIcon = icon;
      });
    });
  }

  void setLostIcon() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(40, 40)), 'assets/lost-pin.png')
        .then((icon) {
      setState(() {
        lostMarkerIcon = icon;
      });
    });
  }

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  int counter = 0;
  LatLng tempCoords = LatLng(0, 0);

  void _add(double lat, double long) {
    final MarkerId markerId = MarkerId("ID" + counter.toString());

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      icon: lostMarkerIcon,
      position: LatLng(
        lat,
        long,
      ),
      //infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      // onTap: () {
      //   _onMarkerTapped(markerId);
      // },
    );
    counter++;
    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  final Stream<QuerySnapshot> _lostCollectionStream =
      FirebaseFirestore.instance.collection('Lost').snapshots();

  final Stream<QuerySnapshot> _foundCollectionStream =
      FirebaseFirestore.instance.collection('Found').snapshots();

  //University of Pittsburgh Coordinates
  final LatLng _center = const LatLng(40.4443533, -79.960835);

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyle);
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _foundCollectionStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> foundSnapshot) {
          return StreamBuilder<QuerySnapshot>(
              stream: _lostCollectionStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> lostSnapshot) {
                if (lostSnapshot.hasError || foundSnapshot.hasError) {
                  return Text("Something Has Gone Wrong Please Refresh");
                } else if (lostSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    lostSnapshot.connectionState == ConnectionState.waiting) {
                  return Text("Waiting Getting Data");
                }

                List<Item> lostObjects = getLostItems(lostSnapshot);
                List<Item> foundObjects = getFoundItems(foundSnapshot);

                var dim = MediaQuery.of(context).size;
                return Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: Container(
                        height: dim.height,
                        child: Column(children: [
                          Expanded(
                              flex: 0,
                              child: NavBar(
                                  lostObjects: lostObjects,
                                  foundObjects: foundObjects,
                                  mode: true)),
                          Expanded(
                            flex: 5,
                            child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: _center,
                                zoom: 16,
                              ),
                              onTap: (coords) {
                                _add(coords.latitude, coords.longitude);
                                tempCoords = coords;
                                //_panelController.open();
                                route(ItemRequest(itemLoc: coords), context);
                              },
                              markers: Set<Marker>.of(markers.values),
                            ),
                          ),
                        ])));
              });
        });
  }

  List<Item> getFoundItems(AsyncSnapshot<QuerySnapshot> foundSnapshot) {
    List<Item> foundObjects = [];
    //query database, go through each item in database, and create list of lost objects
    for (int i = 0; i < foundSnapshot.data!.size; i++) {
      QueryDocumentSnapshot singleDoc = foundSnapshot.requireData.docs[i];
      var data = singleDoc.data() as Map;
      Item foundItem = Item.fromFirestore(singleDoc, null);
      foundObjects.add(foundItem);
      GeoPoint geo = data["Location"];
      //_add(geo.latitude, geo.longitude);
      final MarkerId temp = MarkerId(singleDoc.id);
      final Marker marker = Marker(
          markerId: temp,
          icon: foundMarkerIcon,
          position: LatLng(geo.latitude, geo.longitude),
          onTap: () => openSubmissionForm(data));

      markers[temp] = marker;
    }
    return foundObjects;
  }

  List<Item> getLostItems(AsyncSnapshot<QuerySnapshot> lostSnapshot) {
    List<Item> lostObjects = [];
    for (int i = 0; i < lostSnapshot.data!.size; i++) {
      QueryDocumentSnapshot singleDoc = lostSnapshot.requireData.docs[i];
      var data = singleDoc.data() as Map;
      //print(data["Description"].toString() + data["Phone"].toString());
      Item lostItem = Item.fromFirestore(singleDoc, null);
      lostObjects.add(lostItem);
      GeoPoint geo = data["Location"];
      //_add(geo.latitude, geo.longitude);
      final MarkerId temp = MarkerId(singleDoc.id);
      var markerIdVal = "Item Information";
      final Marker marker = Marker(
          markerId: temp,
          icon: lostMarkerIcon,
          position: LatLng(geo.latitude, geo.longitude),
          onTap: () => openSubmissionForm(data));
      markers[temp] = marker;
    }
    return lostObjects;
  }

  // Submission form UI that will have to change. We can just use the same popup UI method of doing things as we do with PostPage
  void openSubmissionForm(Map<dynamic, dynamic> data) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext) => GestureDetector(
          child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        insetPadding: EdgeInsets.all(200),
        title: Text("Item Information"),
        content: Column(
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Container(child: Text("Item Name: " + data["ItemName"])),
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Container(
                  child: Text("Item Description: " + data["Description"])),
            ),
            // Flexible(
            //   flex: 5,
            //   fit: FlexFit.tight,
            //   child: Container(
            //     child: Image.asset(data["Picture"]),
            //   )
            // ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                  child: Text("Contact Info: " + data["Phone"].toString())),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, "close"),
              child: const Text("Close"))
        ],
        backgroundColor: Colors.redAccent,
      )),
    );
  }
}
