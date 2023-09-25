import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';

TextStyle headerTheme = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 29, 66, 30));

String err = "ERR";

class PostPage extends StatelessWidget {
  final LostAndFoundObject item;

  const PostPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "post-page",
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 191, 255, 212),
              border:
                  Border.all(color: const Color.fromARGB(255, 136, 245, 181)),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(width: 3, color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  shape: BoxShape.rectangle,
                  // image: DecorationImage(
                  //     fit: BoxFit.cover, image:
                )),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      shape: BoxShape.rectangle,
                      // image: DecorationImage(
                      //     fit: BoxFit.cover, image:
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.itemName ?? err, style: headerTheme),
                          Text(item.description ?? err)
                        ])),
                Container(
                    alignment: Alignment.center,
                    child: Text("Contact ${item.phone}"))
              ],
            )),
      ),
    );
  }
}
