import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/data/app_user.dart';
import 'package:lost_found_steelhacks/pages/authenticate_page.dart';
import 'package:lost_found_steelhacks/pages/home_page.dart';
import 'package:lost_found_steelhacks/widgets/loading_animation.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == AppUser.defaultUser) {
      return const LoadingAnimation();
    } else if (user == null) {
      return const AuthenticatePage();
    } else {
      return const HomePage();
    }
  }
}
