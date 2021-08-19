import 'package:flutter/material.dart';
import 'package:notes_app/shared/constants.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'PT_Sans',
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(color: blueColor),
    labelColor: blueColor,
    // indicator: CircleTabIndicator(color: blueColor,radius: 3),
    unselectedLabelColor: Colors.grey[400],
  ),
  primaryColor: whiteColor,
  accentColor: blueColor,
  scaffoldBackgroundColor: whiteColor,
  appBarTheme: AppBarTheme(
    backgroundColor: whiteColor,
    elevation: 0.0,
  ),
  textTheme: TextTheme(
    headline4: TextStyle(color: Colors.black),
    headline5: TextStyle(color: Colors.black),
    headline6: TextStyle(color: Colors.black),
  ),
);

ThemeData darkTheme = ThemeData(
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    fillColor: MaterialStateProperty.resolveWith((states) => blueColor),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashRadius: 0,
  ),
  cardColor: Color(0xff2e2e3e),
  fontFamily: 'PT_Sans',
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(color: yellowColor),
    labelColor: yellowColor,
    // indicator: CircleTabIndicator(color: yellowColor,radius: 3),
    unselectedLabelColor: greyColor,
  ),
  primaryColor: blackColor,
  accentColor: yellowColor,
  scaffoldBackgroundColor: blackColor,
  appBarTheme: AppBarTheme(
    backgroundColor: blackColor,
    elevation: 0.0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusColor: greyColor,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white60)),

    hintStyle: TextStyle(
      color: greyColor,
    ),
    suffixStyle: TextStyle(color: greyColor),
    fillColor: Colors.grey.withOpacity(.1),
  ),
  textTheme: TextTheme(
    headline4: TextStyle(color: Colors.white),
    headline5: TextStyle(color: Colors.white),
    subtitle1: TextStyle(fontSize: 13, color: greyColor),
    bodyText2: TextStyle(fontSize: 16, color: Colors.white),
    bodyText1: TextStyle(
        color: Colors.white60, decoration: TextDecoration.lineThrough),
    headline6: TextStyle(color: Colors.white),
  ),
);
