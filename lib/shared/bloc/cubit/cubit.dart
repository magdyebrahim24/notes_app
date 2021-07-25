import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/shared/bloc/states/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  Database? database;

  void creatDatabase() {
    openDatabase(
      'database.db',
      version: 1,
      onCreate: (database, version) {
        print('database is created');
        database
            .execute(
            'CREATE TABLE notes (id INTEGER PRIMARY KEY ,title TEXT ,body TEXT ,image TEXT,voice TEXT,createdTime TEXT ,createdDate TEXT)')
            .then((value) => print('notes table created'))
            .catchError((error) => print('note error'+error.toString()));
        database
            .execute(
            'CREATE TABLE memories (id INTEGER PRIMARY KEY ,title TEXT ,body TEXT ,image TEXT,createdTime TEXT ,createdDate TEXT,memoryDate TEXT)')
            .then((value) => print('memory table created'))
            .catchError((error) => print('memory error'+error.toString()));
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT ,createdTime TEXT ,createdDate TEXT,taskDate TEXT,taskTime TEXT)')
            .then((value) => print('task table created'))
            .catchError((error) => print('task error'+error.toString()));
        database
            .execute(
            'CREATE TABLE subTasks (id INTEGER PRIMARY KEY ,body TEXT ,isDone BOOLEAN,tasks_id INTEGER,FOREIGN KEY (tasks_id) REFERENCES tasks (id) ON DELETE CASCADE)')
            .then((value) => print('subtask table created'))
            .catchError((error) => print('subtask error'+error.toString()));

      },
      onConfigure: (Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');},
      onOpen: (database) {
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      // emit(AppCreatDatabaseState());
    }
    );
  }
  void getDataFromDatabase(database)  {
    // newTasks=[];
    // doneTasks=[];
    // archivedTasks=[];
    // emit(AppLoaderState());
    database!.rawQuery('SELECT * FROM notes').then((value) {
      // value.forEach()
      value.forEach((element){
        print(element);
        // if(element['status'] == 'new')
        //   newTasks.add(element);
        // else if(element['status'] == 'don')
        //   doneTasks.add(element);
        // else
        //   archivedTasks.add(element);
      });
      // emit(AppGetDatabaseState());
    });
    database!.rawQuery('SELECT * FROM subTasks').then((value) {
      print(value);
      // value.forEach((element){
      // if(element['status'] == 'new')
      //   newTasks.add(element);
      // else if(element['status'] == 'don')
      //   doneTasks.add(element);
      // else
      //   archivedTasks.add(element);
      // });
      // emit(AppGetDatabaseState());
    });
  }

  Future insertDatabase(
  //     {
  //   required String title,
  //   required String time,
  //   required String date,
  // }
  ) async{
    await database!.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks (title ,createdTime ,createdDate ,taskDate ,taskTime) VALUES ("asdfalsdkfj","asdfa","asdfa","asdf3e","asdfasd")')
          .then((value) {
        print('$value inserted successfully');
        // emit(AppInsertDatabaseState());
        // getDataFromDatabase(database);
      }).catchError((error) => print(error.toString()));
      txn
          .rawInsert(
          'INSERT INTO subTasks (body ,isDone ,tasks_id ) VALUES ("asdfalsdkfj",false,1)')
          .then((value) {
        print('$value inserted successfully');
        // emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) => print(error.toString()));


      return Future.value(false);
    });
  }
  void deleteData({
    required int id
  }
      ){
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)  {
      getDataFromDatabase(database);
      // emit(AppDeleteDatabaseState());
    });
  }


}