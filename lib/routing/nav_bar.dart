import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/authentication/auth.dart';
import 'package:lost_found_steelhacks/authentication/wrapper.dart';
import 'package:lost_found_steelhacks/pages/list_page.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/pages/map_page.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
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
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Container(
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.all(5),
      decoration: theme.navBarDecoration,
      width: double.infinity,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        IconButton(
          color: theme.dark,
          icon: const   Icon(Icons.explore),
          onPressed: () => routePage(const MapPage(), context),
        ),
        IconButton(
          color: theme.dark,
          icon: const Icon(Icons.format_list_numbered),
          onPressed: () => routePage(
              ListPage(
                  lostObjects: lostObjects,
                  foundObjects: foundObjects,
                  mode: !mode),
              context),
        ),
        IconButton(
          color: theme.dark,
          icon: const Icon(Icons.message),
          onPressed: () => {},
        ),
        IconButton(
            color: theme.dark,
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await authService.signOut();
              routePage(Wrapper(), context);
            }),
      ]),
    );
  }
}
