// ignore_for_file: slash_for_doc_comments

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


/**
 * Data model for User document in Firestore
 */
class AppUser {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final GeoPoint location;

  AppUser(
      {required this.uid,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.location});

  LatLng getLatLng() {
    return LatLng(location.latitude, location.longitude);
  }
}
