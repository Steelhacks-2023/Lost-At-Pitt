// ignore_for_file: slash_for_doc_comments

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lost_found_steelhacks/services/firebase.dart';
import 'package:lost_found_steelhacks/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * Singleton Authentication service managing current user state
 */
class AuthService extends ChangeNotifier {
  
  /* Singleton setup */
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  AuthService._internal();

  final GeoPoint defaultGeopoint = const GeoPoint(40.4440279, -79.9700647);
  AppUser? user;

  bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  Stream<User?> get authUser => FirebaseAuth.instance.authStateChanges();

  Future registerWithEmailAndPassword(
      String firstName, String lastName, String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User authUser = result.user!;
      AppUser user = AppUser(
          uid: authUser.uid,
          email: authUser.email!,
          firstName: firstName,
          lastName: lastName,
          location: defaultGeopoint);
      this.user = user;
      await FirebaseService.instance.createUser(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return await FirebaseService.instance.getUser(result.user!.uid);
  }

  Future signInWithGoogle() async {
    try {
      UserCredential result;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        result = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
        result = await FirebaseAuth.instance.signInWithCredential(credential);
      }
      User authUser = result.user!;
      if (!(await FirebaseService.instance.userExists(authUser.uid))) {
        AppUser user = AppUser(
            uid: authUser.uid,
            email: authUser.email!,
            firstName: "",
            lastName: "",
            location: defaultGeopoint);
        await FirebaseService.instance.createUser(user);
      }
      return await FirebaseService.instance.getUser(authUser.uid);
    } on FirebaseAuthException {
      return null;
    }
  }

  Future<void> signOut() async => await FirebaseAuth.instance.signOut();
}
