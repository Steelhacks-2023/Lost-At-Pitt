import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';

TextStyle theme =
    const TextStyle(fontSize: 18, color: Color.fromARGB(255, 29, 66, 30));

String err = "ERR";

class PostPage extends StatelessWidget {
  final LostAndFoundObject item;
  // we need to declare all useable "tags" somewhere, and then a LostAndFoundObject will have a list of tags. this is currently a placeholder for UI testing
  static Map<String, Color> tags = {
    "Tech": const Color.fromARGB(255, 133, 218, 136),
    "Clothing": const Color.fromARGB(255, 231, 100, 90),
    "Memorabilia": const Color.fromARGB(255, 195, 96, 212)
  };
  const PostPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "post-page",
        child: DefaultTextStyle(
          style: theme,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Container(
                padding: const EdgeInsets.all(5),
                constraints: const BoxConstraints(maxWidth: 500),
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
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color.fromARGB(255, 217, 235, 255),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const ProfilePicture(),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text:
                                                "User found ${item.itemName}\n",
                                            style: const TextStyle(fontSize: 20)),
                                        const TextSpan(
                                            text: "4 hours ago",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic)),
                                      ])),
                                ],
                              ),
                            ]),
                      ),
                    ),
                    // placeholder
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                          "https://www.hydroflask.com/media/catalog/product/w/6/w64bts474-lupine-straighton_1.jpg"),
                    ),
                    Expanded(
                      child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color.fromARGB(255, 217, 235, 255),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(children: [
                                        const TextSpan(
                                            text: "Description\n",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        TextSpan(
                                            text: item.description,
                                            style: const TextStyle(fontSize: 15)),
                                      ])),
                                  const Spacer(),
                                  Row(children: generateTags(tags) + [const Spacer(), Material(color: const Color.fromARGB(255, 217, 235, 255), child: IconButton(icon: const Icon(Icons.message), onPressed: () => messageUser(),))])
                                ]),
                          )),
                    )
                  ],
                ),
              )),
            ),
          ),
        ));
  }

  // this is duplicate code from postCard.dart and should be moved
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
  
  // will route to a direct message with the user who created the post
  void messageUser() {
    // TODO
  }
}

// this is duplicate code from postCard.dart and should be moved
class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 118, 181, 233),
          shape: BoxShape.circle,
          border:
              Border.all(width: 3, color: const Color.fromARGB(255, 70, 133, 243))),
    );
  }
}
