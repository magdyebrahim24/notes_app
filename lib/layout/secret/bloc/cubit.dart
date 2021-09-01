import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/secret/bloc/states.dart';
import 'package:notes_app/shared/functions/functions.dart';
import 'package:notes_app/verify/login.dart';
import 'package:sqflite/sqflite.dart';

class SecretCubit extends Cubit<SecretStates> {
  SecretCubit() : super(SecretInitialState());

  static SecretCubit get(context) => BlocProvider.of(context);
  late Database database;
  bool isLoading = true;
  List notes = [];
  List tasks = [];
  List memories = [];
  int navBarIndex = 0;

  onBuild() async {
    var db = await openDatabase('database.db');
    database = db;
    getDataAndRebuild();
    emit(SecretGetDataState());
  }

  void getDataAndRebuild() async {
    isLoading = true;
    emit(SecretLoaderState());
    getNotesDataWithItsImages();
    getAllTasksDataWithItSubTasks();
    getAllMemoriesDataWithItsImages();
    isLoading = false;
    emit(SecretLoaderState());
  }
  void onNavBarIndexChange(value) {
    navBarIndex = value;
    emit(SecretNavBarIndexState());
  }

  void getNotesDataWithItsImages() async {
    // get all notes data
    List<Map<String, dynamic>> notesDataList = [];
    await database.rawQuery('SELECT * FROM notes WHERE is_secret = ?', [1]).then((value) {
      notesDataList = value;
    });
    // get all notes images data
    List cachedNotesImagesList = [];
    await database.rawQuery('SELECT * FROM notes_images').then((value) {
      cachedNotesImagesList = value;
    });
    List notesDataModified = makeModifiableResults(notesDataList);
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
    notes = allNotesCompleteData;
    emit(SecretGetDataState());
  }

  void getAllTasksDataWithItSubTasks() async {
    // get all task data
    List<Map<String, dynamic>> tasksDataList = [];
    database.rawQuery('SELECT * FROM tasks WHERE is_secret = ?', [1]).then((value) {
      tasksDataList = value;
    });
    // get all task sub tasks data
    List subTasksList = [];
    await database.rawQuery('SELECT * FROM subTasks').then((value) {
      subTasksList = value;
    });
    List tasksDataModified = makeModifiableResults(tasksDataList);
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
    tasks = allTasksCompleteData;
    emit(SecretGetDataState());
  }

  void getAllMemoriesDataWithItsImages() async {
    // get all user memories
    List<Map<String, dynamic>> memoriesDataList = [];
    await database.rawQuery('SELECT * FROM memories WHERE is_secret = ?', [1]).then((value) {
      memoriesDataList = value;
    });
    // get memories images
    List cachedMemoriesImagesList = [];
    await database.rawQuery('SELECT * FROM memories_images').then((value) {
      cachedMemoriesImagesList = value;
    });
    List memoriesDataModified = makeModifiableResults(memoriesDataList);
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
    memories = allMemoriesCompleteData;
    emit(SecretGetDataState());
  }
  void upDatePassword(context){
    bool isUpdated=true;
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login(isUpdate: isUpdated,)));
  }
}