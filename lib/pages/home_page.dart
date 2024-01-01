// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lost_found_steelhacks/authentication/auth.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/pages/chat_page.dart';
import 'package:lost_found_steelhacks/pages/list_page.dart';
import 'package:lost_found_steelhacks/pages/login_page.dart';
import 'package:lost_found_steelhacks/pages/map_page.dart';
import 'package:lost_found_steelhacks/pages/profile_page.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:provider/provider.dart';

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
  List<Widget> pages = const <Widget>[
    MapPage(),
    ListPage(),
    ChatPage(),
    ProfilePage(),
    LoginPage()
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;


    return Scaffold(
      body: Center(
        child: pages.elementAt(selectedPage),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: theme.navBarDecoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
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
                    onPressed: () async =>
                        {await AuthService().signOut()})
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
  }
}
