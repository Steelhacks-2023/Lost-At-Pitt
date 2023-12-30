import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/authentication/wrapper.dart';
import 'package:lost_found_steelhacks/data/itemList.dart';
import 'package:lost_found_steelhacks/pages/post_page.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/pages/item_request.dart';
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
  int currentPageIndex = 0;
  late GoogleMapController mapController;
  BitmapDescriptor lostMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor foundMarkerIcon = BitmapDescriptor.defaultMarker;
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  int counter = 0;
  bool pageOpen = false;

  //University of Pittsburgh Coordinates - move to a JSON file
  final LatLng _center = const LatLng(40.4443533, -79.960835);

  @override
  void initState() {
    super.initState();
    // markers = {};
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
    return StreamBuilder2<List<Item>, List<Item>>(
        streams:
            StreamTuple2(ItemList().getLostItems(), ItemList().getFoundItems()),
        builder: (BuildContext context, snapshots) {
          return buildMap(
              context, snapshots.snapshot1.data!, snapshots.snapshot2.data!);
        });
  }

  // Builds the map Scaffold
  Scaffold buildMap(
      BuildContext context, List<Item> lostItems, List<Item> foundItems) {
    for (var element in lostItems) {
      createMarkerFromItem(element, true);
    }
    for (var element in foundItems) {
      createMarkerFromItem(element, false);
    }
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

    routeSubpage(ItemRequest(itemLoc: coords), context);
  }

  void createMarkerFromItem(Item item, bool lost) {
    print("Item ID ${item.itemId!}");
    final MarkerId temp = MarkerId(item.itemId!);
    final Marker marker = Marker(
        markerId: temp,
        icon: lost ? lostMarkerIcon : foundMarkerIcon,
        position: LatLng(item.location!.latitude, item.location!.longitude),
        onTap: () => routeSubpage(PostPage(item: item), context));
    markers[temp] = marker;
  }
}
