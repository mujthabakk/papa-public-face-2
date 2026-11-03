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

  static const String fontRegular = 'regular';
  static const String fontMedium = 'medium';
  static const String fontSemiBold = 'semibold';
  static const String fontBold = 'bold';

  static String sansFamily(FontWeight weight) {
    if (weight.value >= 700) return fontBold;
    if (weight.value >= 600) return fontSemiBold;
    if (weight.value >= 500) return fontMedium;
    return fontRegular;
  }

  static TextStyle get titleStyle => sans(
        size: 16,
        weight: FontWeight.w600,
        color: gold,
      );

  /// Screen / section titles — same Montserrat family as the rest of the app.
  static TextStyle serif({
    double size = 22,
    FontWeight weight = FontWeight.w600,
    Color color = whiteColor,
    double? letterSpacing,
    FontStyle style = FontStyle.normal,
  }) {
    return sans(
      size: size,
      weight: weight,
      color: color,
      letterSpacing: letterSpacing,
      style: style,
    );
  }

  static TextStyle sans({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = whiteColor,
    double? letterSpacing,
    FontStyle style = FontStyle.normal,
  }) {
    return TextStyle(
      fontFamily: sansFamily(weight),
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontStyle: style,
    );
  }

  /// Currency / amounts. Inter includes ₹, QR, AED (Montserrat does not).
  static TextStyle price({
    double size = 16,
    FontWeight weight = FontWeight.w600,
    Color color = whiteColor,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}

TextTheme txtTheme = Typography.whiteMountainView.copyWith(
  bodyLarge: const TextStyle(
      fontFamily: ThemeProvider.fontRegular, fontSize: 16, color: Colors.white),
  bodyMedium: const TextStyle(
      fontFamily: ThemeProvider.fontRegular, fontSize: 14, color: Colors.white),
  bodySmall: const TextStyle(
      fontFamily: ThemeProvider.fontRegular,
      fontSize: 12,
      color: ThemeProvider.greyColor),
  displayLarge: const TextStyle(
      fontFamily: ThemeProvider.fontSemiBold,
      fontSize: 32,
      color: Colors.white),
  displayMedium: const TextStyle(
      fontFamily: ThemeProvider.fontSemiBold,
      fontSize: 28,
      color: Colors.white),
  displaySmall: const TextStyle(
      fontFamily: ThemeProvider.fontSemiBold,
      fontSize: 24,
      color: Colors.white),
  headlineMedium: const TextStyle(
      fontFamily: ThemeProvider.fontSemiBold,
      fontSize: 21,
      color: Colors.white),
  headlineSmall: const TextStyle(
      fontFamily: ThemeProvider.fontSemiBold,
      fontSize: 18,
      color: Colors.white),
  titleLarge: const TextStyle(
      fontFamily: ThemeProvider.fontSemiBold,
      fontSize: 16,
      color: Colors.white),
  titleMedium: const TextStyle(
      fontFamily: ThemeProvider.fontMedium, fontSize: 16, color: Colors.white),
  titleSmall: const TextStyle(
      fontFamily: ThemeProvider.fontMedium, fontSize: 14, color: Colors.white),
  labelLarge: const TextStyle(
      fontFamily: ThemeProvider.fontSemiBold,
      fontSize: 14,
      color: Colors.white),
  labelMedium: const TextStyle(
      fontFamily: ThemeProvider.fontMedium, fontSize: 12, color: Colors.white),
  labelSmall: const TextStyle(
      fontFamily: ThemeProvider.fontMedium,
      fontSize: 11,
      color: ThemeProvider.greyColor),
);

ThemeData _eliteTheme() {
  return ThemeData(
    fontFamily: ThemeProvider.fontRegular,
    scaffoldBackgroundColor: ThemeProvider.backgroundColor,
    primaryColor: ThemeProvider.gold,
    secondaryHeaderColor: ThemeProvider.gold,
    disabledColor: const Color(0xFFBABFC4),
    brightness: Brightness.dark,
    hintColor: ThemeProvider.greyColor,
    cardColor: ThemeProvider.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeProvider.appColor,
      foregroundColor: ThemeProvider.gold,
      elevation: 0,
      iconTheme: const IconThemeData(color: ThemeProvider.gold),
      titleTextStyle: ThemeProvider.sans(
        size: 16,
        weight: FontWeight.w600,
        color: ThemeProvider.gold,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ThemeProvider.gold,
        textStyle: ThemeProvider.sans(size: 14, weight: FontWeight.w600),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: ThemeProvider.sans(size: 14, weight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: ThemeProvider.sans(size: 13, color: ThemeProvider.greyColor),
      labelStyle: ThemeProvider.sans(size: 13, color: ThemeProvider.greyColor),
    ),
    dialogTheme: DialogThemeData(
      titleTextStyle: ThemeProvider.sans(
        size: 16,
        weight: FontWeight.w600,
        color: ThemeProvider.whiteColor,
      ),
      contentTextStyle: ThemeProvider.sans(
        size: 14,
        color: ThemeProvider.whiteColor,
      ),
    ),
    textTheme: txtTheme,
    colorScheme: const ColorScheme.dark(
            primary: ThemeProvider.gold,
            secondary: ThemeProvider.gold,
            surface: ThemeProvider.surface)
        .copyWith(error: const Color(0xFFE84D4F)),
  );
}

ThemeData light = _eliteTheme();
ThemeData dark = _eliteTheme();
