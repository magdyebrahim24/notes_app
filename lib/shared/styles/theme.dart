
import 'package:flutter/material.dart';
import 'package:notes_app/shared/constants.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'PT_Sans',
  tabBarTheme: TabBarTheme(
    labelStyle:TextStyle(color: blueColor),
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
  textTheme: TextTheme(headline4: TextStyle(color: Colors.black),headline5: TextStyle(color: Colors.black),
    headline6: TextStyle(color: Colors.black),),

);

ThemeData darkTheme = ThemeData(
  fontFamily: 'PT_Sans',
    tabBarTheme: TabBarTheme(
      labelStyle:TextStyle(color: yellowColor),
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
  textTheme: TextTheme(headline4: TextStyle(color: Colors.white),headline5: TextStyle(color: Colors.white),
    headline6: TextStyle(color: Colors.white),),
);