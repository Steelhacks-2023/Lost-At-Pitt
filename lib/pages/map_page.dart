import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/authentication/loading_animation.dart';
import 'package:lost_found_steelhacks/pages/post_page.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/pages/item_request.dart';
import 'package:lost_found_steelhacks/utils.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';

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
  bool pageOpen = false;
  //University of Pittsburgh Coordinates - move to a JSON file
  final LatLng _center = const LatLng(40.4443533, -79.960835);

  @override
  void initState() {
    if (mounted) {
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
              const ImageConfiguration(size: Size(40, 40)),
              'assets/lost-pin.png')
          .then((icon) {
        setState(() {
          lostMarkerIcon = icon;
        });
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyle);
    mapController = controller;
  }

  bool isValidSnapshot(AsyncSnapshot<QuerySnapshot> snapshot) =>
      !snapshot.hasError && snapshot.connectionState != ConnectionState.waiting;

  @override
  Widget build(BuildContext context) {
    return buildMap(context, context.read<List<Item>>());
    ;
  }

  // Builds the map Scaffold
  Widget buildMap(BuildContext context, List<Item> foundItems) {
    getMarkersFromItems(foundItems);
    return GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 16,
        ),
        onTap: (coords) => addPin(coords),
        markers: Set<Marker>.of(markers.values));
  }

  // Add a pin to the map
  void addPin(LatLng coords) {
    routeSubpage(ItemRequest(itemLoc: coords), context);
  }

  void getMarkersFromItems(List<Item> items) {
    for (Item item in items) {
      GeoPoint geo = item.location;
      final MarkerId markerId = MarkerId(item.id);
      final Marker marker = Marker(
          markerId: markerId,
          icon: foundMarkerIcon,
          position: LatLng(geo.latitude, geo.longitude),
          onTap: () => routeSubpage(PostPage(item: item), context));
      markers[markerId] = marker;
    }
  }
}
