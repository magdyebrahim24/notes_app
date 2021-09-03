import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/layout/task/bloc/add_task_states.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/shared/components/reusable/time_date.dart';
import 'package:notes_app/shared/functions/functions.dart';
import 'package:notes_app/verify/create_pass.dart';
import 'package:notes_app/verify/login.dart';
import 'package:sqflite/sqflite.dart';

class AddTaskCubit extends Cubit<AppTaskStates> {
  AddTaskCubit() : super(AppTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of(context);
  List newTasksList = [];
  String? taskDate;
  String? taskTime;
  int? taskID;
  List subTasksList = [];
  List subTasksStoredDBList = [];
  late Database database;
  bool isFavorite = false;
  FocusNode titleFocus = new FocusNode();
  TextEditingController titleController = TextEditingController();

  onBuild(data) async {
    var db = await openDatabase('database.db');
    database = db;

    if (data != null) {
      taskID = data['id'];
      titleController.text = data['title'];
      if (data['taskDate'].toString() != 'null')
        taskDate = data['taskDate'];
      if (data['taskTime'].toString() != 'null')
        taskTime = data['taskTime'];
      subTasksList = modifySubTasksList(data['subTasks']);
      isFavorite = data['is_favorite'] == 1 ? true : false;
    }
    emit(AppTaskBuildState());
  }


  void changeCheckbox(index) {
    subTasksList[index]['isDone'] = !subTasksList[index]['isDone'];
    emit(ChangeCheckboxState());
  }

  void changeNewSubTaskCheckbox(index) {
    newTasksList[index]['isDone'] = !newTasksList[index]['isDone'];
    emit(ChangeCheckboxState());
  }

  void addNewSubTask() {
    newTasksList.add({'isDone': false, 'body': TextEditingController()});
    emit(AddNewSubTaskState());
  }

  void deleteOneSubTaskFrom(index, context) async {
    database.rawDelete('DELETE FROM subTasks WHERE id = ?',
        [subTasksList[index]['id']]).then((value) {
      print('sub task id ==> ' +
          subTasksList[index]['id'].toString() +
          'has been deleted');
      subTasksList.removeAt(index);
      emit(RemoveSubTaskState());
    }).catchError((error) {
      print(error);
    });
  }

  void deleteUnSavedSubTask(index) {
    newTasksList.removeAt(index);
    emit(RemoveSubTaskState());
  }

  void deleteTask(context)=> deleteOneItem(context, database, id: taskID, tableName: 'tasks', cachedImagesList: [], recordsList: []);

  void datePicker(context) async{
    taskDate = await TimeAndDate.getDatePicker(context, firstDate: DateTime.now(), lastDate:DateTime.now().add(Duration(days: 1000)));
    emit(TaskDateTimePickerState());
  }

  void timePicker(context) async {
    taskTime = await TimeAndDate.getTimePicker(context);
    emit(TaskDateTimePickerState());
  }

  Future insertNewTask(
    context, {
    required String title,
    required String taskDate,
    required String taskTime,
  }) async {
    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title ,createdTime ,createdDate ,taskDate ,taskTime,type) VALUES ("$title","$createdTime","$createdDate","${taskDate.toString()}","${taskTime.toString()}","task")')
          .then((value) {
        taskID = value;
        if (newTasksList.isNotEmpty) insertSubTasks(newTasks: newTasksList);
      }).catchError((error) {
        print(error.toString());
      });
      return Future.value(true);
    });
    titleFocus.unfocus();
    emit(InsertNewTaskState());
  }

  void getSubTaskData() async {
    subTasksList = [];
    subTasksStoredDBList = [];
    database.rawQuery(
        'SELECT * FROM subTasks WHERE tasks_id = ?', [taskID]).then((value) {
      subTasksStoredDBList = value;
      subTasksList = modifySubTasksList(value);
      emit(GetSubTasksFromDatabaseState());
    });
  }

  void insertSubTasks({required List newTasks}) async {
    await database.transaction((txn) {
      for (int i = 0; i < newTasksList.length; i++) {
        txn.rawInsert(
            'INSERT INTO subTasks (body,isDone,tasks_id) VALUES (?,?,?)', [
          newTasks[i]['body'].text,
          newTasks[i]['isDone'],
          taskID
        ]).catchError((error) {
          print(error.toString());
        });
      }
      return Future.value(true);
    });
    getSubTaskData();
    newTasksList = [];
    emit(AddSubTasksIntoDatabaseState());
  }

  void updateTask(context,
      {required String title,
      required String taskDate,
      required String taskTime,
      required int id}) async {
    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);
   await database.rawUpdate(
        'UPDATE tasks SET title = ? , createdTime = ? ,createdDate = ? ,taskDate = ? ,taskTime = ? WHERE id = ?',
        [
          '$title',
          '$createdTime',
          '$createdDate',
          '$taskDate',
          '$taskTime',
          id
        ]).then((value) {
      titleFocus.unfocus();
      emit(UpdateTaskTitleState());
    });
  }

  void saveTaskBTNFun(context) {
    if (taskID == null) {
      insertNewTask(
        context,
        title: titleController.text,
        taskDate: taskDate.toString(),
        taskTime: taskTime.toString(),
      );
      if (newTasksList.isNotEmpty) insertSubTasks(newTasks: newTasksList);
    } else {
      updateTask(context,
          id: taskID!,
          taskDate: taskDate.toString(),
          taskTime: taskTime.toString(),
          title: titleController.text);
      if (newTasksList.isNotEmpty) insertSubTasks(newTasks: newTasksList);
      updateSubTasks();
    }
    titleFocus.unfocus();
  }

  void updateSubTasks() async {
    for (int i = 0; i < subTasksStoredDBList.length; i++) {
      if (subTasksStoredDBList[i]['body'] != subTasksList[i]['body'].text ||
          subTasksStoredDBList[i]['isDone'] != subTasksList[i]['isDone']) {
        await database.rawUpdate(
            'UPDATE subTasks SET body = ? , isDone = ?  WHERE id = ?', [
          '${subTasksList[i]['body'].text}',
          subTasksList[i]['isDone'],
          subTasksList[i]['id'],
        ]);
      }
    }
    getSubTaskData();
    emit(UpdateSubTaskState());
  }

  modifySubTasksList(List databaseValues) {
    List temp = [];
    for (int i = 0; i < databaseValues.length; i++) {
      bool isDone = databaseValues[i]['isDone'] == 1 ? true : false;
      temp.add({
        'id': databaseValues[i]['id'],
        'tasks_id': databaseValues[i]['tasks_id'],
        'isDone': isDone,
        'body': TextEditingController(text: databaseValues[i]['body'])
      });
    }
    return temp;
  }

  addToFavorite() async {
    isFavorite = await favoriteFun(database, 'notes', isFavorite, taskID);
    emit(TaskFavoriteState());
  }

  void addTaskToSecret(context) => addToSecret(context, taskID, 'tasks');

  @override
  Future<void> close() {
    titleFocus.dispose();
    titleController.dispose();
    return super.close();
  }

}
