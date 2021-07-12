
import 'package:flutter/material.dart';
import 'package:notes_app/shared/components/circle_tab_Indicator.dart';
import 'package:notes_app/shared/constants.dart';

ThemeData lightTheme = ThemeData(
  tabBarTheme: TabBarTheme(
    labelStyle:TextStyle(color: blueColor),
    labelColor: blueColor,
    indicator: CircleTabIndicator(color: blueColor,radius: 3),
    unselectedLabelColor: Colors.grey[400],

  ),
  primaryColor: whiteColor,
  accentColor: blueColor,
  scaffoldBackgroundColor: whiteColor,
  appBarTheme: AppBarTheme(
    backgroundColor: whiteColor,
    elevation: 0.0,

  )
);

ThemeData darkTheme = ThemeData(
    tabBarTheme: TabBarTheme(
      labelStyle:TextStyle(color: yellowColor),
      labelColor: yellowColor,
      indicator: CircleTabIndicator(color: yellowColor,radius: 3),
      unselectedLabelColor: Colors.grey[400],

    ),
    primaryColor: blackColor,
    accentColor: yellowColor,
    scaffoldBackgroundColor: blackColor,
    appBarTheme: AppBarTheme(
      backgroundColor: blackColor,
      elevation: 0.0,

    )
);