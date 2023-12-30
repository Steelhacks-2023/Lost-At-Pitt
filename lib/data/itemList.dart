import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/data/item.dart';

class ItemList {
  //when we move firebase to service we can change reference, leaving for now
  FirebaseFirestore ref = FirebaseFirestore.instance;

  Stream<List<Item>> getLostItems() {
    Stream<QuerySnapshot> querySnap = ref.collection('lost').snapshots();
    return querySnap.map((snapshot) {
      return snapshot.docs.map((e) => Item.fromFirestore(e, null)).toList();
    });
  }

  Stream<List<Item>> getFoundItems() {
    Stream<QuerySnapshot> querySnap = ref.collection('found').snapshots();
    return querySnap.map((snapshot) {
      return snapshot.docs.map((e) => Item.fromFirestore(e, null)).toList();
    });
  }
}
