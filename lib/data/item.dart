import 'package:cloud_firestore/cloud_firestore.dart';

// In the future we will want to override this class to lost vs. found objects
class Item {
  final String? itemId;
  final String? itemName;
  final String? description;
  final num? phone;
  final String? picture;
  final GeoPoint? location;

  Item(
      {this.itemId,
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
        itemId: snapshot.id,
        itemName: data['itemName'],
        description: data['description'],
        location: data['location'],
        phone: data['phone'],
        picture: data['picture'] is int
            ? ''
            : data['picture']); //because some pictures entries are of numbers
  }

  //to use randomVarName = db.collection().withConverter(fromFirestore: Item.fromFirestore, toFirestore: (Item item, options) => item.toFirestore())
  //randomVarName.set(Item item);
  Map<String, dynamic> toFirestore() {
    return {
      if (itemName != null) 'name': itemName,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (phone != null) 'phone': phone,
      if (picture != null) 'picture': picture
    };
  }
}
