import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:intl/intl.dart';

String err = "ERR";

class PostPage extends StatelessWidget {
  final Item item;

  const PostPage({
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
    return DateFormat.MMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final BoxDecoration bodyDecoration = BoxDecoration(
      color: theme.veryLight,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );

    Widget buildHeader() => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: ProfilePicture(name: "Name", radius: 16, fontsize: 14),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(item.itemName, style: theme.darkTitleStyle),
              ),
              const Spacer(),
              IconButton(
                  color: theme.dark,
                  icon: Icon(Icons.close),
                  onPressed: () => routeBack(context))
            ]);

    Widget buildBody() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(item.description,
              style: theme.veryDarkRegularStyle, textAlign: TextAlign.left),
        );

    Widget buildFooter() => Row(children: [
          IconButton(
              color: theme.dark,
              icon: Icon(Icons.map),
              onPressed: () => routeHome(0, context)),
          IconButton(
              color: theme.dark,
              icon: Icon(Icons.chat),
              onPressed: () => routeHome(2, context)),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(getDate(), style: theme.darkRegularStyle),
          ),
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.access_time_sharp, color: theme.dark)),
        ]);

    return DefaultTextStyle(
      style: theme.lightRegularStyle,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
            child: Container(
                padding: const EdgeInsets.all(5),
                constraints:
                    const BoxConstraints(maxWidth: 500, maxHeight: 300),
                decoration: bodyDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    // Divider(
                    //     color: theme.dark,
                    //     height: 8,
                    //     thickness: 2,
                    //     indent: 5,
                    //     endIndent: 5),
                    buildBody(),
                    const Spacer(),
                    buildFooter(),
                  ],
                ))),
      ),
    );
  }
}
