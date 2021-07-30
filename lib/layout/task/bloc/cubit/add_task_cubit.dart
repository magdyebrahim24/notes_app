import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/layout/task/bloc/states/states.dart';


class AddTaskCubit extends Cubit<AppTaskStates> {
  AddTaskCubit() : super(AppTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of(context);
  List newTask=[];
  String? dateController;
  String? timeController;
  int? taskID;
  List taskList=[];

  TextEditingController titleController = TextEditingController();

  void changeCheckbox(index){
    newTask[index]['isChecked']=!newTask[index]['isChecked'];
    emit(AppTaskChengCheckboxState());
  }

  void addNewTask(){
    newTask.add({'isChecked':false,'task':TextEditingController()});
    emit(AppTaskNewTaskState());
  }

  void deleteTask(index){
    newTask.removeAt(index);
    emit(AppTaskRemoveTaskState());
  }

  void datePicker(context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.parse('1900-09-22'),
      lastDate: DateTime.now(),
    )
        .then((value) {
      dateController = DateFormat.yMMMd()
          .format(value!);
      emit(AppTaskTimePickerState());
    }).catchError((error){});


  }

  void timePicker(context){
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    )
        .then((value) {
      timeController =value!.format(context).toString();
      emit(AppTaskTimePickerState());
    }).catchError((error){});


  }

  Future insertNewTask(
      database, {
        required String title,
        required String taskDate,
        required String taskTime,
      }) async {
    // var db = await openDatabase('database.db');
    DateTime dateTime = DateTime.now();
    String createdDate = dateTime.toString().split(' ').first;
    String time = dateTime.toString().split(' ').last;
    String createdTime = time.toString().split('.').first;
    await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks (title ,createdTime ,createdDate ,taskDate ,taskTime) VALUES ("$title","$createdTime","$createdDate","$taskDate","$taskTime")')
          .then((value) {
        taskID = value;
        getTaskDataFromDatabase(database);
        // saveSelectedImagesToPhoneCache(database);
        // getNoteImagesFromDatabase(database, noteId);
        print(value);
      }).catchError((error) {
        print(error.toString());
      });

      return Future.value(true);
    });
    // titleFocus.unfocus();
    // bodyFocus.unfocus();
    emit(AddTaskInsertDatabaseState());
  }

  void getTaskDataFromDatabase(db) async {
    taskList = [];
    // emit(AppLoaderState());
    db.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        print(element);
        taskList.add(element);
      });
      emit(AddTaskGetDatabaseState());
    });
  }

  void updateTask(db,
      {required String title ,required String taskDate ,required String taskTime ,required int id}) async {
    DateTime dateTime = DateTime.now();
    String createdDate = dateTime.toString().split(' ').first;
    String time = dateTime.toString().split(' ').last;
    String createdTime = time.toString().split('.').first;

    db.rawUpdate(
        'UPDATE tasks SET title = ? , createdTime = ? ,createdDate = ? ,taskDate = ? ,taskTime = ? WHERE id = ?',
        ['$title', '$createdTime', '$createdDate', '$taskDate', '$taskTime', id]).then((value) {
      // saveSelectedImagesToPhoneCache(db);
      // getNoteImagesFromDatabase(db, noteId);
      getTaskDataFromDatabase(db);
      // titleFocus.unfocus();
      // bodyFocus.unfocus();
    });
    emit(AddTaskUpdateTitleAndBodyState());
  }
}
