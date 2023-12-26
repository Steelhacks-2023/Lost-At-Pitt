import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/services/data.dart';
import 'package:lost_found_steelhacks/widgets/post_card.dart';
import 'package:lost_found_steelhacks/models/item.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';

/**
 * Displays current posts in a list format
 */
class ListPage extends StatefulWidget {
  final bool mode;

  const ListPage({super.key, required this.mode});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;

    return Scaffold(
        body: Container(
          decoration: theme.constantBackgroundDecoration,
          height: MediaQuery.of(context).size.height,
          child: ListView(children: getListEntries())),
    );
  }

  List<PostCard> getListEntries() {
    List<PostCard> cards = [];
    List<Item> objects = widget.mode
        ? DataService.instance.lostItems
        : DataService.instance.foundItems;
    for (Item e in objects) {
      cards.add(PostCard(item: e));
    }
    return cards;
  }
}
