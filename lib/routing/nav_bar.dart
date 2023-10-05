import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/listPage.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
import 'package:lost_found_steelhacks/mapPage.dart';
import 'package:lost_found_steelhacks/routing/hero_dialog_route.dart';

class NavBar extends StatelessWidget {
  NavBar(
      {super.key,
      required this.lostObjects,
      required this.foundObjects,
      required this.mode});

  final List<LostAndFoundObject> lostObjects;
  final List<LostAndFoundObject> foundObjects;
  bool mode = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color.fromARGB(255, 217, 235, 255),
      width: double.infinity,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        IconButton(
          icon: const Icon(Icons.explore),
          onPressed: () => route(const mapPage(), context),
        ),
        IconButton(
          icon: const Icon(Icons.format_list_numbered),
          onPressed: () => route(
              listPage(
                  lostObjects: lostObjects,
                  foundObjects: foundObjects,
                  mode: !mode),
              context),
        ),
        IconButton(
          icon: const Icon(Icons.message),
          onPressed: () => {},
        ),
      ]),
    );
  }
}
