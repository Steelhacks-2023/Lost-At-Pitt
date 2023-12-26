// ignore_for_file: slash_for_doc_comments

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/models/app_user.dart';

/**
 * Singleton service for making Firebase calls
 */
class FirebaseService {
  
  /* Singleton setup */
  static final FirebaseService instance = FirebaseService._internal();
  factory FirebaseService() => instance;
  FirebaseService._internal();

  final FirebaseFirestore database = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> lostStream =
      FirebaseFirestore.instance.collection('lost').snapshots();
  final Stream<QuerySnapshot> foundStream =
      FirebaseFirestore.instance.collection('found').snapshots();

  Future<void> createUser(AppUser user) async {
    await database.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'location': user.location
    });
  }

  Future<AppUser> getUser(String uid) async {
    DocumentSnapshot snapshot =
        await database.collection('users').doc(uid).get();
    AppUser user = AppUser(
        uid: snapshot["uid"],
        email: snapshot["email"],
        firstName: snapshot["firstName"],
        lastName: snapshot["lastName"],
        location: snapshot["location"]);
    return user;
  }

  Future<bool> userExists(String uid) async {
    DocumentSnapshot snapshot = await database.collection('users').doc(uid).get();
    return snapshot.exists;
  }


}
