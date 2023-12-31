import 'package:cloud_firestore/cloud_firestore.dart';

// In the future we will want to override this class to lost vs. found objects
class Item {
  final String id;
  final String userId;
  final Timestamp? timeCreated;
  final String itemName;
  final String description;
  final num phone;
  final String picture;
  final GeoPoint location;

  Item(
      {required this.id,
      required this.userId,
      required this.timeCreated,
      required this.itemName,
      required this.description,
      required this.phone,
      required this.picture,
      required this.location});

  factory Item.fromFirestore(
    QueryDocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    try {
      return Item(
          id: snapshot.id,
          userId: data['userId'],
          timeCreated: data['timeCreated'],
          itemName: data['itemName'],
          description: data['description'],
          location: data['location'],
          phone: data['phone'],
          picture: data['picture'] is int
              ? ''
              : data[
                  'picture']); //because some pictures entries are of numbers
    } catch (e) {
      print('Unable to create item');
      return Item(
          id: 'No ID Found',
          userId: 'No User Id',
          timeCreated: Timestamp.now(),
          itemName: "Error Item",
          description: e.toString(),
          phone: 1111111111,
          picture: 'No Image Found',
          location: GeoPoint(0, 0));
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'timeCreated': timeCreated,
      "itemName": itemName,
      "description": description,
      "phone": phone,
      "picture": picture,
      "location": location,
    };
  }
}
