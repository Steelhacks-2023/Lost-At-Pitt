import 'package:flutter/material.dart';
import 'package:icon_forest/icon_forest.dart';

// title: 'Flutter Project',
// theme: ThemeData(
//   primarySwatch: Colors.blue,
//   textTheme: Theme.of(context).textTheme.apply(
//   fontFamily: 'Monserrat',
//   bodyColor: Color.fromARGB(255, 2, 12, 20),
//   displayColor: Colors.black),


class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  
  @override
  Widget build(BuildContext context) {
    var dim = MediaQuery.of(context).size;
    var dim_x = dim.width;
    var dim_y = dim.height;
    var edge_padding = 0.02*dim_y;
    var widget_padding = 0.01*dim_y;
    var header_row_spacing = 0.02*dim_x;
    var border_radius = Radius.circular(10);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(edge_padding),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 98, 239, 176),
              borderRadius: BorderRadius.all(border_radius)
            ),
            height: 0.15*dim_y,
            //child: HeaderWidget(title: "Header"),
            // Change header color based on Lost/Found
            //color: Color.fromARGB(255, 98, 239, 176),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // set your alignment
              children: <Widget>[
                Padding(padding: EdgeInsets.all(header_row_spacing)),
                ElevatedButton(
                  onPressed: () {},
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
                Padding(padding: EdgeInsets.all(header_row_spacing)),
                Icon(
                    Icons.change_history,
                    color: Color.fromARGB(255, 44, 14, 192),
                    size: 30.0,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Item: Water bottle"
                ),
                Icon(
                    Icons.change_history,
                    color: Color.fromARGB(255, 44, 14, 192),
                    size: 30.0,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "X hr : min ago"
                ),
                Padding(padding: EdgeInsets.all(header_row_spacing)),
              ] 
            )
            
          ),
          Padding(padding: EdgeInsets.all(widget_padding)),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 98, 239, 176),
              borderRadius: BorderRadius.all(border_radius)
            ),
            padding: EdgeInsets.all(widget_padding),
            height: 0.5*dim_y,
            child: Image.asset("assets/sample_image.png")
          ),
          Padding(padding: EdgeInsets.all(widget_padding)),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 98, 239, 176),
              borderRadius: BorderRadius.all(border_radius)
            ),
            padding: EdgeInsets.all(widget_padding),
            height: 0.5*dim_y,
            // Description text
            child: Text("Description of the item goes here"),
          )

        ],
      )
    );
  }
}

// class HeaderWidget extends StatefulWidget {
//   const HeaderWidget({super.key, required this.title});

//   final String title;

//   @override
//   State<HeaderWidget> createState() => _HeaderWidgetState();
// }

// class _HeaderWidgetState extends State<HeaderWidget> {
  
//   @override
//   Widget build(BuildContext context) {
      
//     var dim = MediaQuery.of(context).size;
//     var dim_x = dim.width;
//     var dim_y = dim.height;
//     var header_row_spacing = 0.02*dim_x;

//     return Scaffold(
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.start, // set your alignment
//         children: <Widget>[
//           Padding(padding: EdgeInsets.all(header_row_spacing)),
//           ElevatedButton(
//             onPressed: () {},
//             child: Icon(
//               Icons.keyboard_arrow_left,
//               color: Color.fromARGB(255, 44, 14, 192),
//               size: 30.0,
//             ),
//             style: ElevatedButton.styleFrom(
//               shape: CircleBorder(),
//               primary: Color.fromARGB(255, 96, 160, 213),
//             ),
//           ),
//           Padding(padding: EdgeInsets.all(header_row_spacing)),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center, // set your alignment
//             children: [
//               Text(
//                 textAlign: TextAlign.center,
//                 "Item: Water bottle"
//               ),
//               Text(
//                 textAlign: TextAlign.center,
//                 "X hr : min ago"
//               )
//             ],
//           ),
//           Padding(padding: EdgeInsets.all(header_row_spacing)),
//         ] 
//       )
//     );
//   }
// }