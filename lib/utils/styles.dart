import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:flutter/material.dart';

class Styles {
  Styles._();

  static TextStyle txtRegular(
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      Color? decorationColor,
      TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: Fonts.fontProductSansRegular,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontSize: fontSize ?? Fonts.fontNormal,
        color: color,
        decorationColor: decorationColor,
        decoration: decoration);
  }

  static TextStyle txtMedium(
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      Color? decorationColor,
      TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: Fonts.fontProductSansMedium,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize ?? Fonts.fontNormal,
        color: color,
        decorationColor: decorationColor,
        decoration: decoration);
  }

  static TextStyle txtBold(
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      Color? decorationColor,
      TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: Fonts.fontProductSansBold,
        fontWeight: fontWeight ?? FontWeight.w900,
        fontSize: fontSize ?? Fonts.fontNormal,
        color: color,
        decorationColor: decorationColor,
        decoration: decoration);
  }

  static TextStyle txtThin(
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      Color? decorationColor,
      TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: Fonts.fontProductSansThin,
        fontWeight: fontWeight ?? FontWeight.w300,
        fontSize: fontSize ?? Fonts.fontNormal,
        color: color,
        decorationColor: decorationColor,
        decoration: decoration);
  }

  static BoxDecoration boxDecoration(
      {Color? color,
      Color? borderColor,
      double? radius,
      double blur = 0,
      double spread = 0,
      Color? blurColor}) {
    return BoxDecoration(
        color: color,
        border: Border.all(color: borderColor ?? Colorr.transparent),
        borderRadius: BorderRadius.circular(radius ?? 5),
        boxShadow: [
          BoxShadow(
              blurRadius: blur,
              spreadRadius: spread,
              color: blurColor ?? Colorr.grey10)
        ]);
  }
}
