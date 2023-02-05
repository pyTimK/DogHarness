import 'package:flutter/material.dart';

abstract class MyStyles {
  // Text Styles
  static const TextStyle title = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle h1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h1UnBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h2Regular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle p = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // Colors
  static const Color dark = Color(0xFF262626);
  static const Color dark10 = Color(0x1A262626);
  static const Color dark20 = Color(0x33262626);
  static const Color dark60 = Color(0x99262626);
  static const Color white = Color(0xFFFFFFFF);
  static const Color white10 = Color(0x17FFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color green = Color(0xFF23B244);
  static const Color red = Color(0xFFC52222);
  static const Color blue = Color(0xFF298EC7);

  // Flutter Color Swatches
  static const Map<int, Color> _dark700Map = {
    50: Color.fromRGBO(38, 38, 38, .1),
    100: Color.fromRGBO(38, 38, 38, .2),
    200: Color.fromRGBO(38, 38, 38, .3),
    300: Color.fromRGBO(38, 38, 38, .4),
    400: Color.fromRGBO(38, 38, 38, .5),
    500: Color.fromRGBO(38, 38, 38, .6),
    600: Color.fromRGBO(38, 38, 38, .7),
    700: Color.fromRGBO(38, 38, 38, .8),
    800: Color.fromRGBO(38, 38, 38, .9),
    900: Color.fromRGBO(38, 38, 38, 1),
  };

  static final MaterialColor dark700Swatch = MaterialColor(dark.value, _dark700Map);

  // Input decoration
  static InputDecoration myInputDecoration(String label) => InputDecoration(
        labelText: label,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: MyStyles.dark, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: MyStyles.dark, width: 1),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: MyStyles.red, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: MyStyles.red, width: 1),
        ),
        labelStyle: MyStyles.h2,
        errorStyle: const TextStyle(color: MyStyles.red, fontSize: 12),
      );

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD9F2F6),
      Color(0xE4FFFFFF),
      Color(0xFFF5EDF7),
    ],
  );
}

// Extension methods
extension TextStyleHelper on TextStyle {
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underlined => copyWith(decoration: TextDecoration.underline);
  TextStyle colour(Color value) => copyWith(color: value);
  TextStyle weight(FontWeight value) => copyWith(fontWeight: value);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle size(double value) => copyWith(fontSize: value);
}
