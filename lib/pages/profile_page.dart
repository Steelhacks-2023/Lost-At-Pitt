// ignore_for_file: slash_for_doc_comments

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:lost_found_steelhacks/data/app_user.dart';
import 'package:lost_found_steelhacks/services/auth_service.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
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
    final theme = Theme.of(context).extension<AppTheme>()!;
    final BoxDecoration bodyDecoration = BoxDecoration(
        color: theme.medium,
        borderRadius: const BorderRadius.all(Radius.circular(10)));

    Widget buildProfilePicture() => Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: theme.veryLight),
          padding: const EdgeInsets.all(3.0),
          child: const ProfilePicture(name: "Name", radius: 30, fontsize: 20),
        ));

    Widget buildUserInformation() => Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${user.firstName} ${user.lastName}",
                  style: theme.veryDarkTitleStyle),
              Text("${user.email}", style: theme.darkSubtitleStyle)
            ]));

    Widget buildButtonBody(Icon icon, String text) => Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          icon,
          Text(text, style: theme.veryDarkSubtitleStyle),
          const Spacer(),
          Icon(Icons.arrow_right, color: theme.light)
        ]));

    Widget buildBody() => Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                child: buildButtonBody(
                    Icon(Icons.square, color: theme.veryDark),
                    "Submitted posts"),
                onTap: () => {}),
            GestureDetector(
                child: buildButtonBody(
                    Icon(Icons.square, color: theme.veryDark), "Settings"),
                onTap: () => {}),
            GestureDetector(
                child: buildButtonBody(
                    Icon(Icons.square, color: theme.veryDark),
                    "Something else"),
                onTap: () => {}),
          ],
        ));

    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(5),
                decoration: bodyDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [buildProfilePicture(), buildUserInformation()],
                ))),
        buildBody(),
        TextButton.icon(
            onPressed: () async => await AuthService.signOut(),
            label: Text("Sign out", style: theme.veryDarkRegularStyle),
            icon: Icon(Icons.logout, color: theme.veryDark))
      ]),
    );
  }
}
