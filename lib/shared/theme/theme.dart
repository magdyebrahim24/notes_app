import 'package:flutter/material.dart';
import 'package:notes_app/shared/constants.dart';


// ThemeData lightTheme = ThemeData(
//   fontFamily: 'PT_Sans',
//   tabBarTheme: TabBarTheme(
//     labelStyle: TextStyle(color: blueColor),
//     labelColor: blueColor,
//     // indicator: CircleTabIndicator(color: blueColor,radius: 3),
//     unselectedLabelColor: Colors.grey[400],
//   ),
//   primaryColor: whiteColor,
//   accentColor: blueColor,
//   scaffoldBackgroundColor: whiteColor,
//   appBarTheme: AppBarTheme(
//     backgroundColor: whiteColor,
//     elevation: 0.0,
//   ),
//   textTheme: TextTheme(
//     headline4: TextStyle(color: Colors.black),
//     headline5: TextStyle(color: Colors.black),
//     headline6: TextStyle(color: Colors.black),
//   ),
// );
ThemeData lightTheme = ThemeData(
  textSelectionTheme: TextSelectionThemeData(selectionHandleColor: purpleColor),
  dividerColor: Color(0xff707070),
  hintColor: lightgreyColor,
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    fillColor: MaterialStateProperty.resolveWith((states) => blueColor),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashRadius: 0,
  ),
  cardTheme: CardTheme(
    color: lightColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightColor, selectedItemColor: purpleColor,unselectedItemColor: lightgreyColor),
  // fontFamily: 'PT_Sans',
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(color: purpleColor),
    labelColor: purpleColor,
    // indicator: CircleTabIndicator(color: yellowColor,radius: 3),
    unselectedLabelColor: lightgreyColor,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: lightColor,
    textStyle: TextStyle(
      fontWeight: FontWeight.w700,
      color: purpleColor,
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)),
  ),
  primaryColor: Colors.white,
  accentColor: accentColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    elevation: 0.0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(.5),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          width: 1, color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    focusColor: lightgreyColor,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: purpleColor.withOpacity(.4))),
    hintStyle: TextStyle(
      color: lightgreyColor,
    ),
    suffixStyle: TextStyle(color: lightgreyColor),
    fillColor: Colors.grey.withOpacity(.1),
  ),
  textTheme: TextTheme(
    // intro headline
    headline4: TextStyle(color: titleColor ,fontSize: 40 , fontWeight: FontWeight.bold), // edited
    headline5: TextStyle(color: titleColor,), // page title
    headline6: TextStyle(color: Color(0xff4F4F4F)), // setting tile title
    subtitle1: TextStyle(fontSize: 13, color: lightgreyColor),
    bodyText1: TextStyle(color: Colors.white60, decoration: TextDecoration.lineThrough),
    bodyText2: TextStyle(fontSize: 14, color: bodyTextColor), // edited
    headline1: TextStyle(color: Colors.white60, fontSize: 18),

  ),
);

ThemeData darkTheme = ThemeData(
  textSelectionTheme: TextSelectionThemeData(selectionHandleColor: yellowColor),
  dividerColor: Colors.white24,
  hintColor: greyColor,
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    fillColor: MaterialStateProperty.resolveWith((states) => blueColor),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashRadius: 0,
  ),
  cardTheme: CardTheme(
    color: Color(0xff2e2e3e),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xff2e2e3e), selectedItemColor: yellowColor,unselectedItemColor: greyColor),
  fontFamily: 'PT_Sans',
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(color: yellowColor),
    labelColor: yellowColor,
    // indicator: CircleTabIndicator(color: yellowColor,radius: 3),
    unselectedLabelColor: greyColor,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Color(0xff2e2e3e),
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: yellowColor,
      ),
      shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10)),
  ),
  primaryColor: blackColor,
  accentColor: yellowColor,
  scaffoldBackgroundColor: blackColor,
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    backgroundColor: blackColor,
    elevation: 0.0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.white60,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          width: 1, color: Colors.grey.withOpacity(.4)),
      borderRadius: BorderRadius.circular(10),
    ),
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
    headline1: TextStyle(color: Colors.white60, fontSize: 18),
  ),
);
