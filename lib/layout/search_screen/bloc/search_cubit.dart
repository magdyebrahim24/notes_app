import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/layout/search_screen/bloc/search_states.dart';
import 'package:notes_app/shared/functions/functions.dart';
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
    if (text != '' && text != null && text != ' ') {
      List allNotesData = await getAllNotesData(text);
      List allTasksData = await getAllTasksData(text);
      List allMemoriesData = await getAllMemoriesData(text);
      searchResult.addAll(allMemoriesData);
      searchResult.addAll(allNotesData);
      searchResult.addAll(allTasksData);
      searchResult.sort((a, b) => DateFormat.yMMMd().parse(a["createdDate"])
          .compareTo(DateFormat.yMMMd().parse(b["createdDate"])));
    }
    emit(SearchResultState());
  }

  Future getAllNotesData(text) async {
    // get  notes data
    List<Map<String, dynamic>> notesDataList = await database.query("notes",
        where: "is_secret = ? And title LIKE ?", whereArgs: [0, '%$text%']);
    // get notes images data
    List cachedNotesImagesList =
    await database.rawQuery('SELECT notes_images.id,notes_images.link,notes_images.note_id FROM notes_images INNER JOIN notes ON notes.id=notes_images.note_id AND notes.is_secret=? ' ,[0]);

    List recordsList = await database.rawQuery('SELECT voices.id,voices.link,voices.note_id FROM voices INNER JOIN notes ON notes.id=voices.note_id AND notes.is_secret=? ' ,[0]);


    return assignSubListToData(notesDataList, cachedNotesImagesList, 'images', 'note_id',voices: recordsList,voiceKey: 'voices',voiceId: 'note_id');
  }

  Future getAllTasksData(text) async {
    // get all task data
    List<Map<String, dynamic>> tasksDataList = await database.query("tasks",
        where: "is_secret = ? And title LIKE ?", whereArgs: [0, '%$text%']);

    // get all task sub tasks data
    List subTasksList = await database.rawQuery('SELECT subTasks.id,subTasks.body,subTasks.isDone,subTasks.tasks_id FROM subTasks INNER JOIN tasks ON tasks.id=subTasks.tasks_id AND tasks.is_secret=?',[0]);

    return  assignSubListToData(tasksDataList, subTasksList, 'subTasks', 'tasks_id');
  }

  Future getAllMemoriesData(text) async {
    // get all user memories
    List<Map<String, dynamic>> memoriesDataList = await database.query("memories",
        where: "is_secret = ? And title LIKE ?", whereArgs: [0, '%$text%']);
    // get memories images
    List cachedMemoriesImagesList =
    await database.rawQuery('SELECT memories_images.id,memories_images.link,memories_images.memory_id FROM memories_images INNER JOIN memories ON memories.id=memories_images.memory_id AND memories.is_secret=? ' ,[0]);


    return  assignSubListToData(memoriesDataList, cachedMemoriesImagesList, 'images', 'memory_id');

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
