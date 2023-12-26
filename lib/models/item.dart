// ignore_for_file: slash_for_doc_comments

import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * Data model for Item document in Firestore
 */
class Item {
  String id;
  final Timestamp? timeCreated;
  final String? itemName;
  final String? description;
  final num? phone;
  final String? picture;
  final GeoPoint? location;

  Item(
      {
      this.id = "",
      this.timeCreated,
      this.itemName,
      this.description,
      this.phone,
      this.picture,
      this.location});

  factory Item.fromFirestore(
    QueryDocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return Item(
        id: snapshot.id,
        itemName: data['itemName'],
        description: data['description'],
        location: data['location'],
        phone: data['phone'],
        picture: data['picture'] is int ? '' : data['picture']); //because some pictures entries are of numbers
  }

  Map<String, dynamic> toFirestore() {
    return {
      'timeCreated': timeCreated,
      'description': description,
      'itemName': itemName,
      'location': location,
      'phone': phone,
      'picture': picture
    };
  }
}
