import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: theme.veryDark),
        child: const Center(
          child: SpinKitDoubleBounce(
            duration: Duration(seconds: 2),
            color: Colors.white,
          ),
        ));
  }
}
