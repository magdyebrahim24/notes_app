import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/secret/bloc/secret_states.dart';
import 'package:notes_app/layout/verify/login.dart';
import 'package:notes_app/shared/functions/functions.dart';
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
    await getNotesDataWithItsImages();
    await getAllTasksDataWithItSubTasks();
    await getAllMemoriesDataWithItsImages();
    isLoading = false;
    emit(SecretLoaderState());
  }

  void onNavBarIndexChange(value) {
    navBarIndex = value;
    emit(SecretNavBarIndexState());
  }

  Future getNotesDataWithItsImages() async {
    // get all notes data
    List<Map<String, dynamic>> notesDataList =
        await database.rawQuery('SELECT * FROM notes WHERE is_secret = ?', [1]);
    // print(notesDataList);
    // get all notes images data
    List cachedNotesImagesList = await database.rawQuery('SELECT notes_images.id,notes_images.link,notes_images.note_id FROM notes_images INNER JOIN notes ON notes.id=notes_images.note_id AND notes.is_secret=? ' ,[1]);
   // print(notesDataList);
    notes = assignSubListToData(
        notesDataList, cachedNotesImagesList, 'images', 'note_id');
    emit(SecretGetDataState());
    return true ;
  }

  Future getAllTasksDataWithItSubTasks() async {
    // get all task data
    List<Map<String, dynamic>> tasksDataList =
        await database.rawQuery('SELECT * FROM tasks WHERE is_secret = ?', [1]);
    // get all task sub tasks data
    List subTasksList = await database.rawQuery('SELECT subTasks.id,subTasks.body,subTasks.isDone,subTasks.tasks_id FROM subTasks INNER JOIN tasks ON tasks.id=subTasks.tasks_id AND tasks.is_secret=?',[1]);

    tasks = assignSubListToData(
        tasksDataList, subTasksList, 'subTasks', 'tasks_id');
    emit(SecretGetDataState());
  }

  Future getAllMemoriesDataWithItsImages() async {
    // get all user memories
    List<Map<String, dynamic>> memoriesDataList =
    await database.rawQuery(
        'SELECT * FROM memories WHERE is_secret = ?', [1]);
    // get memories images
    List cachedMemoriesImagesList =
    await database.rawQuery('SELECT memories_images.id,memories_images.link,memories_images.memory_id FROM memories_images INNER JOIN memories ON memories.id=memories_images.memory_id AND memories.is_secret=? ' ,[1]);

    memories = assignSubListToData(
        memoriesDataList, cachedMemoriesImagesList, 'images', 'memory_id');
    emit(SecretGetDataState());
  }

  void upDatePassword(context) {
    bool isUpdated = true;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Login(
                  isUpdate: isUpdated,
                )));
  }
}










































