import 'package:bloc/bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/layout/dashboard/bloc/app_states.dart';
import 'package:notes_app/layout/verify/create_pass.dart';
import 'package:notes_app/layout/verify/login.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/shared/functions/functions.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  TabController? tabBarController;
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

  bool showFAB = true;

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
    tabBarController = TabController(
      length: 3,
      vsync: x,
    );
    tabBarController!.addListener(() {
      if (tabBarSelectedIndex != tabBarController!.index) {
        tabBarSelectedIndex = tabBarController!.index;
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
  closeDrawer(){
    if (isDrawerCollapsed)
      drawerController!.forward();
    else
      drawerController!.reverse();

    isDrawerCollapsed = !isDrawerCollapsed;

    emit(OpenDrawerState());

  }

  void createDatabase() {
    openDatabase(
      'database.db',
      version: 1,
      onCreate: (database, version) {
        print('database is created');
        database
            .execute(
                'CREATE TABLE notes (id INTEGER PRIMARY KEY ,title TEXT ,body TEXT ,createdTime TEXT ,createdDate TEXT,is_favorite BOOLEAN DEFAULT 0 NOT NULL,favorite_add_date TEXT,is_secret BOOLEAN DEFAULT 0 NOT NULL,type TEXT DEFAULT note NOT NULL)')
            .then((value) => print('notes table created'))
            .catchError((error) => print('note error' + error.toString()));
        database
            .execute(
                'CREATE TABLE memories (id INTEGER PRIMARY KEY ,title TEXT ,body TEXT ,createdTime TEXT ,createdDate TEXT,memoryDate TEXT,is_favorite BOOLEAN DEFAULT 0 NOT NULL,favorite_add_date TEXT,is_secret BOOLEAN DEFAULT 0 NOT NULL,type TEXT DEFAULT task NOT NULL)')
            .then((value) => print('memory table created'))
            .catchError((error) => print('memory error' + error.toString()));
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT ,createdTime TEXT ,createdDate TEXT,taskDate TEXT,taskTime TEXT,is_favorite BOOLEAN DEFAULT 0 NOT NULL,favorite_add_date TEXT,is_secret BOOLEAN DEFAULT 0 NOT NULL,type TEXT DEFAULT memory NOT NULL)')
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

  void getDataAndRebuild() async {
    isLoading = true;
    emit(AppLoaderState());
    await getAllNotesData();
    await getAllTasksDataWithItSubTasks();
    await getAllMemoriesDataWithItsImages();
    isLoading = false;
    emit(AppLoaderState());
  }

  Future getAllNotesData() async {
    // get  notes data
    List<Map<String, dynamic>> notesDataList = await database!
        .rawQuery('SELECT * FROM notes WHERE is_secret = ?', [0]);
    // get notes images data
    List cachedNotesImagesList =
        await database!.rawQuery('SELECT * FROM notes_images');
    List recordsList = await database!.rawQuery('SELECT * FROM voices');

    allNotesDataList = assignSubListToData(
        notesDataList, cachedNotesImagesList, 'images', 'note_id',
        voices: recordsList, voiceKey: 'voices', voiceId: 'note_id');
    // print(allNotesDataList);
    emit(GetNotesData());
  }

  Future getAllTasksDataWithItSubTasks() async {
    // get all task data
    List<Map<String, dynamic>> tasksDataList = await database!
        .rawQuery('SELECT * FROM tasks WHERE is_secret = ?', [0]);

    // get all task sub tasks data
    List subTasksList = await database!.rawQuery('SELECT * FROM subTasks');

    allTasksDataList = assignSubListToData(
        tasksDataList, subTasksList, 'subTasks', 'tasks_id');
    emit(GetTasksData());
  }

  Future getAllMemoriesDataWithItsImages() async {
    // get all user memories
    List<Map<String, dynamic>> memoriesDataList = await database!
        .rawQuery('SELECT * FROM memories WHERE is_secret = ?', [0]);
    // get memories images
    List cachedMemoriesImagesList =
        await database!.rawQuery('SELECT * FROM memories_images');

    allMemoriesDataList = assignSubListToData(
        memoriesDataList, cachedMemoriesImagesList, 'images', 'memory_id');
    emit(GetTasksData());
  }

  void addFABBtnRoutes(context) async {
    tabBarController!.addListener(() {
      if (tabBarSelectedIndex != tabBarController!.index) {
        tabBarSelectedIndex = tabBarController!.index;
        emit(TapChangeState());
      }
    });
    if (tabBarSelectedIndex == 0) {
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNote()))
          .then((value) {
        getAllNotesData();
      });
    } else if (tabBarSelectedIndex == 1) {
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()))
          .then((value) {
        getAllTasksDataWithItSubTasks();
      });
    } else {
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddMemory()))
          .then((value) {
        getAllMemoriesDataWithItsImages();
      });
    }
  }

  void addToFavorite(context,
      {isFavorite, itemId, tableName, itemsList, index}) async {
    List<Map<String, dynamic>> temp = itemsList;
    Map<String, dynamic> item = temp[index];
    await favoriteFun(
        context, database, tableName, isFavorite, itemId, item['is_secret']);
    item['is_favorite'] = !isFavorite == true ? 1 : 0;
    itemsList[index] = item;
    emit(AddToFavoriteState());
    Navigator.pop(context);
  }

  void deleteFun(context,
      {required int id, tableName, index, listOfData, recordsList}) async {
    await deleteOneItem(context, database,
        id: id,
        tableName: tableName,
        cachedImagesList: listOfData,
        recordsList: recordsList ?? []);
    listOfData.removeAt(index);
    emit(DeleteItemState());
  }

  Future addToSecret(context, id, tableName, listOfData, index) async{
    String? pass = CacheHelper.getString(key: 'secret_password');
    Navigator.pop(context);
    if (pass == null) {
    await  Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreatePass(
                    id: id,
                    table: tableName,
                  )));
    } else {
    await  Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Login(
                    id: id,
                    table: tableName,
                  )));
    }
    if(tableName == 'notes'){
    await  getAllNotesData();
    }else if(tableName == 'tasks'){
      await getAllTasksDataWithItSubTasks();
    }else if(tableName == 'memories'){
      await getAllMemoriesDataWithItsImages();
    }
    emit(AddToSecretItemState());
  }

  int? selectedItemIndex;
  void toggleFAB(index) {
    if (showFAB) {
      showFAB = false;
    } else {
      showFAB = true;
    }
    selectedItemIndex = index;
    emit(ToggleFABState());
  }

  @override
  Future<void> close() {
    tabBarController!.dispose();
    drawerController!.dispose();
    return super.close();
  }
}
