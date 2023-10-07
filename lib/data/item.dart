import 'package:cloud_firestore/cloud_firestore.dart';

// In the future we will want to override this class to lost vs. found objects
class Item {
  final String? itemName;
  final String? description;
  final num? phone;
  final int? picture;
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
    //final data = snapshot.data();
    return Item(
        itemName: snapshot.get('ItemName'),
        description: snapshot.get('Description'),
        location: snapshot.get('Location'),
        phone: snapshot.get('Phone'),
        picture: snapshot.get('Picture'));
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (itemName != null) "name": itemName,
      if (description != null) "description": description
    };
  }
}
