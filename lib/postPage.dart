import 'package:flutter/material.dart';
import 'package:icon_forest/icon_forest.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
import 'package:lost_found_steelhacks/mapPage.dart';

// title: 'Flutter Project',
// theme: ThemeData(
//   primarySwatch: Colors.blue,
//   textTheme: Theme.of(context).textTheme.apply(
//   fontFamily: 'Monserrat',
//   bodyColor: Color.fromARGB(255, 2, 12, 20),
//   displayColor: Colors.black),

class PostPage extends StatefulWidget {
  final LostAndFoundObject item;
  const PostPage({super.key, required this.item});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    var dim = MediaQuery.of(context).size;
    var dim_x = dim.width;
    var dim_y = dim.height;
    var edge_padding = 0.02 * dim_y;
    var widget_padding = 0.01 * dim_y;
    var border_radius = Radius.circular(10);
    var header_row_spacing = 0.2 * dim_x;

    return Scaffold(
        body: ListView(
      padding: EdgeInsets.all(edge_padding),
      children: <Widget>[
        // Header
        Container(
            decoration: separatorBoxDecoration(),
            height: 0.18 * dim_y,
            child: ListView(children: <Widget>[
              Row(children: [
                  ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const mapPage()));
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Color.fromARGB(255, 44, 14, 192),
                    size: 30.0,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    primary: Color.fromARGB(255, 96, 160, 213),
                  ),
                ),
                ], 
                mainAxisAlignment: MainAxisAlignment.start
              ),
              headerPadding(dim_y),
              headerItem(Icons.local_offer, "   Item: " + widget.item.itemName.toString()),
              headerPadding(dim_y),
              headerItem(Icons.access_time, "   X hr : min ago"),
              headerPadding(dim_y),
            ]),
        ),
        // Image
        Padding(padding: EdgeInsets.all(widget_padding)),
        Container(
            decoration: separatorBoxDecoration(),
            padding: EdgeInsets.all(widget_padding),
            height: 0.3 * dim_y,
            child: Image.network(widget.item.picture.toString())
        ),
        // Description
        Padding(padding: EdgeInsets.all(widget_padding)),
        Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 98, 239, 176),
              borderRadius: BorderRadius.all(border_radius)),
          padding: EdgeInsets.all(widget_padding),
          height: 0.3 * dim_y,
          // Description text
          child: Text(widget.item.description.toString()),
        )
      ],
    ));
  }
}

BoxDecoration separatorBoxDecoration() {
  return BoxDecoration(
    border: Border(
      bottom: BorderSide(
        //                    <--- top side
        color: Colors.blueAccent,
        width: 3.0,
      ),
    ),
  );
}

Padding headerPadding(var dim_y) {
  var header_row_spacing = 0.01 * dim_y;
  return Padding(padding: EdgeInsets.all(header_row_spacing));
}

Container headerItem(IconData icon, String text) {
  return Container(
    //decoration: separatorBoxDecoration(),
    child: Row(
      children: [
        Icon(
          icon,
          color: Color.fromARGB(255, 44, 14, 192),
          size: 30.0,
        ),
        Text(text),
      ],
    ),
  );
}
