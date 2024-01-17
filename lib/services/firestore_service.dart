import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/data/app_user.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  //create reference to database
  static final lostRef = FirebaseFirestore.instance.collection('lost');
  static final foundRef = FirebaseFirestore.instance.collection('found');
  static final usersRef = FirebaseFirestore.instance.collection('users');

  //adding Item Object to backend
  static Future<void> addItemToFirestore(Item item, bool lost) => lost
      ? lostRef.doc().set(item.toFirestore())
      : foundRef.doc().set(item.toFirestore());

  //stream Items
  static Stream<List<Item>> getLostItemsStream() {
    Stream<QuerySnapshot> querySnap = lostRef.snapshots();
    return querySnap.map((snapshot) {
      return snapshot.docs.map((e) => Item.fromFirestore(e, null)).toList();
    });
  }

  static Stream<List<Item>> getFoundItemsStream() {
    Stream<QuerySnapshot> querySnap = foundRef.snapshots();
    return querySnap.map((snapshot) {
      return snapshot.docs.map((e) => Item.fromFirestore(e, null)).toList();
    });
  }

  static Stream<List<Item>> getItemsStream() {
    return Rx.combineLatest2(lostRef.snapshots(), foundRef.snapshots(), (a, b) {
      return List.from(a.docs.map((e) => Item.fromFirestore(e, null)).toList())
        ..addAll(b.docs.map((e) => Item.fromFirestore(e, null)).toList());
    });
  }

  static Future<AppUser?> getAppUser(String? uid) async {
    DocumentSnapshot<Map<String, dynamic>> querySnap =
        await usersRef.doc(uid).get();
    return AppUser.fromFirestore(querySnap, null);
  }
}
