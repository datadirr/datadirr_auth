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
  static const Color grey5 = Color(0xFFFFFEFE);
  static const Color grey10 = Color(0xFFEFEDED);
  static const Color grey15 = Color(0xFFDDDDDD);
  static const Color grey20 = Color(0xFFCBCBCB);
  static const Color grey30 = Color(0xFFACABAB);
  static const Color grey50 = Color(0xFF888888);
  static const Color grey70 = Color(0xFF717070);

  //blue
  static const Color blue2 = Color(0xFFF6F8FA);
  static const Color blue5 = Color(0xFFE5EEF6);
  static const Color blue10 = Color(0xFFDCF1FB);
  static const Color blue30 = Color(0xFF4FC3F7);
  static const Color blue50 = Color(0xFF03A9F4);
  static const Color blue70 = Color(0xFF0288D1);

  //green
  static const Color green5 = Color(0xFFE5ECE6);
  static const Color green10 = Color(0xFFDDF6DE);
  static const Color green30 = Color(0xFF83BA85);
  static const Color green50 = Color(0xFF4CAF50);
  static const Color green70 = Color(0xFF388E3C);

  //red
  static const Color red5 = Color(0xFFFBEDEF);
  static const Color red10 = Color(0xFFF6D5DA);
  static const Color red50 = Color(0xFFEE1333);
  static const Color red70 = Color(0xFFD32F2F);

  //yellow
  static const Color yellow70 = Color(0xFFE5C513);
}
