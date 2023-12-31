// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/authentication/auth.dart';
import 'package:provider/provider.dart';

/**
 * UI to display the user's profile. 
 * Currently just is a text box for debugging purposes
 */
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Signed in: ${context.read<AuthService>().isSignedIn().toString()}"));
  }

}