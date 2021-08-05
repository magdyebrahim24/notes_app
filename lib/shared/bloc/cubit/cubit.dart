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

  // have notes data and images data
  List<Map<String, dynamic>> allNotesDataList = [];
  List<Map<String, dynamic>> allMemoriesDataList = [];
  List<Map<String, dynamic>> allTasksDataList = [];
  bool isLoading = true;
  int tabBarSelectedIndex = 0;

  // init state function
  void onBuildPage(x) {
    createDatabase();
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
    tabBarController!.addListener(() {
      if (tabBarSelectedIndex != tabBarController!.index) {
        tabBarSelectedIndex = tabBarController!.index;
        print('done');
        fABController!.forward(from: 0.0);
        emit(TapChangeState());
      }
    });
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
                'CREATE TABLE notes (id INTEGER PRIMARY KEY ,title TEXT ,body TEXT ,createdTime TEXT ,createdDate TEXT,is_favorite BOOLEAN)')
            .then((value) => print('notes table created'))
            .catchError((error) => print('note error' + error.toString()));
        database
            .execute(
                'CREATE TABLE memories (id INTEGER PRIMARY KEY ,title TEXT ,body TEXT ,createdTime TEXT ,createdDate TEXT,memoryDate TEXT,is_favorite BOOLEAN)')
            .then((value) => print('memory table created'))
            .catchError((error) => print('memory error' + error.toString()));
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT ,createdTime TEXT ,createdDate TEXT,taskDate TEXT,taskTime TEXT,is_favorite BOOLEAN)')
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
    ).then((value){
     database = value;
      getDataAndRebuild();
      emit(AppCreateDatabaseState());
    });
  }

  Future appData() async {
    getNotesDataWithItsImages();
    getAllTasksDataWithItSubTasks();
    getAllMemoriesDataWithItsImages();
  }

  void getDataAndRebuild() async {
    isLoading = true;
    emit(AppLoaderState());
    await appData();
    isLoading = false;
    emit(AppLoaderState());
  }

  // fun to convert RawQuery type to List<Map<String, dynamic>>
  List<Map<String, dynamic>> makeModifiableResults(
      List<Map<String, dynamic>> results) {
    // Generate modifiable
    return List<Map<String, dynamic>>.generate(
        results.length, (index) => Map<String, dynamic>.from(results[index]),
        growable: true);
  }

  void getNotesDataWithItsImages() async {
    // get all notes data
    List<Map<String, dynamic>> notesDataList = [];
    await database!.rawQuery('SELECT * FROM notes').then((value) {
      notesDataList = value;
    });
    // get all notes images data
    List cachedNotesImagesList = [];
    await database!.rawQuery('SELECT * FROM notes_images').then((value) {
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

    allNotesDataList = allNotesCompleteData;
    emit(GetNotesData());
  }

  void getAllTasksDataWithItSubTasks() async {
    // get all task data
    List<Map<String, dynamic>> tasksDataList = [];
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      tasksDataList = value;
    });

    // get all task sub tasks data
    List subTasksList = [];
    await database!.rawQuery('SELECT * FROM subTasks').then((value) {
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

    allTasksDataList = allTasksCompleteData;
    emit(GetTasksData());

  }

  void getAllMemoriesDataWithItsImages() async {
    // get all user memories
    List<Map<String, dynamic>> memoriesDataList = [];
    await database!.rawQuery('SELECT * FROM memories').then((value) {
      memoriesDataList = value;
    });
    // get memories images
    List cachedMemoriesImagesList = [];
    await database!.rawQuery('SELECT * FROM memories_images').then((value) {
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

    allMemoriesDataList = allMemoriesCompleteData;
    emit(GetTasksData());
  }

  void addFABBtnRoutes(context) {
    if (tabBarController!.index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddNote(
                  ))).then((value) {
        getNotesDataWithItsImages();
      });
    } else if (tabBarController!.index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddTask())).then((value) {
                    getAllTasksDataWithItSubTasks();
      });
    } else {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddMemory(database: database)))
          .then((value) {
            getAllMemoriesDataWithItsImages();
      });
    }
  }
}
