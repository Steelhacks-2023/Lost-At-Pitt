// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/data/app_user.dart';
import 'package:lost_found_steelhacks/services/auth_service.dart';
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
    AppUser user = context.watch<AppUser>();
    return Center(
        child: Column(children: [
      Text("Signed in: ${user.firstName}"),
      OutlinedButton(
          onPressed: () async => await AuthService.signOut(),
          child: const Icon(Icons.logout))
    ]));
  }
}
