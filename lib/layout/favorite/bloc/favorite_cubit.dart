import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/favorite/bloc/states.dart';
import 'package:notes_app/shared/functions/functions.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteCubit extends Cubit<FavoriteStates> {
  FavoriteCubit() : super(FavoriteInitialState());
  static FavoriteCubit get(context) => BlocProvider.of(context);

  late Database database;
  bool isFavorite = true;
  bool isLoading = true;
  List notes = [];
  List tasks = [];
  List memories = [];
  List allData = [];
  int navBarIndex = 0;

  onBuild() async {
    var db = await openDatabase('database.db');
    database = db;
    await getData();
  }

  sortedAllDataList(notes, tasks, memories) {
    print('sorted');
    allData = [];
    allData.addAll(notes);
    allData.addAll(tasks);
    allData.addAll(memories);
    allData.sort((a, b) => DateTime.parse(a["favorite_add_date"])
        .compareTo(DateTime.parse(b["favorite_add_date"])));
    emit(FavoriteSortDataState());
  }

  getData() async {
    isLoading = true;
    emit(FavoriteLoaderState());
    await getNotesDataWithItsImages();
    await getAllTasksDataWithItSubTasks();
    await getAllMemoriesDataWithItsImages();
    sortedAllDataList(notes, tasks, memories);
    isLoading = false;
    emit(FavoriteLoaderState());
  }

  void onNavBarIndexChange(value) {
    navBarIndex = value;
    emit(FavoriteNavBarIndexState());
  }

  getNotesDataWithItsImages() async {
    // get all notes data
    List<Map<String, dynamic>> notesDataList = await database.rawQuery(
        'SELECT * FROM notes WHERE is_favorite = ? AND is_secret = ?', [1, 0]);
    // get all notes images data
    List cachedNotesImagesList =
    await database.rawQuery('SELECT * FROM notes_images JOIN notes WHERE is_favorite = ? AND is_secret = ? ',[1,0]);
    notes = assignSubListToData(
        notesDataList, cachedNotesImagesList, 'images', 'note_id');
    emit(FavoriteGetDataState());
  }

  getAllTasksDataWithItSubTasks() async {
    // get all task data
    List<Map<String, dynamic>> tasksDataList = await database.rawQuery(
        'SELECT * FROM tasks WHERE is_favorite = ? AND is_secret = ?', [1, 0]);

    // get all task sub tasks data
    List subTasksList = await database.rawQuery('SELECT * FROM subTasks JOIN tasks WHERE is_favorite = ? AND is_secret = ? ',[1,0]);
    tasks = assignSubListToData(
        tasksDataList, subTasksList, 'subTasks', 'tasks_id');

    emit(FavoriteGetDataState());
  }

  getAllMemoriesDataWithItsImages() async {
    // get all user memories
    List<Map<String, dynamic>> memoriesDataList = await database.rawQuery(
        'SELECT * FROM memories WHERE is_favorite = ? AND is_secret = ?',
        [1, 0]);
    // get memories images
    List cachedMemoriesImagesList =
    await database.rawQuery('SELECT * FROM memories_images JOIN memories WHERE is_favorite = ? AND is_secret = ? ',[1,0]);
    memories = assignSubListToData(
        memoriesDataList, cachedMemoriesImagesList, 'images', 'memory_id');
    print(memories);
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    print(memoriesDataList);
    emit(FavoriteGetDataState());
  }

  void updateDataWhenGetOut(context, page, Function thenFun) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page))
        .then((value) async {
      await thenFun();
      sortedAllDataList(notes, tasks, memories);

    });

  }
}