import 'dart:ui';

import 'package:flutter/material.dart';

class NavigationRailLogo extends StatelessWidget {
  const NavigationRailLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation =
        NavigationRail.extendedAnimation(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          // The extended fab has a shorter height than the regular fab.
          return Image.asset(
            animation.value < 0.5
                ? "assets/swarnet_minimal_logo.png"
                : "assets/swarnet_full_logo.png",
            width: lerpDouble(70, 150, animation.value)!,
          );
        },
      ),
    );
  }
}
