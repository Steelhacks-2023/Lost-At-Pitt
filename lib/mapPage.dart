import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/Utils.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
import 'package:lost_found_steelhacks/listPage.dart';
import 'package:lost_found_steelhacks/itemRequest.dart';
import 'package:lost_found_steelhacks/routing/hero_dialog_route.dart';
import 'package:lost_found_steelhacks/routing/nav_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  int currentPageIndex = 0;
  late GoogleMapController mapController;
  BitmapDescriptor lostMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor foundMarkerIcon = BitmapDescriptor.defaultMarker;

  String _mapStyle = "";

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

                List<LostAndFoundObject> lostObjects = [];
                List<LostAndFoundObject> foundObjects = [];
                //query database, go through each item in database, and create list of lost objects
                for (int i = 0; i < foundSnapshot.data!.size; i++) {
                  QueryDocumentSnapshot singleDoc =
                      foundSnapshot.requireData.docs[i];
                  var data = singleDoc.data() as Map;
                  LostAndFoundObject foundItem =
                      LostAndFoundObject.fromFirestore(singleDoc, null);
                  foundObjects.add(foundItem);
                  GeoPoint geo = data["Location"];
                  //_add(geo.latitude, geo.longitude);
                  final MarkerId temp = MarkerId(singleDoc.id);
                  final Marker marker = Marker(
                      markerId: temp,
                      icon: foundMarkerIcon,
                      position: LatLng(geo.latitude, geo.longitude),
                      onTap: () => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                child: AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0))),
                                  title: Text("Item Information"),
                                  insetPadding: EdgeInsets.all(200),
                                  content: Column(
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: Container(
                                            child: Text("Item Name: " +
                                                data["ItemName"])),
                                      ),
                                      Flexible(
                                        flex: 4,
                                        fit: FlexFit.tight,
                                        child: Container(
                                            child: Text("Item Description: " +
                                                data["Description"])),
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
                                            child: Text("Contact Info: " +
                                                data["Phone"].toString())),
                                      )
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, "close"),
                                        child: const Text("Close")),
                                  ],
                                  backgroundColor: Colors.lightGreenAccent,
                                )),
                          ));

                  markers[temp] = marker;
                }

                for (int i = 0; i < lostSnapshot.data!.size; i++) {
                  QueryDocumentSnapshot singleDoc =
                      lostSnapshot.requireData.docs[i];
                  var data = singleDoc.data() as Map;
                  //print(data["Description"].toString() + data["Phone"].toString());
                  LostAndFoundObject lostItem =
                      LostAndFoundObject.fromFirestore(singleDoc, null);
                  lostObjects.add(lostItem);
                  GeoPoint geo = data["Location"];
                  //_add(geo.latitude, geo.longitude);
                  final MarkerId temp = MarkerId(singleDoc.id);
                  var markerIdVal = "Item Information";
                  final Marker marker = Marker(
                      markerId: temp,
                      icon: lostMarkerIcon,
                      position: LatLng(geo.latitude, geo.longitude),
                      onTap: () => showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext) => GestureDetector(
                                child: AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0))),
                              insetPadding: EdgeInsets.all(200),
                              title: Text("Item Information"),
                              content: Column(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.tight,
                                    child: Container(
                                        child: Text(
                                            "Item Name: " + data["ItemName"])),
                                  ),
                                  Flexible(
                                    flex: 4,
                                    fit: FlexFit.tight,
                                    child: Container(
                                        child: Text("Item Description: " +
                                            data["Description"])),
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
                                        child: Text("Contact Info: " +
                                            data["Phone"].toString())),
                                  )
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, "close"),
                                    child: const Text("Close"))
                              ],
                              backgroundColor: Colors.redAccent,
                            )),
                          ));
                  markers[temp] = marker;
                }

                PanelController _panelController = PanelController();
                var dim = MediaQuery.of(context).size;
                return Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: Container(
                        height: dim.height,
                        child: Column(children: [
                          Expanded(
                            flex: 0,
                            child: NavBar(lostObjects: lostObjects, foundObjects: foundObjects, mode: true)
                          ),
                          Expanded(
                              flex: 5,
                              child: SlidingUpPanel(
                                defaultPanelState: PanelState.CLOSED,
                                minHeight: 0,
                                isDraggable: false,
                                maxHeight: dim.height * 0.5,
                                controller: _panelController,
                                backdropEnabled: true,
                                panel: new SwitchApp(coord: tempCoords),
                                body: GoogleMap(
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(
                                    target: _center,
                                    zoom: 16,
                                  ),
                                  onTap: (coords) {
                                    _add(coords.latitude, coords.longitude);
                                    tempCoords = coords;
                                    //_panelController.open();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SwitchApp(coord: coords)));
                                  },
                                  markers: Set<Marker>.of(markers.values),
                                ),
                              )),
                        ])));
              });
        });
  }
}
