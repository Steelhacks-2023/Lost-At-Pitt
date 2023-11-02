import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/cards/profile_picture.dart';
import 'package:lost_found_steelhacks/cards/tag.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/pages/post_page.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';

class PostCard extends StatelessWidget {
  final Item item;

  const PostCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return GestureDetector(
        onTap: () => routeSubpage(PostPage(item: item), context),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Container(
              padding: const EdgeInsets.all(5),
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: theme.cardSectionDecoration,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ProfilePicture(image: null),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("User found ${item.itemName}",
                            style: theme.subtitleStyle),
                        const SizedBox(height: 5),
                        Row(
                            children: generateTags(),
                            mainAxisAlignment: MainAxisAlignment.start)
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 3),
                      child: Column(
                        children: [
                          Text("4 hours ago",
                              style: theme.decoratedRegularStyle)
                        ],
                      ),
                    ),
                  ]),
            )),
          ),
        ));
  }
}
