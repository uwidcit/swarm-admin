import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_schemes.g.dart';

@immutable
class SwarnetTheme {
  final BuildContext context;
  const SwarnetTheme(this.context);

  ThemeData toThemeData() {
    ColorScheme colorScheme = lightColorScheme;
    // MediaQuery.of(context).platformBrightness == Brightness.light
    //     ? lightColorScheme
    //     : darkColorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.montserratTextTheme(),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
