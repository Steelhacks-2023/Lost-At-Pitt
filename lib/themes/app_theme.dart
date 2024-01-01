// ignore_for_file: null_check_always_fails

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_steelhacks/themes/const_settings.dart' as clrs;

/// This class defines global themes for the app. Right now they are defined as
/// final variables but we can refactor this to take the values in a constructor,
/// to define multiple different themes (ie a Pitt color theme, dark theme, etc.)
@immutable
class AppTheme extends ThemeExtension<AppTheme> {

  // Global color theme
  final Color veryLight = clrs.veryLight;
  final Color light = clrs.light;
  final Color medium = clrs.medium;
  final Color dark = clrs.dark;
  final Color veryDark = clrs.veryDark;
  final Color background = clrs.background;

  // Global text themes
  final TextStyle darkTitleStyle = TextStyle(
      color: clrs.dark,
      fontFamily: "Roboto",
      fontWeight: FontWeight.bold,
      fontSize: 18);
  final TextStyle darkSubtitleStyle = TextStyle(
      color: clrs.veryDark,
      fontFamily: "Roboto",
      fontWeight: FontWeight.bold,
      fontSize: 16);
  final TextStyle darkRegularStyle = TextStyle(
      color: clrs.veryDark,
      fontFamily: "Roboto",
      fontSize: 14,
  );
  final TextStyle lightTitleStyle = TextStyle(
      color: clrs.veryLight,
      fontFamily: "Roboto",
      fontWeight: FontWeight.bold,
      fontSize: 18);
  final TextStyle lightSubtitleStyle = TextStyle(
      color: clrs.veryLight,
      fontFamily: "Roboto",
      fontWeight: FontWeight.bold,
      fontSize: 16);
  final TextStyle lightRegularStyle = TextStyle(
      color: clrs.veryLight,
      fontFamily: "Roboto",
      fontSize: 14,
  );
  final TextStyle decoratedRegularStyle = TextStyle(
      color: clrs.medium,
      fontStyle: FontStyle.italic,
      fontFamily: "Roboto",
      fontSize: 12);
  final TextStyle hintStyle = TextStyle(
      color: clrs.light.withOpacity(0.7), fontFamily: "OpenSans", fontSize: 12);

  // Define shared BoxDecorations and other shared themes here
  final BoxDecoration constantBackgroundDecoration =
      BoxDecoration(color: clrs.background);
  final BoxDecoration gradientBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE0D2C7), clrs.medium],
      stops: [0.1, 0.9],
    ),
  );
  final BoxDecoration cardSectionDecoration = BoxDecoration(
      color: clrs.medium,
      borderRadius: const BorderRadius.all(Radius.circular(10)));
  final BoxDecoration cardBodyDecoration = BoxDecoration(
    color: clrs.medium,
    border: Border.all(width: 3, color: clrs.medium),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
  );
  final BoxDecoration textFieldDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: clrs.medium,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
  final BoxDecoration profilePictureDecoration = BoxDecoration(
      color: clrs.medium,
      shape: BoxShape.circle,
      border: Border.all(width: 3, color: clrs.dark));
  final BoxDecoration navBarDecoration = BoxDecoration(
    color: clrs.medium,
    // border: Border.all(width: 3, color: secondary),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
  );

  @override
  AppTheme copyWith() => null!;

  @override
  AppTheme lerp(
          ThemeExtension<AppTheme>? other, double t) =>
      other is! AppTheme ? this : null!;

  @override
  String toString() => '';

  /// Returns the ThemeData for the application, including extensions defined in AppThemeExtensions.
  /// I've defined all theme data in AppThemeExtensions just because I'd rather name things descriptively
  /// Getting a theme attribute from AppThemeExtensions: Theme.of(context).extensions.<attributeName>
  /// When we have multiple themes we can refactor this to take a string representing the theme we want
  /// and a map of themes that maps these strings to ThemeData objects
  static ThemeData getTheme() => ThemeData(extensions: <ThemeExtension<dynamic>>[AppTheme()]);
}
