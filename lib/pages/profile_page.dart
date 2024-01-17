// ignore_for_file: slash_for_doc_comments

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:lost_found_steelhacks/data/app_user.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/services/auth_service.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:lost_found_steelhacks/widgets/post_card.dart';
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

    Widget buildHeader() {
      Widget buildProfilePicture() => Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: theme.veryLight),
            padding: const EdgeInsets.all(3.0),
            child: ProfilePicture(
                name: user.displayName(), radius: 30, fontsize: 20),
          ));

      Widget buildUserInformation() => Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.displayName(), style: theme.veryDarkTitleStyle),
                Text("${user.email}", style: theme.darkSubtitleStyle)
              ]));

      return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(5),
              decoration: bodyDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [buildProfilePicture(), buildUserInformation()],
              )));
    }

    Widget buildRecentPost() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Text("Your recent activity",
                style: theme.veryDarkSubtitleStyle),
          ),
          PostCard(
            item: Item(
                id: '',
                userId: user.uid,
                timeCreated: Timestamp.now(),
                itemName: 'Placeholder item',
                description: 'Description of the item',
                phone: 0,
                picture: '',
                location: const GeoPoint(0, 0)),
          ),
        ],
      );
    }

    Widget buildOptions() {
      Widget buildButtonBody(Icon icon, String text) => Container(
          decoration: const BoxDecoration(),
          padding: const EdgeInsets.all(8),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: icon,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(text, style: theme.veryDarkSubtitleStyle),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.arrow_right, color: theme.dark),
            )
          ]));

      return Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  child: buildButtonBody(
                      Icon(Icons.list, color: theme.dark), "Submitted posts"),
                  onTap: () => {}),
              GestureDetector(
                  child: buildButtonBody(
                      Icon(Icons.settings, color: theme.dark), "Settings"),
                  onTap: () => {}),
              GestureDetector(
                  child: buildButtonBody(
                      Icon(Icons.question_mark_outlined, color: theme.dark),
                      "Something else"),
                  onTap: () => {}),
              GestureDetector(
                  child: buildButtonBody(
                      Icon(Icons.logout, color: theme.dark), "Sign out"),
                  onTap: () async => await AuthService.signOut())
            ],
          ));
    }

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            buildHeader(),
            const SizedBox(height: 10),
            buildRecentPost(),
            const SizedBox(height: 10),
            buildOptions(),
          ]),
        ),
      ),
    );
  }
}
