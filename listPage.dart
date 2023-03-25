import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';

class listPage extends StatefulWidget {
  final double spacing = 10;
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
      body: ListView(
        children: get_list_entries()
      )
    );
  }

  List<Widget> get_list_entries() {
    List<Widget> containers = [];
    for (LostAndFoundObject e in widget.entries) {
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