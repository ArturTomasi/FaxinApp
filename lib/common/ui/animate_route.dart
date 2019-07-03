import 'package:flutter/material.dart';

class AnimateRoute<T> extends MaterialPageRoute<T> {
  AnimateRoute(
      {WidgetBuilder builder, bool fullscreenDialog, RouteSettings settings})
      : super(
            builder: builder,
            fullscreenDialog:
                fullscreenDialog == null ? false : fullscreenDialog,
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) {
      return child;
    }

    return ScaleTransition(
      scale: animation,
      alignment: Alignment.center,
      child: child,
    );
  }
}
