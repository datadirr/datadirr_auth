import 'package:flutter/material.dart';

class Colorr {
  Colorr._();

  static MaterialColor primaryMaterialColor = const MaterialColor(0xFF243F4B, {
    50: Color.fromRGBO(36, 63, 75, .1),
    100: Color.fromRGBO(36, 63, 75, .2),
    200: Color.fromRGBO(36, 63, 75, .3),
    300: Color.fromRGBO(36, 63, 75, .4),
    400: Color.fromRGBO(36, 63, 75, .5),
    500: Color.fromRGBO(36, 63, 75, .6),
    600: Color.fromRGBO(36, 63, 75, .7),
    700: Color.fromRGBO(36, 63, 75, .8),
    800: Color.fromRGBO(36, 63, 75, .9),
    900: Color.fromRGBO(36, 63, 75, 1),
  });

  static const Color transparent = Color(0x0000FFFF);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color pageBackground = Color(0xFFEFEFEF);
  static const Color primary = Color(0xFF243F4B);
  static const Color primaryBlue = Color(0xFF0554D3);
  static const Color accent = Color(0xFF858585);

  //grey
  static const Color grey10 = Color(0xFFEFEDED);
  static const Color grey20 = Color(0xFFCBCBCB);
  static const Color grey50 = Color(0xFF888888);

  //red
  static const Color red50 = Color(0xFFEE1333);
}
