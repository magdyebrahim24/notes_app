import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/layout/add_note.dart';
import 'package:notes_app/layout/home_layout.dart';
import 'package:notes_app/shared/bloc_observer.dart';
import 'package:notes_app/shared/styles/theme.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: MyHomePage(),
    );
  }
}


