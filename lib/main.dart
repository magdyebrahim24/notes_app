import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/setting/bloc/setting_cubit.dart';
import 'package:notes_app/layout/setting/bloc/setting_states.dart';
import 'package:notes_app/modules/drawer/drawer.dart';
import 'package:notes_app/shared/bloc/bloc_observer.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/shared/styles/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingCubit()..onBuild(),
      child: BlocConsumer<SettingCubit, SettingStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SettingCubit cubit = SettingCubit.get(context);
          return MaterialApp(
            title: 'Notes App',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: cubit.darkMode ?  ThemeMode.dark : ThemeMode.light,
            home: MenuDashboardPage(),
          );
        },
      ),
    );
  }
}


