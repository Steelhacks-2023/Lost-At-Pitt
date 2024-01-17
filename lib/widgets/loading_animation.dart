import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Center(
      child: SpinKitDoubleBounce(
        duration: const Duration(seconds: 1),
        color: theme.medium,
      ),
    );
  }
}
