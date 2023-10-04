import 'package:flutter/material.dart';

class SwarnetLoadingLogo extends StatelessWidget {
  const SwarnetLoadingLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
