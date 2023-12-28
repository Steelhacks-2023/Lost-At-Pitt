// ignore_for_file: slash_for_doc_comments

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lost_found_steelhacks/models/item.dart';
import 'package:lost_found_steelhacks/pages/list_page.dart';
import 'package:lost_found_steelhacks/pages/login_page.dart';
import 'package:lost_found_steelhacks/pages/map_page.dart';
import 'package:lost_found_steelhacks/pages/profile_page.dart';
import 'package:lost_found_steelhacks/routing/wrapper.dart';
import 'package:lost_found_steelhacks/services/auth.dart';
import 'package:lost_found_steelhacks/services/data.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:lost_found_steelhacks/widgets/loading_animation.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

/**
 * Home page for the application
 */
class HomePage extends StatefulWidget {
  final int startingPage;
  const HomePage({super.key, this.startingPage = 0});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedPage = 0;
  AsyncSnapshot<QuerySnapshot> lostSnapshot = const AsyncSnapshot.nothing();
  AsyncSnapshot<QuerySnapshot> foundSnapshot = const AsyncSnapshot.nothing();
  List<Widget> pages = <Widget>[
    MapPage(),
    ListPage(mode: true),
    Center(child: Text("Chat")),
    ProfilePage(),
    LoginPage()
  ];

  Scaffold buildPage(AppTheme theme) => Scaffold(
        body: Center(
          child: pages.elementAt(selectedPage),
        ),
        bottomNavigationBar: Container(
          height: 80,
          decoration: theme.navBarDecoration,
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.white70,
                color: Colors.black,
                tabs: [
                  GButton(
                      icon: Icons.map,
                      text: 'Map',
                      textStyle: theme.regularStyle),
                  GButton(
                      icon: Icons.add_box,
                      text: 'Posts',
                      textStyle: theme.regularStyle),
                  GButton(
                      icon: Icons.chat,
                      text: 'Search',
                      textStyle: theme.regularStyle),
                  GButton(
                      icon: Icons.person,
                      text: 'Profile',
                      textStyle: theme.regularStyle),
                  GButton(
                      icon: Icons.logout,
                      text: 'Logout',
                      textStyle: theme.regularStyle,
                      onPressed: () async => {await AuthService.instance.signOut()})
                ],
                selectedIndex: selectedPage,
                onTabChange: (index) {
                  setState(() {
                    selectedPage = index;
                  });
                },
              ),
            ),
          ),
        ),
      );

  bool isValidSnapshot(AsyncSnapshot<QuerySnapshot> snapshot) =>
      !snapshot.hasError && snapshot.connectionState != ConnectionState.waiting;

  List<Item> getItemsFromSnapshot(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return [];
    List<Item> items = [];
    for (QueryDocumentSnapshot document in snapshot.data!.docs) {
      Item item = Item.fromFirestore(document, null);
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StreamBuilder2<QuerySnapshot, QuerySnapshot>(
        streams: StreamTuple2(
            FirebaseFirestore.instance.collection('lost').snapshots(),
            FirebaseFirestore.instance.collection('found').snapshots()),
        builder: (BuildContext context,
            SnapshotTuple2<QuerySnapshot, QuerySnapshot> snapshot) {
          lostSnapshot = snapshot.snapshot1;
          foundSnapshot = snapshot.snapshot2;

          /* Check if the snapshot can be parsed */
          if (!isValidSnapshot(lostSnapshot) ||
              !isValidSnapshot(foundSnapshot)) {
            return const Loading();
          }

          /* Update the item collections */
          DataService.instance.lostItems = getItemsFromSnapshot(lostSnapshot);
          DataService.instance.foundItems = getItemsFromSnapshot(foundSnapshot);

          return buildPage(theme);
        });
  }
}
