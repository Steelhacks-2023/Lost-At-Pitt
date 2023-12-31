import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/authentication/loading_animation.dart';
import 'package:lost_found_steelhacks/cards/post_card.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isValidSnapshot(AsyncSnapshot<QuerySnapshot> snapshot) =>
      !snapshot.hasError && snapshot.connectionState != ConnectionState.waiting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return buildPage(theme, Provider.of<List<Item>>(context), []);
  }

  List<PostCard> getListEntries(List<Item> objects) {
    List<PostCard> cards = [];
    for (Item e in objects) {
      cards.add(PostCard(item: e));
    }
    return cards;
  }

  Widget buildPage(theme, List<Item> lostItems, List<Item> foundItems) {
    List<Item> itemsToDisplay = lostItems;
    itemsToDisplay.addAll(foundItems);

    return Container(
        decoration: theme.constantBackgroundDecoration,
        child: ListView(children: getListEntries(itemsToDisplay)));
  }
}
