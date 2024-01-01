import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lost_found_steelhacks/authentication/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create user obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  //auth change user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // register with Email and Password
  Future registerWithEmailAndPassword(String _firstName, String _lastName,
      String _email, String _password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      User? user = result.user;

      //create entry if firestore of user info
      _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'email': result.user!.email,
        'firstName': _firstName,
        'lastName': _lastName,
        'location': GeoPoint(40.4440279, -79.9700647)
      });

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String _email, String _password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: _email, password: _password);

    _firestore.collection('users').doc(result.user!.uid).set({
      'uid': result.user!.uid,
      'email': result.user!.email,
      'location': GeoPoint(40.4440279, -79.9700647)
    }, SetOptions(merge: true));

    return _userFromFirebaseUser(result.user);
  }

  //sign in with google
  Future signInWithGoogle() async {
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
        'location': GeoPoint(40.4440279, -79.9700647)
      }, SetOptions(merge: true));
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  //sign out logic
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<MyUser?> currentUser() async {
    return _userFromFirebaseUser(_auth.currentUser);
  }
}
