import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
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

  String getDate() {
    DateTime now = DateTime.now();
    DateTime date = item.timeCreated.toDate();
    if (now.difference(date).inDays == 0) {
      return "Today";
    }
    if (now.difference(date).inDays == 1) {
      return "Yesterday";
    }
    return "${date.month}-${date.day}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final BoxDecoration bodyDecoration = BoxDecoration(
        color: theme.medium,
        borderRadius: const BorderRadius.all(Radius.circular(10)));

    Widget buildProfilePicture() => Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: theme.veryLight),
          padding: const EdgeInsets.all(3.0),
          child: const ProfilePicture(name: "Name", radius: 12, fontsize: 12),
        ));

    Widget buildHeader() => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildProfilePicture(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(item.itemName, style: theme.veryDarkTitleStyle),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(getDate(), style: theme.veryDarkRegularStyle),
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.access_time_sharp, color: theme.dark)),
            ]);

    Widget buildBody() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(item.description,
              style: theme.veryDarkRegularStyle, textAlign: TextAlign.left),
        );

    Widget buildFooter() => Row(children: [
          IconButton(
              color: theme.dark,
              icon: const Icon(Icons.map),
              onPressed: () => routeHome(0, context)),
          IconButton(
              color: theme.dark,
              icon: const Icon(Icons.chat),
              onPressed: () => routeHome(2, context))
        ]);

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
                    decoration: bodyDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildHeader(),
                        buildBody(),
                        buildFooter(),
                      ],
                    ))),
          ),
        ));
  }
}
