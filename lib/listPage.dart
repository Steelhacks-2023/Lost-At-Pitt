import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
<<<<<<< HEAD
import 'package:lost_found_steelhacks/postPage.dart';

class listPage extends StatefulWidget {
  final double spacing = 10;
  final double border_radius = 5;
=======

class listPage extends StatefulWidget {
  final double spacing = 10;
>>>>>>> 00a627329f86ee83ef09313a241d5cbeea81181c
  final List<LostAndFoundObject> entries;
  const listPage({super.key, required this.entries});

  List<LostAndFoundObject> getEntries() {
    return entries;
  }
<<<<<<< HEAD

=======
>>>>>>> 00a627329f86ee83ef09313a241d5cbeea81181c
  @override
  State<listPage> createState() => _listPageState();
}

class _listPageState extends State<listPage> {
<<<<<<< HEAD
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lost and Found"),
        ),
        body: ListView(children: get_list_entries()));
=======

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: get_list_entries()
      )
    );
>>>>>>> 00a627329f86ee83ef09313a241d5cbeea81181c
  }

  List<Widget> get_list_entries() {
    List<Widget> containers = [];
    for (LostAndFoundObject e in widget.entries) {
<<<<<<< HEAD
      // Padding
      containers.add(Padding(padding: EdgeInsets.all(widget.spacing)));
      // Entry
      containers.add(
        InkWell(
          child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.border_radius))),
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
=======
      containers.add(
        Container(
          height: 100,
          color: Color.fromARGB(255, 14, 165, 192),
          child: ListView(children: [
            Text(e.itemName.toString()),
            Text(e.phone.toString()),
            Text(e.description.toString())
          ]) 
        )
      );
      containers.add(
        Padding(padding: EdgeInsets.all(widget.spacing))
      );
    };
    return containers;
  }
}
>>>>>>> 00a627329f86ee83ef09313a241d5cbeea81181c
