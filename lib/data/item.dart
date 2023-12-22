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
        itemName: data['ItemName'],
        description: data['Description'],
        location: data['Location'],
        phone: data['Phone'],
        picture: data['Picture'] is int ? '' : data['Picture']); //because some pictures entries are of numbers
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (itemName != null) "name": itemName,
      if (description != null) "description": description
    };
  }
}
