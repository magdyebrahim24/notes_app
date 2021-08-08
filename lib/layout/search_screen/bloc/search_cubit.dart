import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/layout/search_screen/bloc/search_states.dart';
import 'package:sqflite/sqflite.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  TextEditingController searchController = TextEditingController();

  late Database database;

  onBuild() async {
    var db = await openDatabase('database.db');
    database = db;
    emit(SearchOnBuildState());
  }

  List searchResult = [];

  Future search(text) async {
    searchResult = [];
    if (text != '' && text != null) {
      var notesResult = await database.query("notes",
          where: "is_secret = ? And title LIKE ?", whereArgs: [0, '%$text%']);
      var tasksResult = await database.query("tasks",
          where: "is_secret = ? And title LIKE ?", whereArgs: [0, '%$text%']);
      var memoriesResult = await database.query("memories",
          where: "is_secret = ? And title LIKE ?", whereArgs: [0, '%$text%']);
      // searchResult = text != null && text != '' ? notesResult : [];
      searchResult.addAll(notesResult);
      searchResult.addAll(tasksResult);
      searchResult.addAll(memoriesResult);
      print('---------- result');
      searchResult.forEach((element) {
        print(element);
      });
    }
    emit(SearchResultState());
  }

  void onSelectSearchResult() {}

  void compareTwoDates() {
    String date = 'Aug 5, 2021';
    String time = '3:58 PM';

    var berlinWallFellDate = new DateTime.utc(2021, 5, 5);

    DateTime dateTime = DateFormat("yMMMd").parse('$date');
    print(dateTime.toString());

    if (berlinWallFellDate.compareTo(dateTime) > 0) {
      print('greater');
    } else {
      print('smaller');
    }
  }
}
