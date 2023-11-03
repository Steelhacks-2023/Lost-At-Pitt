import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/cards/profile_picture.dart';
import 'package:lost_found_steelhacks/cards/tag.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';

String err = "ERR";

class PostPage extends StatelessWidget {
  final Item item;
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
    final theme = Theme.of(context).extension<AppTheme>()!;

    return DefaultTextStyle(
      style: theme.regularStyle,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: Container(
            padding: const EdgeInsets.all(5),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: theme.cardBodyDecoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // move to theme
                  decoration: theme.cardSectionDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const ProfilePicture(image: null),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RichText(
                                  textAlign: TextAlign.start,

                                  // Text should pull global font
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "User found ${item.itemName}\n",
                                        style: theme.titleStyle),
                                    TextSpan(
                                        text: "4 hours ago",
                                        style: theme.decoratedRegularStyle)
                                  ])),
                            ],
                          ),
                        ]),
                  ),
                ),
                // placeholder
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      "https://www.hydroflask.com/media/catalog/product/w/6/w64bts474-lupine-straighton_1.jpg",
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      width: double.infinity,

                      // move to theme
                      decoration: theme.cardSectionDecoration,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(children: [
                                    // Text should pull global font
                                    TextSpan(
                                        text: "Description\n",
                                        style: theme.subtitleStyle
                                        ),

                                    TextSpan(
                                        text: item.description,
                                        style: theme.regularStyle),
                                  ])),
                              const Spacer(),
                              Row(
                                  children: generateTags() +
                                      [
                                        const Spacer(),
                                        Material(

                                            // pull from theme
                                            color: const Color.fromARGB(
                                                255, 217, 235, 255),
                                            child: IconButton(
                                              color: theme.dark,
                                              icon: const Icon(Icons.message),
                                              onPressed: () => messageUser(),
                                            ))
                                      ])
                            ]),
                      )),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }

  // will route to a direct message with the user who created the post
  void messageUser() {
    // TODO
  }
}
