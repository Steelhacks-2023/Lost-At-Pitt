import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/authentication/auth.dart';
import 'package:lost_found_steelhacks/pages/list_page.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/pages/map_page.dart';
import 'package:provider/provider.dart';
import 'package:lost_found_steelhacks/routing/route.dart';

class NavBar extends StatelessWidget {
  NavBar(
      {super.key,
      required this.lostObjects,
      required this.foundObjects,
      required this.mode});

  final List<Item> lostObjects;
  final List<Item> foundObjects;
  final bool mode;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color.fromARGB(255, 217, 235, 255),
      width: double.infinity,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        IconButton(
          icon: const Icon(Icons.explore),
          onPressed: () => routePage(const MapPage(), context),
        ),
        IconButton(
          icon: const Icon(Icons.format_list_numbered),
          onPressed: () => routePage(
              ListPage(
                  lostObjects: lostObjects,
                  foundObjects: foundObjects,
                  mode: !mode),
              context),
        ),
        IconButton(
          icon: const Icon(Icons.message),
          onPressed: () => {},
        ),
        IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushNamed(context, "/");
            }),
      ]),
    );
  }
}
