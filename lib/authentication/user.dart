import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final GeoPoint? location;

  MyUser({required this.uid, this.email, this.firstName, this.lastName, this.location});
}
