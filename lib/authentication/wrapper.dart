import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/authentication/auth.dart';
import 'package:lost_found_steelhacks/authentication/loading_animation.dart';
import 'package:lost_found_steelhacks/authentication/user.dart';
import 'package:lost_found_steelhacks/pages/home_page.dart';
import 'package:lost_found_steelhacks/pages/login_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    if (user == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}
