import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    indicatorColor : accentColor,
  textSelectionTheme: TextSelectionThemeData(cursorColor: accentColor),
  dividerColor: Colors.grey[200],
  hintColor: Color(0xff666666),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    fillColor: MaterialStateProperty.resolveWith((states) => Color(0xff4F4F4F)),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashRadius: 0,
  ),
  cardTheme: CardTheme(
    color: Color(0xffE6E6E6),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightColor,
      selectedItemColor: purpleColor,
      unselectedItemColor: lightgreyColor),
  // fontFamily: 'PT_Sans',
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: accentColor),
    unselectedLabelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Color(0xff494949)),
    labelColor: accentColor,
    unselectedLabelColor: Color(0xff494949),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: lightColor,
    textStyle: TextStyle(
      fontWeight: FontWeight.w700,
      color: purpleColor,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  primaryColor: Colors.white,
  accentColor: accentColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
    brightness: Brightness.light,
    // backwardsCompatibility: false,
    // systemOverlayStyle: SystemUiOverlayStyle(
    //   statusBarColor: accentColor,
    //   statusBarIconBrightness: Brightness.light,
    //   statusBarBrightness: Brightness.light,
    //
    // ),
    // iconTheme: IconThemeData(
    //   color: Colors.black,
    // ),
    // textTheme: TextTheme(),
    backgroundColor: Colors.white,
    elevation: 0.0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.transparent),
      borderRadius: BorderRadius.circular(14),
    ),
    focusColor: lightgreyColor,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.transparent.withOpacity(.4))),
    hintStyle: TextStyle(color: Color(0xff666666), fontSize: 16,fontWeight: FontWeight.w300),
    suffixStyle: TextStyle(color: lightgreyColor),
    fillColor: Color(0xffE6E6E6),
      errorStyle: TextStyle(fontSize: 13,color: Color(0xffFD4C4C))
  ),
  iconTheme: IconThemeData(
    color: Color(0xff292D32)
  ),
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 17,color: Color(0xff181818),fontWeight: FontWeight.w500), // for card title
    headline2: TextStyle(color: Color(0xffE6E6E6),), // color for button in login and secret
     headline3: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500), // for drawer text
    headline4: TextStyle(color: Color(0xff242424),
        fontSize: 40, fontWeight: FontWeight.bold), // intro headline
    headline5: TextStyle(color: Color(0xff242424), fontWeight: FontWeight.w500), // page title
    headline6: TextStyle(color: Color(0xff4F4F4F)), // setting tile title
    subtitle1: TextStyle(color: Color(0xff212121)), // search bar text
    bodyText1: TextStyle(color: Color(0xff4F4F4F), fontSize: 18 ,fontWeight: FontWeight.w400),// subtask theme
    bodyText2: TextStyle(fontSize: 14, color: Color(0xff5D5D5D)), // edited -- intro sub text
    caption: TextStyle(fontSize: 12 ,color: Color(0xff8F8F8F),fontWeight: FontWeight.w500), // display body and date in cards
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
      backgroundColor: Color(0xff2e2e3e),
      selectedItemColor: yellowColor,
      unselectedItemColor: greyColor),
  // fontFamily: 'PT_Sans',
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
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.4)),
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
