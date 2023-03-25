import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
import 'package:lost_found_steelhacks/postPage.dart';
import 'package:lost_found_steelhacks/mapPage.dart';


class listPage extends StatefulWidget {
  final double spacing = 10;
  final double border_radius = 5;
  final List<LostAndFoundObject> entries;
  const listPage({super.key, required this.entries});

  List<LostAndFoundObject> getEntries() {
    return entries;
  }

  @override
  State<listPage> createState() => _listPageState();
}

class _listPageState extends State<listPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: get_list_entries()));
  }

  List<Widget> get_list_entries() {
    List<Widget> containers = [];
    containers.add(NavigationBar(
                                onDestinationSelected: (int index) {
                                  setState(() {
                                    if (index == 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => mapPage()));
                                    }
                                  });
                                },
                                //selectedIndex: currentPageIndex,
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
                              ));
    for (LostAndFoundObject e in widget.entries) {
      // Padding
      //containers.add(Padding(padding: EdgeInsets.all(widget.spacing)));
      // Entry
      containers.add(
        InkWell(
          child: Container(
              height: 100,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 5
                  )
              ),
              //color: Color.fromARGB(255, 14, 165, 192),
              child: ListView(children: [
                Text("Item: " + e.itemName.toString()),
                Text("Contact: " + e.phone.toString()),
                Text(e.description.toString())
              ])),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PostPage(item: e)));
          }));
    }
    ;
    return containers;
  }
}
