import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/authentication/loading_animation.dart';
import 'package:lost_found_steelhacks/cards/post_card.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

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
    return StreamBuilder2<QuerySnapshot, QuerySnapshot>(
        streams: StreamTuple2(
            FirebaseFirestore.instance.collection('lost').snapshots(),
            FirebaseFirestore.instance.collection('found').snapshots()),
        builder: (BuildContext context,
            SnapshotTuple2<QuerySnapshot, QuerySnapshot> snapshot) {
          AsyncSnapshot<QuerySnapshot> lostSnapshot = snapshot.snapshot1;
          AsyncSnapshot<QuerySnapshot> foundSnapshot = snapshot.snapshot2;

          /* Check if the snapshot can be parsed */
          if (!isValidSnapshot(lostSnapshot) ||
              !isValidSnapshot(foundSnapshot)) {
            return const Loading();
          }

          return buildPage(theme, getItemsFromSnapshot(lostSnapshot),
              getItemsFromSnapshot(foundSnapshot));
        });
  }

  List<PostCard> getListEntries(List<Item> objects) {
    List<PostCard> cards = [];
    for (Item e in objects) {
      cards.add(PostCard(item: e));
    }
    return cards;
  }

  List<Item> getItemsFromSnapshot(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return [];
    List<Item> items = [];
    for (QueryDocumentSnapshot document in snapshot.data!.docs) {
      Item item = Item.fromFirestore(document, null);
      items.add(item);
    }
    return items;
  }

  Widget buildPage(theme, List<Item> lostItems, List<Item> foundItems) {
    List<Item> itemsToDisplay = lostItems;
    itemsToDisplay.addAll(foundItems);

    return 
      Container(
          decoration: theme.constantBackgroundDecoration,
          child: ListView(children: getListEntries(itemsToDisplay)));
  }
}
