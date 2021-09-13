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
  dividerColor: Color(0xff707070),
  hintColor: Color(0xff666666),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    fillColor: MaterialStateProperty.resolveWith((states) => Color(0xff4F4F4F)),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashRadius: 0,
  ),
  cardTheme: CardTheme(color: Color(0xffE6E6E6),),
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: accentColor),
    unselectedLabelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Color(0xff494949)),
    labelColor: accentColor,
    unselectedLabelColor: Color(0xff494949),
  ),
  primaryColorLight: Colors.black,
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
  backgroundColor: Colors.white.withOpacity(.33), // for drawer selected page title bg
  colorScheme: ColorScheme.light(
    background: Color(0xff5BC7D0),// for drawer color
    ),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
    brightness: Brightness.light,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.black,),
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
    headline1: TextStyle(fontSize: 18,color: Color(0xff181818),fontWeight: FontWeight.w500), // for card title
    headline2: TextStyle(color: Color(0xffE6E6E6),), // color for button in login and secret
    headline3: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500), // for drawer text
    headline4: TextStyle(color: Color(0xff242424), fontSize: 40, fontWeight: FontWeight.bold), // intro headline
    headline5: TextStyle(color: Color(0xff242424), fontWeight: FontWeight.w500,fontSize: 22), // page title
    headline6: TextStyle(color: Color(0xff4F4F4F)), // setting tile title
    subtitle1: TextStyle(color: Color(0xff212121)), // search bar text
    bodyText1: TextStyle(color: Color(0xff4F4F4F), fontSize: 18 ,fontWeight: FontWeight.w400),// subtask theme
    bodyText2: TextStyle(fontSize: 14, color: Color(0xff5D5D5D)), // edited -- intro sub text
    caption: TextStyle(fontSize: 12 ,color: Color(0xff8F8F8F),fontWeight: FontWeight.w500), // display body and date in cards
  ),
);











ThemeData darkTheme = ThemeData(
  indicatorColor : accentColor,
  textSelectionTheme: TextSelectionThemeData(cursorColor: accentColor),
  dividerColor: Color(0xff707070),
  hintColor: Color(0xff666666),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    fillColor: MaterialStateProperty.resolveWith((states) => blueColor),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashRadius: 0,
  ),
  cardTheme: CardTheme(color: Color(0xff2E2E2E),),
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: accentColor),
    unselectedLabelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,
        color: Color(0xff8C8C8C)),
    labelColor: accentColor,
    unselectedLabelColor: Color(0xff8C8C8C),
  ),
  primaryColorLight: Colors.white, // for icons color
  popupMenuTheme: PopupMenuThemeData(
    color: Color(0xff2e2e3e),
    textStyle: TextStyle(
      fontWeight: FontWeight.w700,
      color: yellowColor,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  primaryColor: Color(0xff181818),
  accentColor:  accentColor,
  scaffoldBackgroundColor: Color(0xff181818),
  appBarTheme: AppBarTheme(
    textTheme: TextTheme(headline5: TextStyle(color: Colors.green)),
    titleTextStyle: TextStyle(color: Color(0xffB5B5B5), fontWeight: FontWeight.w500,fontSize: 22),
    brightness: Brightness.dark,centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white,),
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
    backgroundColor: Color(0xff181818),
    elevation: 0.0,
  ),
  colorScheme: ColorScheme.dark(
    background: Color(0xffA4D7DB), // for drawer background color
  ),
  backgroundColor: Color(0xff92B7B9), // for drawer selected page title bg
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
    headline1: TextStyle(color: Colors.white60, fontSize: 18),
    headline3: TextStyle(color: Color(0xff181818),fontSize: 20,fontWeight: FontWeight.w500,), // for drawer text
    headline4: TextStyle(color: Color(0xffD9D9D9), fontSize: 40, fontWeight: FontWeight.bold), // intro headline
    headline5: TextStyle(color: Color(0xffD9D9D9), fontWeight: FontWeight.w500,fontSize: 21), // page title
    headline6: TextStyle(color: Color(0xffA5A5A5)), // setting tile title
    subtitle1: TextStyle(fontSize: 13, color: greyColor),
    bodyText1: TextStyle(color: Colors.white60, decoration: TextDecoration.lineThrough),
    bodyText2: TextStyle(fontSize: 14, color: Color(0xff888787)), // edited -- intro sub text
  ),
);
