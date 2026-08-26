import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qltstc_kiemke/utils/share_preferences_utils.dart';

import '../constants/configs.dart';

class ColorUtils {
  static Color getColorFromHexCode(String hexCode) {
    return new Color(
      int.parse(hexCode.substring(1, 7), radix: 16) + 0xFF000000,
    );
  }

  static List<Color> myColors = [
    //    getColorFromHexCode("#5B23FF"),
    //    getColorFromHexCode("#E66746"),
    //    getColorFromHexCode("#C063F2"),
    //    getColorFromHexCode("#DE89F1"),
    //    getColorFromHexCode("#F3B4F3"),
    //    getColorFromHexCode("#FFE1FA"),
    //    getColorFromHexCode("#F7BDE0"),
    //    getColorFromHexCode("#F19ABF"),
    //    getColorFromHexCode("#EA7799"),
    //    getColorFromHexCode("#DF5571"),
    Color.fromRGBO(91, 52, 251, 1),
    Color.fromRGBO(149, 74, 243, 1),
    Color.fromRGBO(191, 104, 239, 1),
    Color.fromRGBO(221, 140, 239, 1),
    Color.fromRGBO(242, 182, 242, 1),
    Color.fromRGBO(254, 226, 249, 1),
    Color.fromRGBO(246, 190, 223, 1),
    Color.fromRGBO(239, 155, 191, 1),
    Color.fromRGBO(232, 120, 153, 1),
    Color.fromRGBO(221, 87, 114, 1),
  ];

  static Color redLight = getColorFromHexCode("#FDE8EA");
  static Color redRegular = getColorFromHexCode("#F41A2D");
  static Color gray = getColorFromHexCode("#AFAFAF");
  static Color greenLight = getColorFromHexCode("#CFFEFF");
  static Color greenRegular = getColorFromHexCode("#1DBE7D");
  static Color mainColor = getColorFromHexCode("#2F8ED5");
  static Color secondColor = getColorFromHexCode("#EBF3FB");
  static Color dark = getColorFromHexCode("#161616");
  static Color orangeMain = getColorFromHexCode("ffc300");

  static Color getRandomColor() {
    Random random = new Random();
    return Color.fromRGBO(
      random.nextInt(100),
      random.nextInt(100),
      random.nextInt(100),
      1,
    );
  }

  static Color getColorDivider() {
    var color = SharedPreferencesUtils.getTheme() == Config.THEME_DARK_MODE
        ? ColorUtils.getColorFromHexCode("#333333")
        : Color.fromRGBO(203, 202, 204, 0.5);
    return color;
  }

  static Color getColorTitleInAppbar(BuildContext context) {
    Color colorTitle = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return colorTitle;
  }
}
