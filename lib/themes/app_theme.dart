// ignore_for_file: null_check_always_fails

import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/themes/const_settings.dart' as consts;

/// This class defines global themes for the app. Right now they are defined as
/// final variables but we can refactor this to take the values in a constructor,
/// to define multiple different themes (ie a Pitt color theme, dark theme, etc.)
@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  // Global color theme
  final Color veryLight = consts.veryLight;
  final Color light = consts.light;
  final Color medium = consts.medium;
  final Color dark = consts.dark;
  final Color veryDark = consts.veryDark;
  final Color background = consts.background;
  final Color error = consts.error;

  // Global text themes
  final TextStyle veryDarkTitleStyle = TextStyle(
      color: consts.veryDark,
      fontFamily: consts.font,
      fontWeight: FontWeight.bold,
      fontSize: 18);
  final TextStyle veryDarkSubtitleStyle = TextStyle(
      color: consts.veryDark,
      fontFamily: consts.font,
      fontWeight: FontWeight.bold,
      fontSize: 16);
  final TextStyle veryDarkRegularStyle =
      TextStyle(color: consts.veryDark, fontFamily: consts.font, fontSize: 14);
  final TextStyle darkTitleStyle = TextStyle(
      color: consts.dark,
      fontFamily: consts.font,
      fontWeight: FontWeight.bold,
      fontSize: 18);
  final TextStyle darkSubtitleStyle = TextStyle(
      color: consts.dark,
      fontFamily: consts.font,
      fontWeight: FontWeight.bold,
      fontSize: 16);
  final TextStyle darkRegularStyle =
      TextStyle(color: consts.dark, fontFamily: consts.font, fontSize: 14);
  final TextStyle lightTitleStyle = TextStyle(
      color: consts.veryLight,
      fontFamily: consts.font,
      fontWeight: FontWeight.bold,
      fontSize: 18);
  final TextStyle lightSubtitleStyle = TextStyle(
      color: consts.veryLight,
      fontFamily: consts.font,
      fontWeight: FontWeight.bold,
      fontSize: 16);
  final TextStyle lightRegularStyle =
      TextStyle(color: consts.veryLight, fontFamily: consts.font, fontSize: 14);
  final TextStyle errorStyle =
      TextStyle(color: consts.veryLight, fontFamily: consts.font, fontSize: 14);
  final TextStyle hintStyle = TextStyle(
      color: consts.light.withOpacity(0.7),
      fontFamily: consts.font,
      fontSize: 12);

  // Define shared BoxDecorations and other shared themes here
  final BoxDecoration constantBackgroundDecoration =
      BoxDecoration(color: consts.background);
  final BoxDecoration gradientBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0xFFE0D2C7), consts.medium],
      stops: const [0.1, 0.9],
    ),
  );
  final BoxDecoration cardBodyDecoration = BoxDecoration(
    color: consts.medium,
    border: Border.all(width: 3, color: consts.medium),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
  );
  final BoxDecoration textFieldDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: consts.medium,
        blurRadius: 6.0,
        offset: const Offset(0, 2),
      ),
    ],
  );
  final BoxDecoration profilePictureDecoration = BoxDecoration(
      color: consts.medium,
      shape: BoxShape.circle,
      border: Border.all(width: 3, color: consts.dark));
  final BoxDecoration navBarDecoration = BoxDecoration(
    color: consts.medium,
    // border: Border.all(width: 3, color: secondary),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
  );

  @override
  AppTheme copyWith() => null!;

  @override
  AppTheme lerp(ThemeExtension<AppTheme>? other, double t) =>
      other is! AppTheme ? this : null!;

  @override
  String toString() => '';

  /// Returns the ThemeData for the application, including extensions defined in AppThemeExtensions.
  /// I've defined all theme data in AppThemeExtensions just because I'd rather name things descriptively
  /// Getting a theme attribute from AppThemeExtensions: Theme.of(context).extensions.<attributeName>
  /// When we have multiple themes we can refactor this to take a string representing the theme we want
  /// and a map of themes that maps these strings to ThemeData objects
  static ThemeData getTheme() =>
      ThemeData(extensions: <ThemeExtension<dynamic>>[AppTheme()]);
}
