import 'package:flutter/material.dart';

class Navigation{
 static PageRouteBuilder navigate(
      Widget route, {
        Offset begin = const Offset(0, 1),
        Offset end = Offset.zero,
      }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        const curve = Curves.easeInOut;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration:
      const Duration(milliseconds: 800), // Animation duration
    );
  }
}