import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lost_found_steelhacks/data/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/services/firestore_service.dart';

class AuthService extends ChangeNotifier {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<AppUser?> userFromFirebaseUser(String? uid) async =>
      FirestoreService.getAppUser(uid);

  static bool isSignedIn() => _auth.currentUser != null;

  //auth change user stream
  static Stream<AppUser?> get appUserStream => _auth
      .authStateChanges()
      .asyncMap((user) => userFromFirebaseUser(user?.uid));

  // register with Email and Password
  static Future<bool> registerWithEmailAndPassword(
      String firstName, String lastName, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //create entry if firestore of user info
      _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'email': result.user!.email,
        'firstName': firstName,
        'lastName': lastName,
        'location': const GeoPoint(40.4440279, -79.9700647)
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //sign in with email and password
  static Future<void> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    _firestore.collection('users').doc(result.user!.uid).set({
      'uid': result.user!.uid,
      'email': result.user!.email,
      'location': const GeoPoint(40.4440279, -79.9700647)
    }, SetOptions(merge: true));
  }

  //sign in with google
  static Future<void> signInWithGoogle() async {
    UserCredential result;
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        // googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        // googleProvider.setCustomParameters({
        //   'login_hint': 'user@example.com'
        // });

        result = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

        result = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      User? user = result.user;

      String? firstName;
      String? lastName;

      //this needed to add user info and splits via first and last name
      //works for GoogleAuth if we extend to other methods need to check more
      for (final providerProfile in user!.providerData) {
        String? name = providerProfile.displayName;
        firstName = name!.split(' ')[0];
        lastName = name.split(' ')[1];
      }

      _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'email': result.user!.email,
        'firstName': firstName ?? '',
        'lastName': lastName ?? '',
        'location': const GeoPoint(40.4440279, -79.9700647)
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  //sign out logic
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
