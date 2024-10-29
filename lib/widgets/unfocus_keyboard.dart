import 'package:flutter/material.dart';

class UnfocusKeyboard extends StatelessWidget {
  const UnfocusKeyboard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
