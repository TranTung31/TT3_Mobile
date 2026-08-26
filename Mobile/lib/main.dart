import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';
import 'package:qltstc_kiemke/utils/share_preferences_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/login/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((ins) {
    SharedPreferencesUtils.setInstance(ins);
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Flutter Demo',
      theme: normarTheme,
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routingCallback: (value) {
        // Here you can check which screen your app is currently on
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: ColorUtils.mainColor),
        );
      },
    );
  }

  final ThemeData normarTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    hintColor: Color.fromRGBO(240, 238, 238, 1),
    primaryColor: ColorUtils.mainColor,
    primaryColorLight: ColorUtils.secondColor,
    iconTheme: new IconThemeData(color: ColorUtils.mainColor),
    splashColor: ColorUtils.mainColor,
    cardColor: Color.fromRGBO(239, 233, 254, 1),
    dividerColor: Color.fromRGBO(60, 60, 60, 1.0),
    disabledColor: Color.fromRGBO(152, 149, 154, 1.0),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),

      displaySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),

      headlineMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),

      headlineSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),

      titleLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),

      labelSmall: TextStyle(fontSize: 16, color: Colors.black),

      labelLarge: TextStyle(fontSize: 12, color: ColorUtils.mainColor),

      bodyMedium: TextStyle(fontSize: 14, color: Colors.black),

      //small text gray
      bodyLarge: TextStyle(
        fontSize: 14,
        color: Color.fromRGBO(175, 175, 175, 1.0),
      ),
    ),
    buttonTheme: ButtonThemeData(
      disabledColor: Color.fromRGBO(23, 191, 162, 1),
      textTheme: ButtonTextTheme.primary,
      colorScheme: ColorScheme.light(
        primary: ColorUtils.mainColor,
        secondary: ColorUtils.secondColor,
        primaryContainer: ColorUtils.redLight,
        secondaryContainer: ColorUtils.redLight,
        surface: ColorUtils.mainColor,
        onSurface: ColorUtils.secondColor,
      ),
    ),
    appBarTheme: AppBarTheme(
      foregroundColor: ColorUtils.mainColor,
      iconTheme: new IconThemeData(color: ColorUtils.mainColor),
    ),
    unselectedWidgetColor: ColorUtils.mainColor,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
