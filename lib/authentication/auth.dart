import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lost_found_steelhacks/authentication/user.dart';
import 'package:rxdart/rxdart.dart';

class AuthService extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
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

      //create a new document for the user with the uid
      // await DatabaseService(uid: user!.uid)
      //     .updateUserData('0', 'New Username', _email, user!.uid);

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
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  //sign out logic
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      //Navigator.push("/");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<MyUser?> currentUser() async {
    return _userFromFirebaseUser(_auth.currentUser);
  }
}
