import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/search_screen/bloc/search_states.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
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
      List allNotesData = await getNotesDataWithItsImages(text);
      List allTasksData = await getAllTasksDataWithItSubTasks(text);
      List allMemoriesData = await getAllMemoriesDataWithItsImages(text);

      searchResult.addAll(allNotesData);
      searchResult.addAll(allTasksData);
      searchResult.addAll(allMemoriesData);
    }
    emit(SearchResultState());
  }

  getNotesDataWithItsImages(text) async {
    var notesResults = await database.query("notes",
        where: "is_secret = ? And title LIKE ?", whereArgs: [0, '%$text%']);
    // get all notes images data
    List cachedNotesImagesList = [];
    await database.rawQuery('SELECT * FROM notes_images').then((value) {
      cachedNotesImagesList = value;
    });
    List notesDataModified = makeModifiableResults(notesResults);
    List oneNoteImagesList = [];
    Map<String, dynamic> oneNoteData = {};
    List<Map<String, dynamic>> allNotesCompleteData = [];

    for (int i = 0; i < notesDataModified.length; i++) {
      oneNoteImagesList = [];
      oneNoteData = notesDataModified[i];
      oneNoteData.putIfAbsent('images', () => []);
      for (int y = 0; y < cachedNotesImagesList.length; y++) {
        if (notesDataModified[i]['id'] == cachedNotesImagesList[y]['note_id']) {
          oneNoteImagesList.add(cachedNotesImagesList[y]);
        }
      }
      if (oneNoteImagesList.isNotEmpty)
        oneNoteData.update('images', (dynamic val) => oneNoteImagesList);
      allNotesCompleteData.add(oneNoteData);
    }
    return allNotesCompleteData;
  }

  getAllTasksDataWithItSubTasks(text) async {
    // get all task data
   var tasksResult = await database.query("tasks",
        where: "is_secret = ? And title LIKE ?", whereArgs: [0, '%$text%']);

    // get all task sub tasks data
    List subTasksList = [];
    await database.rawQuery('SELECT * FROM subTasks').then((value) {
      subTasksList = value;
    });
    List tasksDataModified = makeModifiableResults(tasksResult);
    List oneSubTaskList = [];
    Map<String, dynamic> oneTaskData = {};
    List<Map<String, dynamic>> allTasksCompleteData = [];

    // get tasks data
    for (int i = 0; i < tasksDataModified.length; i++) {
      oneSubTaskList = [];
      oneTaskData = tasksDataModified[i];
      oneTaskData.putIfAbsent('subTasks', () => []);
      for (int y = 0; y < subTasksList.length; y++) {
        if (tasksDataModified[i]['id'] == subTasksList[y]['tasks_id']) {
          oneSubTaskList.add(subTasksList[y]);
        }
      }
      if (oneSubTaskList.isNotEmpty)
        oneTaskData.update('subTasks', (dynamic val) => oneSubTaskList);
      allTasksCompleteData.add(oneTaskData);
    }
    return allTasksCompleteData;

  }

  getAllMemoriesDataWithItsImages(text) async {
    // get all user memories
   var memoriesResult = await database.query("memories",
        where: "is_secret = ? And title LIKE ?", whereArgs: [0, '%$text%']);
    // get memories images
    List cachedMemoriesImagesList = [];
    await database.rawQuery('SELECT * FROM memories_images').then((value) {
      cachedMemoriesImagesList = value;
    });
    List memoriesDataModified = makeModifiableResults(memoriesResult);
    List oneMemoryImagesList = [];
    Map<String, dynamic> oneMemoryData = {};
    List<Map<String, dynamic>> allMemoriesCompleteData = [];

    // get memories data and images in one list
    for (int i = 0; i < memoriesDataModified.length; i++) {
      oneMemoryImagesList = [];
      oneMemoryData = memoriesDataModified[i];
      oneMemoryData.putIfAbsent('images', () => []);
      for (int y = 0; y < cachedMemoriesImagesList.length; y++) {
        if (memoriesDataModified[i]['id'] == cachedMemoriesImagesList[y]['memory_id']) {
          oneMemoryImagesList.add(cachedMemoriesImagesList[y]);
        }
      }
      if (oneMemoryImagesList.isNotEmpty)
        oneMemoryData.update('images', (dynamic val) => oneMemoryImagesList);
      allMemoriesCompleteData.add(oneMemoryData);
    }

    return allMemoriesCompleteData;
  }
}
