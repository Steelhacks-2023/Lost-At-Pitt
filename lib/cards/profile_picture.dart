import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    required this.image,
    super.key,
  });
  final AssetImage? image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    
    return Container(
      width: 50,
      height: 50,
      decoration: theme.profilePictureDecoration
    );
  }
}