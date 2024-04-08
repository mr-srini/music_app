import 'package:flutter/material.dart';

abstract class AppTheme {
  static const double displayLargeFontSize = 30.0;
  static const FontWeight displayLargeFontSizeFontWeight = FontWeight.bold;
  static const double dmFontSize = 20.0;
  static const double dsFontSize = 16.0;

  static const Color appPrimaryColor = Color(0xff0059DD);

  static ThemeData get light {
    return ThemeData(
      textTheme: const TextTheme()
          .apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          )
          .copyWith(
            displayLarge: const TextStyle(
              fontFamily: "Lato",
              fontSize: displayLargeFontSize,
              fontWeight: displayLargeFontSizeFontWeight,
              letterSpacing: 0.5,
            ),
            displayMedium: const TextStyle(
              fontFamily: "Lato",
              fontSize: dmFontSize,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.2,
            ),
            displaySmall: const TextStyle(
              fontFamily: "Lato",
              fontSize: dsFontSize,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.2,
            ),
          ),
      brightness: Brightness.light,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      dividerColor: const Color.fromARGB(255, 197, 197, 197),
      splashColor: Colors.transparent,
      fontFamily: "Lato",
    );
  }

  static ThemeData get dark {
    return ThemeData(
      textTheme: const TextTheme()
          .apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          )
          .copyWith(
            displayLarge: const TextStyle(
              fontFamily: "Lato",
              fontSize: displayLargeFontSize,
              letterSpacing: 0.5,
              fontWeight: displayLargeFontSizeFontWeight,
            ),
            displayMedium: const TextStyle(
              fontFamily: "Lato",
              fontSize: dmFontSize,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w600,
            ),
            displaySmall: const TextStyle(
              fontFamily: "Lato",
              letterSpacing: 0.2,
              fontSize: dsFontSize,
              fontWeight: FontWeight.normal,
            ),
          ),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color.fromARGB(255, 37, 37, 37),
      splashColor: Colors.transparent,
      fontFamily: "Lato",
    );
  }
}
