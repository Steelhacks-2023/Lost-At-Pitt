import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/authentication/wrapper.dart';
import 'package:lost_found_steelhacks/pages/post_page.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/pages/item_request2.dart';
import 'package:lost_found_steelhacks/routing/nav_bar.dart';
import 'package:lost_found_steelhacks/utils.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:rxdart/rxdart.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Item> currentLostItems = [];
  List<Item> currentFoundItems = [];
  int currentPageIndex = 0;
  late GoogleMapController mapController;
  BitmapDescriptor lostMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor foundMarkerIcon = BitmapDescriptor.defaultMarker;
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  int counter = 0;
  bool pageOpen = false;
  final Stream<QuerySnapshot> _lostCollectionStream =
      FirebaseFirestore.instance.collection('Lost').snapshots();
  final Stream<QuerySnapshot> _foundCollectionStream =
      FirebaseFirestore.instance.collection('Found').snapshots();
  //University of Pittsburgh Coordinates - move to a JSON file
  final LatLng _center = const LatLng(40.4443533, -79.960835);

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(40, 40)),
            'assets/location-pin.png')
        .then((icon) {
      setState(() {
        foundMarkerIcon = icon;
      });
    });
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(40, 40)), 'assets/lost-pin.png')
        .then((icon) {
      setState(() {
        lostMarkerIcon = icon;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyle);
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder2<QuerySnapshot, QuerySnapshot>(
        streams: StreamTuple2(
          _lostCollectionStream,
          _foundCollectionStream,
        ),
        builder: (BuildContext context,
            SnapshotTuple2<QuerySnapshot, QuerySnapshot> snapshot) {
          AsyncSnapshot<QuerySnapshot> lostSnapshot = snapshot.snapshot1;
          AsyncSnapshot<QuerySnapshot> foundSnapshot = snapshot.snapshot2;
          bool error = lostSnapshot.hasError || foundSnapshot.hasError;
          bool waiting =
              lostSnapshot.connectionState == ConnectionState.waiting ||
                  foundSnapshot.connectionState == ConnectionState.waiting;
          if (error || waiting) return const Wrapper();

          List<Item> lostItems = getItems(lostSnapshot, true);
          List<Item> foundItems = getItems(foundSnapshot, false);

          return buildMap(context, lostItems, foundItems);
        });
  }

  // Builds the map Scaffold
  Scaffold buildMap(
      BuildContext context, List<Item> lostItems, List<Item> foundItems) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Expanded(
                  flex: 0,
                  child: NavBar(
                      lostObjects: lostItems,
                      foundObjects: foundItems,
                      mode: true)),
              Expanded(
                flex: 5,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 16,
                  ),
                  onTap: (coords) => addPin(coords),
                  markers: Set<Marker>.of(markers.values),
                ),
              ),
            ])));
  }

  // Add a pin to the map
  void addPin(LatLng coords) {
    final MarkerId markerId = MarkerId("ID $counter");

    // creating a new MARKER
    final Marker marker =
        Marker(markerId: markerId, icon: lostMarkerIcon, position: coords);
    counter++;
    setState(() {
      markers[markerId] = marker;
    });
    routeSubpage(ItemRequest(itemLoc: coords), context);
  }

  // Iterate through the snapshot of found items, return list of markers
  List<Item> getItems(AsyncSnapshot<QuerySnapshot> snapshot, bool lost) {
    List<Item> objects = [];
    //query database, go through each item in database, and create list of lost objects
    for (int i = 0; i < snapshot.data!.size; i++) {
      QueryDocumentSnapshot singleDoc = snapshot.requireData.docs[i];
      var data = singleDoc.data() as Map;
      Item item = Item.fromFirestore(singleDoc, null);
      objects.add(item);
      GeoPoint geo = data["Location"];
      final MarkerId temp = MarkerId(singleDoc.id);
      final Marker marker = Marker(
          markerId: temp,
          icon: lost ? lostMarkerIcon : foundMarkerIcon,
          position: LatLng(geo.latitude, geo.longitude),
          onTap: () => routeSubpage(PostPage(item: item), context));
      markers[temp] = marker;
    }
    return objects;
  }
}
