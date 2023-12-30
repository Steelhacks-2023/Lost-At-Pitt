// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/pages/home_page.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// {@template hero_dialog_route}
/// Custom [PageRoute] that creates an overlay dialog (popup effect).
///
/// Best used with a [Hero] animation.
/// {@endtemplate}
class HeroDialogRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  HeroDialogRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

/**
 * Routes to a page that should be displayed overtop the current one
 */
void routeSubpage(Widget page, BuildContext context) => Navigator.push(
    context,
    HeroDialogRoute(
        builder: (context) =>
            Hero(tag: "post-page", child: PointerInterceptor(child: page))));

/**
 * Routes to another page
 */
void routePage(Widget page, BuildContext context) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));

/**
 * Routes back to previous page from a subpage
 */
void routeBack(BuildContext context) => Navigator.pop(context);

/**
 * Routes back to the page in HomePage
 * 0 -> MapPage
 * 1 -> ListPage
 * 2 -> ChatPage
 * 3 -> ProfilePage
 */
void routeHome(int page, BuildContext context) => Navigator.push(context,
    MaterialPageRoute(builder: (context) => HomePage(startingPage: page)));