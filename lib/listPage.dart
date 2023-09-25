import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/cards/postCard.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
import 'package:lost_found_steelhacks/pages/postPage.dart';
import 'package:lost_found_steelhacks/mapPage.dart';

class listPage extends StatefulWidget {
  final double spacing = 10;
  final double border_radius = 5;
  final List<LostAndFoundObject> lostObjects;
  final List<LostAndFoundObject> foundObjects;
  final bool mode;

  const listPage(
      {super.key,
      required this.lostObjects,
      required this.foundObjects,
      required this.mode});

  List<LostAndFoundObject> getEntries() {
    return lostObjects;
  }

  @override
  State<listPage> createState() => _listPageState();
}

class _listPageState extends State<listPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        NavigationBar(
          onDestinationSelected: (int index) => setState(() => route(index)),
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.explore),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.format_list_numbered),
              label: 'List',
            ),
          ],
        ),
        Expanded(
          child: Container(
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

  void route(int index) {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => mapPage()));
    } else if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => listPage(
                  lostObjects: widget.lostObjects,
                  foundObjects: widget.foundObjects,
                  mode: !widget.mode)));
    }
  }
}
