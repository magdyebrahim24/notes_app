import 'package:bloc/bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/shared/bloc/states/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  TabController? tabBarController;
  AnimationController? fABController;
  bool isDrawerCollapsed = true;
  final Duration? drawerDuration = const Duration(milliseconds: 200);
  AnimationController? drawerController;
  Animation<double>? drawerScaleAnimation;
  Animation<double>? drawerMenuScaleAnimation;
  Animation<Offset>? drawerSlideAnimation;
  Database? database;
  List cachedImagesList = [];
  List<Map<String,dynamic>> notesDataList = [];
  // have notes data and images data
  List<Map<String,dynamic>> allNotesDataList = [];
  bool isLoading=true;


  // init state function
  void onBuildPage(x) {
    drawerController = AnimationController(vsync: x, duration: drawerDuration);
    drawerScaleAnimation =
        Tween<double>(begin: 1, end: 0.8).animate(drawerController!);
    drawerMenuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(drawerController!);
    drawerSlideAnimation =
        Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
            .animate(drawerController!);
    tabBarController = TabController(length: 3, vsync: x);
    fABController =
        AnimationController(vsync: x, duration: Duration(milliseconds: 200));
    tabBarController!.addListener((){

      print('my index is '+ tabBarController!.index.toString());

    });
    // getNoteDataFromDatabase(database);
  }

  // open drawer function
  openDrawer() {
    if (isDrawerCollapsed)
      drawerController!.forward();
    else
      drawerController!.reverse();

    isDrawerCollapsed = !isDrawerCollapsed;

    emit(OpenDrawerState());
  }

  void createDatabase() async {
    openDatabase(
      'database.db',
      version: 1,
      onCreate: (database, version) {
        print('database is created');
        database
            .execute(
                'CREATE TABLE notes (id INTEGER PRIMARY KEY ,title TEXT ,body TEXT ,createdTime TEXT ,createdDate TEXT)')
            .then((value) => print('notes table created'))
            .catchError((error) => print('note error' + error.toString()));
        database
            .execute(
                'CREATE TABLE memories (id INTEGER PRIMARY KEY ,title TEXT ,body TEXT ,createdTime TEXT ,createdDate TEXT,memoryDate TEXT)')
            .then((value) => print('memory table created'))
            .catchError((error) => print('memory error' + error.toString()));
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT ,createdTime TEXT ,createdDate TEXT,taskDate TEXT,taskTime TEXT)')
            .then((value) => print('task table created'))
            .catchError((error) => print('task error' + error.toString()));
        database
            .execute(
                'CREATE TABLE subTasks (id INTEGER PRIMARY KEY ,body TEXT ,isDone BOOLEAN,tasks_id INTEGER,FOREIGN KEY (tasks_id) REFERENCES tasks (id) ON DELETE CASCADE)')
            .then((value) => print('subtask table created'))
            .catchError((error) => print('subtask error' + error.toString()));
        database
            .execute(
                'CREATE TABLE notes_images (id INTEGER PRIMARY KEY ,link TEXT ,note_id INTEGER,FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE)')
            .then((value) => print('notes images table created'))
            .catchError((error) => print('subtask error' + error.toString()));
        database
            .execute(
                'CREATE TABLE memories_images (id INTEGER PRIMARY KEY ,link TEXT ,memory_id INTEGER,FOREIGN KEY (memory_id) REFERENCES memories (id) ON DELETE CASCADE)')
            .then((value) => print('notes images table created'))
            .catchError((error) => print('subtask error' + error.toString()));
        database
            .execute(
                'CREATE TABLE voices (id INTEGER PRIMARY KEY ,link TEXT ,note_id INTEGER,FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE)')
            .then((value) => print('voices table created'))
            .catchError((error) => print('subtask error' + error.toString()));
      },
      onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) {},
    ).then((value) {
      database = value;
      getDataAndRebuild();
      emit(AppCreateDatabaseState());
    });
  }

  void getDataAndRebuild() async{
    isLoading=true;
    emit(AppLoaderState());
    getNoteDataFromDatabase(database);
    getNoteImagesFromDatabase(database);
    // emit(AddNoteRebuildUIState());
  }

  void getNoteDataFromDatabase(db) {
    notesDataList = [];
    // emit(AppLoaderState());
    db.rawQuery('SELECT * FROM notes').then((value) {
      value.forEach((element) {
        notesDataList.add(element);
      });
      getNoteImagesFromDatabase(db);
      // emit(AppNoteGetDatabaseState());
    });
  }

  void getNoteImagesFromDatabase(db) async {
    cachedImagesList = [];
    db.rawQuery('SELECT * FROM notes_images').then((value) {
      cachedImagesList = value ;
      getAllNotesDataWithItsImages(value);
    });
    // emit(AddNoteGetCachedImagesPathsFromDatabaseState());
  }
  // fun to convert RawQuery type to List<Map<String, dynamic>>
  List<Map<String, dynamic>> makeModifiableResults(
      List<Map<String, dynamic>> results) {
    // Generate modifiable
    return List<Map<String, dynamic>>.generate(
        results.length, (index) => Map<String, dynamic>.from(results[index]),
        growable: true);
  }

  void getAllNotesDataWithItsImages(List imagesData) async {
    List notesDataModified = makeModifiableResults(notesDataList);
    List oneNoteImagesList = [];
    Map<String,dynamic> oneNoteData = {} ;
    List<Map<String,dynamic>> allNotesCompleteData = [];

    for (int i = 0; i < notesDataModified.length; i++) {
      oneNoteImagesList = [];
      oneNoteData = notesDataModified[i];
      oneNoteData.putIfAbsent('images', () => []);
      for (int y = 0; y < imagesData.length; y++) {
        if (notesDataModified[i]['id'] == imagesData[y]['note_id']) {
          oneNoteImagesList.add(imagesData[y]);
        }
      }
      if(oneNoteImagesList.isNotEmpty)
        oneNoteData.update('images',(dynamic val) => oneNoteImagesList);
      allNotesCompleteData.add(oneNoteData);
    }
    allNotesDataList = allNotesCompleteData ;
    isLoading=false;
    emit(AppRebuildUIState());

  }

  Future insertDatabase(
      ) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title ,createdTime ,createdDate ,taskDate ,taskTime) VALUES ("asdfalsdkfj","asdfa","asdfa","asdf3e","asdfasd")')
          .then((value) {
      }).catchError((error) {
        print(error.toString());
      });
      txn
          .rawInsert(
              'INSERT INTO subTasks (body ,isDone ,tasks_id ) VALUES ("asdfalsdkfj",false,1)')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print(error.toString());
      });
    });
  }

  void addFABBtnRoutes(context){
    if(tabBarController!.index == 0){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => AddNote(database: database,))).then((value){
        getDataAndRebuild();
      });
    }else if(tabBarController!.index == 1){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddTask())).then((value){

      });
    } else{
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddMemory(database: database))).then((value){

      });
    }

  }
}
