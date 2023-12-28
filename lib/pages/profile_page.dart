// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/services/auth.dart';

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
    return Center(child: Text(AuthService.instance.user?.firstName ?? "null"));
  }
  
}