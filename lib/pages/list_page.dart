import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/cards/post_card.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/routing/nav_bar.dart';

class ListPage extends StatefulWidget {
  final List<Item> lostObjects;
  final List<Item> foundObjects;
  final bool mode;

  const ListPage(
      {super.key,
      required this.lostObjects,
      required this.foundObjects,
      required this.mode});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        NavBar(
            lostObjects: widget.lostObjects,
            foundObjects: widget.foundObjects,
            mode: widget.mode),
        Expanded(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(children: getListEntries())),
        )
      ]),
    );
  }

  List<PostCard> getListEntries() {
    List<PostCard> cards = [];
    List<Item> objects = widget.mode ? widget.lostObjects : widget.foundObjects;
    for (Item e in objects) {
      cards.add(PostCard(item: e));
    }
    return cards;
  }
}
