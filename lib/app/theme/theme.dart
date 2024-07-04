// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

Color light = HexColor('#FFFFFF');
Color dark = HexColor('#121212');
Color black = HexColor('#000000');
Color error = HexColor('#FF0000');
Color redAppoint = HexColor('#6C7D01');
Color errorBg = HexColor('#FF6C6C');

Color blue_0C134F = HexColor('#0C134F');
Color yellow1_F9B401 = HexColor('#F9B401');

class AZTravelTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: light,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: light,
      iconTheme: IconThemeData(color: dark),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: light,
      ),
    ),
    brightness: Brightness.light,
    popupMenuTheme: PopupMenuThemeData(
      color: light,
      surfaceTintColor: Colors.transparent,
      textStyle: TextStyle(color: dark, fontWeight: FontWeight.w400),
    ),
    iconTheme: IconThemeData(
      color: dark,
    ),
    cardColor: light,
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: light),
      headlineMedium: TextStyle(color: light),
      titleLarge: TextStyle(color: black),
      titleMedium: TextStyle(color: black),
      titleSmall: TextStyle(color: blue_0C134F),
      headlineSmall: TextStyle(color: black),
      displayMedium: TextStyle(color: black),
      displaySmall: TextStyle(color: black.withOpacity(0.5)),
    ),
  );
}
