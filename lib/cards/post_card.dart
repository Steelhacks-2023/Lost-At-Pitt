import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/pages/post_page.dart';
import 'package:lost_found_steelhacks/routing/hero_dialog_route.dart';

class PostCard extends StatelessWidget {
  final Item item;
  // Placeholder list of tags
  static Map<String, Color> tags = {
    "Tech": const Color.fromARGB(255, 133, 218, 136),
    "Clothing": const Color.fromARGB(255, 231, 100, 90),
    "Memorabilia": const Color.fromARGB(255, 195, 96, 212)
  };

  const PostCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => route(PostPage(item: item), context),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Container(
              padding: const EdgeInsets.all(5),
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                border: Border.all(
                    width: 3, color: const Color.fromARGB(255, 221, 221, 221)),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 122, 122, 122),
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 118, 181, 233),
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 3,
                              color: const Color.fromARGB(255, 70, 133, 243))),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "User found ${item.itemName}",
                              style: const TextStyle(fontSize: 16)),
                        ])),
                        const SizedBox(height: 5),
                        Row(
                            children: generateTags(tags),
                            mainAxisAlignment: MainAxisAlignment.start)
                      ],
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 3),
                      child: Column(
                        children: [
                          Text("4 hours ago",
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  ]),
            )),
          ),
        ));
  }

  List<Widget> generateTags(Map<String, Color> tags) {
    List<Widget> hashtags = [];
    for (String tag in tags.keys) {
      Color c = tags[tag] ?? Colors.black;
      hashtags.add(Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Container(
            padding: const EdgeInsets.all(2),
            child: Text(tag, style: TextStyle(color: c)),
            decoration: BoxDecoration(
                color: tags[tag]?.withOpacity(0.3),
                border: Border.all(color: c, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(3)))),
      ));
    }
    return hashtags;
  }
}
