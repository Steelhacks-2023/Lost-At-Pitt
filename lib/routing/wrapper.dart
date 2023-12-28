// ignore_for_file: slash_for_doc_comments

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/pages/home_page.dart';
import 'package:lost_found_steelhacks/services/auth.dart';
import 'package:lost_found_steelhacks/pages/login_page.dart';

/**
 * Wrapper class that checks login state
 */
class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: AuthService.instance.authUser,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user != null) {
              AuthService.instance.updateAppUser(user.uid);
              return const HomePage();
            }
            return const LoginPage();
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
