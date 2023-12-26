// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';

class Tag extends StatelessWidget {
  const Tag({
    super.key,
    required this.tag,
    required this.color,
  });

  final String tag;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final BoxDecoration tagDecoration = BoxDecoration(
        color: color.withOpacity(0.3),
        border: Border.all(color: color, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(3)));

    return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Container(
            padding: const EdgeInsets.all(2),
            decoration: tagDecoration,
            child: Text(tag,
                style: theme.regularStyle.copyWith(color: color))));
  }
}

List<Widget> generateTags() {
  // temporarily for testing we just hardcode the tags
  Map<String, Color> tags = {
    "Tech": const Color.fromARGB(255, 133, 218, 136),
    "Clothing": const Color.fromARGB(255, 231, 100, 90),
    "Memorabilia": const Color.fromARGB(255, 195, 96, 212)
  };
  List<Widget> hashtags = [];
  for (String tag in tags.keys) {
    Color c = tags[tag] ?? Colors.black;
    hashtags.add(Tag(tag: tag, color: c));
  }
  return hashtags;
}
