import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/authentication/user.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  //create reference to database
  final lostRef = FirebaseFirestore.instance.collection('lost');
  final foundRef = FirebaseFirestore.instance.collection('found');
  final userRef = FirebaseFirestore.instance.collection('users');

  //adding Item Object to backend
  Future<void> addItemToFirestore(Item item, bool lost) {
    if (lost) {
      return lostRef.doc().set(item.toFirestore());
    } else {
      return foundRef.doc().set(item.toFirestore());
    }
  }

  //stream Items
  Stream<List<Item>> getLostItems() {
    Stream<QuerySnapshot> querySnap = lostRef.snapshots();

    return querySnap.map((snapshot) {
      return snapshot.docs.map((e) => Item.fromFirestore(e, null)).toList();
    });
  }

  Stream<List<Item>> getFoundItems() {
    Stream<QuerySnapshot> querySnap = foundRef.snapshots();
    return querySnap.map((snapshot) {
      return snapshot.docs.map((e) => Item.fromFirestore(e, null)).toList();
    });
  }

  Stream<List<Item>> getAllItems() {
    return Rx.combineLatest2(lostRef.snapshots(), foundRef.snapshots(), (a, b) {
      return List.from(a.docs.map((e) => Item.fromFirestore(e, null)).toList())
        ..addAll(b.docs.map((e) => Item.fromFirestore(e, null)).toList());
    });
  }

  // Future<MyUser> getUser(String uid) {
  //   return userRef.
  // }
}
