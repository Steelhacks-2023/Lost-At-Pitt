// ignore_for_file: slash_for_doc_comments

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lost_found_steelhacks/pages/post_page.dart';
import 'package:lost_found_steelhacks/services/auth.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/models/item.dart';
import 'package:lost_found_steelhacks/pages/item_request.dart';
import 'package:lost_found_steelhacks/services/data.dart';
import 'package:lost_found_steelhacks/utils.dart';

/**
 * Displays the posted items on a Google map
 */
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  BitmapDescriptor lostMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor foundMarkerIcon = BitmapDescriptor.defaultMarker;
  late List<Item> currentLostItems;
  late List<Item> currentFoundItems;
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  int counter = 0;

  @override
  void initState() {
    super.initState();
    currentLostItems = DataService.instance.lostItems;
    currentFoundItems = DataService.instance.foundItems;

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

  void addPinToMap(LatLng coords) {
    final MarkerId markerId = MarkerId("ID $counter");

    // creating a new MARKER
    final Marker marker = Marker(
        markerId: markerId, icon: lostMarkerIcon, position: coords);
    counter++;
    setState(() {
      markers[markerId] = marker;
    });
    routeSubpage(ItemRequest(itemLoc: coords), context);
  }

  Map<MarkerId, Marker> getMarkersFromItems(List<Item> items, bool lost) {
    Map<MarkerId, Marker> markers = {};
    for (Item item in items) {
      GeoPoint geo = item.location ?? const GeoPoint(0, 0);
      final MarkerId markerId = MarkerId(item.id);
      final Marker marker = Marker(
          markerId: markerId,
          icon: lost ? lostMarkerIcon : foundMarkerIcon,
          position: LatLng(geo.latitude, geo.longitude),
          onTap: () => routeSubpage(PostPage(item: item), context));
      markers[markerId] = marker;
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    markers = getMarkersFromItems(DataService.instance.lostItems, true);
    markers.addAll(getMarkersFromItems(DataService.instance.foundItems, false));
    return GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: AuthService.instance.user?.getLatLng() ??
                      const LatLng(40.4443533, -79.960835),
                  zoom: 16,
                ),
                onTap: (coords) => addPinToMap(coords),
                markers: Set<Marker>.of(markers.values),

    );

  }
}
