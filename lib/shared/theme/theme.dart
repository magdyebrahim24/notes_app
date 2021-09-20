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
  bottomNavigationBarTheme: BottomNavigationBarThemeData(elevation: 0,backgroundColor: Colors.transparent,),
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
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white.withOpacity(.33),
  brightness:  Brightness.light,
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
    // brightness: Brightness.light,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.black,),
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
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.transparent.withOpacity(.4))),
    hintStyle: TextStyle(color: Color(0xff666666), fontSize: 16,fontWeight: FontWeight.w300),
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
    headline4: TextStyle(color: Color(0xff242424), fontSize: 40, fontWeight: FontWeight.bold), // intro headline - add pages title
    headline5: TextStyle(color: Color(0xff242424), fontWeight: FontWeight.w500,fontSize: 21), // page title
    headline6: TextStyle(color: Color(0xff4F4F4F)), // setting tile title   - icons color
    subtitle1: TextStyle(color: Color(0xff212121)), // search bar text
    subtitle2: TextStyle(color: Color(0xff666666), fontWeight: FontWeight.w300, fontSize: 16,), // add page body text
    bodyText1: TextStyle(color: Color(0xff4F4F4F), fontSize: 18 ,fontWeight: FontWeight.w400),// subtask theme
    bodyText2: TextStyle(fontSize: 14, color: Color(0xff5D5D5D)), // edited -- intro sub text
    caption: TextStyle(fontSize: 12 ,color: Color(0xff8F8F8F),fontWeight: FontWeight.w500), // display body and date in cards
  ),
  colorScheme: ColorScheme.light(
    background: Color(0xff5BC7D0),// for drawer color
      secondary: accentColor,
    onBackground: Color(0xffF3F3F3), // for audio bg color
    brightness: Brightness.light,

  ),
);











ThemeData darkTheme = ThemeData(
  timePickerTheme: TimePickerThemeData(inputDecorationTheme: InputDecorationTheme(fillColor:accentColor,focusColor: accentColor ),
  entryModeIconColor: accentColor,
  ),
  indicatorColor : accentColor,
  textSelectionTheme: TextSelectionThemeData(cursorColor: accentColor),
  dividerColor: Color(0xff707070),
  hintColor: Color(0xffA5A5A5),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    fillColor: MaterialStateProperty.resolveWith((states) => Color(0xff777777)),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashRadius: 0,
    checkColor: MaterialStateProperty.resolveWith((states) => Color(0xff2E2E2E))
  ),
  cardTheme: CardTheme(color: Color(0xff2E2E2E),),
  brightness:  Brightness.dark,
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: accentColor),
    unselectedLabelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,
        color: Color(0xff8C8C8C)),
    labelColor: accentColor,
    unselectedLabelColor: Color(0xff8C8C8C),
  ),
  primaryColorLight: Colors.white, // for icons color
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  primaryColor: Color(0xff181818),
  scaffoldBackgroundColor: Color(0xff181818),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(color: Color(0xffB5B5B5), fontWeight: FontWeight.w500,fontSize: 22),
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white,),
    backgroundColor: Color(0xff181818),
    elevation: 0.0,
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
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white60)),
      hintStyle: TextStyle(color: Color(0xff7D7D7D), fontSize: 16,fontWeight: FontWeight.w300),
    fillColor: Colors.grey.withOpacity(.1),
      errorStyle: TextStyle(fontSize: 13,color: Color(0xffFD4C4C))

  ),
  textTheme: TextTheme(
    headline1: TextStyle(color: Color(0xffA5A5A5), fontSize: 18,fontWeight: FontWeight.w500),
    headline3: TextStyle(color: Color(0xff181818),fontSize: 20,fontWeight: FontWeight.w500,), // for drawer text
    headline4: TextStyle(color: Color(0xffD9D9D9), fontSize: 40, fontWeight: FontWeight.bold), // intro headline  - add pages title
    headline5: TextStyle(color: Color(0xffD9D9D9), fontWeight: FontWeight.w500,fontSize: 21), // page title
    headline6: TextStyle(color: Color(0xffA5A5A5)), // setting tile title - icons color
    subtitle1: TextStyle(fontSize: 13, color: Color(0xff4F4F4F)),
    subtitle2: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.w300, fontSize: 16,), // add page body text
    bodyText1: TextStyle(color: Color(0xff777777), fontSize: 18 ,fontWeight: FontWeight.w400),// subtask theme
    bodyText2: TextStyle(fontSize: 14, color: Color(0xff888787)), // edited -- intro sub text
    caption: TextStyle(fontSize: 12 ,color: Color(0xff8F8F8F),fontWeight: FontWeight.w500), // display body and date in cards
  ),
  colorScheme: ColorScheme.dark(
    background: Color(0xffA4D7DB), // for drawer background color
      onBackground: Color(0xff222121), // for audio bg color
    secondary: accentColor,
    brightness: Brightness.dark,
  ),
);
