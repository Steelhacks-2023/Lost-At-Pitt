import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/cards/postCard.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
import 'package:lost_found_steelhacks/routing/nav_bar.dart';

class listPage extends StatefulWidget {
  final List<LostAndFoundObject> lostObjects;
  final List<LostAndFoundObject> foundObjects;
  final bool mode;

  const listPage(
      {super.key,
      required this.lostObjects,
      required this.foundObjects,
      required this.mode});

  @override
  State<listPage> createState() => _listPageState();
}

class _listPageState extends State<listPage> {
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
    List<LostAndFoundObject> objects =
        widget.mode ? widget.lostObjects : widget.foundObjects;
    for (LostAndFoundObject e in objects) {
      cards.add(PostCard(item: e));
    }
    return cards;
  }
}
