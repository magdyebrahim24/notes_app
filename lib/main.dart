import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes_app/layout/introduction/intro_page.dart';
import 'package:notes_app/layout/setting/bloc/setting_cubit.dart';
import 'package:notes_app/layout/setting/bloc/setting_states.dart';
import 'package:notes_app/layout/dashboard/MenuDashboardPage.dart';
import 'package:notes_app/shared/bloc_observer.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/shared/localizations/localization/locale_constant.dart';
import 'package:notes_app/shared/localizations/localization/localizations_delegate.dart';
import 'package:notes_app/shared/theme/theme.dart';
import 'package:flutter/widgets.dart';

// review app version
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en', '');

  void setLocale(locale) {
    setState(() {
      _locale = locale;
    });
  }


  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingCubit()..onBuild(),
      child: BlocConsumer<SettingCubit, SettingStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SettingCubit cubit = SettingCubit.get(context);
          return MaterialApp(
            title: 'Nota App',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: cubit.darkMode ? ThemeMode.dark : ThemeMode.light,
            home: cubit.firstOpen == true ? MenuDashboardPage() : IntroPage(),
            navigatorObservers: [BotToastNavigatorObserver()],
            builder: BotToastInit(),
            locale: _locale,
            supportedLocales: [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
          );
        },
      ),
    );
  }
}
