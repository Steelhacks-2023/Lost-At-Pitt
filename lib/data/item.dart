import 'package:cloud_firestore/cloud_firestore.dart';

// In the future we will want to override this class to lost vs. found objects
class Item {
  final String? itemName;
  final String? description;
  final num? phone;
  final String? picture;
  final GeoPoint? location;

  Item(
      {this.itemName,
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
        itemName: data['itemName'],
        description: data['description'],
        location: data['location'],
        phone: data['phone'],
        picture: data['picture'] is int ? '' : data['picture']); //because some pictures entries are of numbers
  }

  Map<String, dynamic> toFirestore() {
    return {
      "itemName": itemName,
      "description": description,
      "phone": phone,
      "picture": picture,
      "location": location,
    };
  }
}
