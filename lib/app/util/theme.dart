import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const typeTheme = Typography.whiteMountainView;

class ThemeProvider {
  static const appColor = Color(0xFF0D0D0D);
  static const appColorShadow = Color(0x33F2D338);
  static const goldenColor = Color(0xFFD4AF37);
  static const gold = Color(0xFFF2D338);
  static const goldDeep = Color(0xFFD4AF37);
  static const surface = Color(0xFF1A1A1A);
  static const surfaceAlt = Color(0xFF1C1E22);
  static const logoutRose = Color(0xFFE5B5A8);

  static const secondaryAppColor = Color(0xFFF2D338);
  static const whiteColor = Colors.white;
  static const blackColor = Color(0xFF0D0D0D);
  static const greyColor = Color(0xFF9E9E9E);
  static const backgroundColor = Color(0xFF0D0D0D);
  static const orangeColor = Color(0xFFF2D338);
  static const greenColor = Color(0xFF32CD32);
  static const redColor = Color(0xFFE53935);
  static const transparent = Color.fromARGB(0, 0, 0, 0);
  static const pink = Color(0xFFF2D338);

  static const double radius = 14;
  static const double radiusSm = 10;

  static const titleStyle = TextStyle(
      fontFamily: 'bold', fontSize: 14, color: ThemeProvider.whiteColor);

  static TextStyle serif({
    double size = 22,
    FontWeight weight = FontWeight.w600,
    Color color = whiteColor,
    double? letterSpacing,
    FontStyle style = FontStyle.normal,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontStyle: style,
    );
  }

  static TextStyle sans({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = whiteColor,
    double? letterSpacing,
    FontStyle style = FontStyle.normal,
  }) {
    return GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontStyle: style,
    );
  }
}

TextTheme txtTheme = Typography.whiteMountainView.copyWith(
  bodyLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  bodyMedium: typeTheme.bodyLarge?.copyWith(fontSize: 14),
  displayLarge: typeTheme.bodyLarge?.copyWith(fontSize: 32),
  displayMedium: typeTheme.bodyLarge?.copyWith(fontSize: 28),
  displaySmall: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  headlineMedium: typeTheme.bodyLarge?.copyWith(fontSize: 21),
  headlineSmall: typeTheme.bodyLarge?.copyWith(fontSize: 18),
  titleLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  titleMedium: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  titleSmall: typeTheme.bodyLarge?.copyWith(fontSize: 21),
);

ThemeData light = ThemeData(
    fontFamily: 'regular',
    scaffoldBackgroundColor: ThemeProvider.backgroundColor,
    primaryColor: ThemeProvider.gold,
    secondaryHeaderColor: ThemeProvider.gold,
    disabledColor: const Color(0xFFBABFC4),
    brightness: Brightness.dark,
    hintColor: ThemeProvider.greyColor,
    cardColor: ThemeProvider.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeProvider.appColor,
      foregroundColor: ThemeProvider.gold,
      elevation: 0,
      iconTheme: IconThemeData(color: ThemeProvider.gold),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: ThemeProvider.gold)),
    textTheme: txtTheme,
    colorScheme: const ColorScheme.dark(
            primary: ThemeProvider.gold,
            secondary: ThemeProvider.gold,
            surface: ThemeProvider.surface)
        .copyWith(error: const Color(0xFFE84D4F)));

ThemeData dark = ThemeData(
    fontFamily: 'regular',
    scaffoldBackgroundColor: ThemeProvider.backgroundColor,
    primaryColor: ThemeProvider.gold,
    secondaryHeaderColor: ThemeProvider.gold,
    disabledColor: const Color(0xffa2a7ad),
    brightness: Brightness.dark,
    hintColor: ThemeProvider.greyColor,
    cardColor: ThemeProvider.surface,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: ThemeProvider.gold)),
    textTheme: txtTheme,
    colorScheme: const ColorScheme.dark(
            primary: ThemeProvider.gold, secondary: ThemeProvider.gold)
        .copyWith(error: const Color(0xFFdd3135)));
