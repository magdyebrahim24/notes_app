import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/layout/task/bloc/states/states.dart';
import 'package:notes_app/shared/components/reusable/time_date.dart';
import 'package:sqflite/sqflite.dart';

class AddTaskCubit extends Cubit<AppTaskStates> {
  AddTaskCubit() : super(AppTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of(context);
  List newTasksList = [];
  String? dateController;
  String? timeController;
  int? taskID;
  List taskList = [];
  List subTasksList = [];
  List subTasksStoredDBList = [];
  late Database database;
  bool isFavorite = false;


  onBuild(data) async {
    var db = await openDatabase('database.db');
    database = db;

    if (data != null) {
      taskID = data['id'];
      titleController.text = data['title'];
      dateController = data['taskDate'];
      timeController = data['taskTime'];
      subTasksList = modifySubTasksList(data['subTasks']);
      isFavorite = data['is_favorite'] == 1 ? true : false;
    }
    emit(AppTaskBuildState());
  }

  TextEditingController titleController = TextEditingController();

  void changeCheckbox(index) {
    subTasksList[index]['isDone'] = !subTasksList[index]['isDone'];
    emit(AppTaskChengCheckboxState());
  }

  void changeNewSubTAskCheckbox(index) {
    newTasksList[index]['isDone'] = !newTasksList[index]['isDone'];
    emit(AppTaskChengCheckboxState());
  }

  void addNewTask() {
    newTasksList.add({'isDone': false, 'body': TextEditingController()});
    emit(AppTaskNewTaskState());
  }

  void deleteSubTaskFromDataBase(index, context) async {
    database.rawDelete('DELETE FROM subTasks WHERE id = ?',
        [subTasksList[index]['id']]).then((value) {
      print('sub task id ==> ' +
          subTasksList[index]['id'].toString() +
          'has been deleted');
      subTasksList.removeAt(index);
      getSubTaskData();
      emit(AppTaskRemoveSubTaskState());
    }).catchError((error) {
      print(error);
    });
  }

  void deleteUnSavedSubTask(index) {
    newTasksList.removeAt(index);
    emit(AppTaskRemoveSubTaskState());
  }

  void deleteTask(context) {
    database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [taskID]).then((value) {
      Navigator.pop(context);
      print('task $taskID ==> ' + 'has been deleted');
      // emit(DeleteTaskState());
    }).catchError((error) {
      print(error);
    });
  }

  void datePicker(context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.parse('1900-09-22'),
      lastDate: DateTime.now(),
    ).then((value) {
      dateController = DateFormat.yMMMd().format(value!);
      emit(AppTaskTimePickerState());
    }).catchError((error) {});
  }

  void timePicker(context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      timeController = value!.format(context).toString();
      emit(AppTaskTimePickerState());
    }).catchError((error) {});
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
              'INSERT INTO tasks (title ,createdTime ,createdDate ,taskDate ,taskTime) VALUES ("$title","$createdTime","$createdDate","$taskDate","$taskTime")')
          .then((value) {
        taskID = value;
        getTaskDataFromDatabase();
        if (newTasksList.isNotEmpty) insertSubTasks(newTasks: newTasksList);
      }).catchError((error) {
        print(error.toString());
      });

      return Future.value(true);
    });
    // titleFocus.unfocus();
    // bodyFocus.unfocus();
    emit(AddTaskInsertDatabaseState());
  }

  void getTaskDataFromDatabase() async {
    taskList = [];
    // emit(AppLoaderState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      taskList = value;
      value.forEach((element) {
        print(element);
      });
      emit(AddTaskGetSubTasksFromDatabaseState());
    });
  }

  void getSubTaskData() async {
    subTasksList = [];
    subTasksStoredDBList = [];
    // emit(AppLoaderState());
    print('all sub tasks ------------------------');
    database.rawQuery(
        'SELECT * FROM subTasks WHERE tasks_id = ?', [taskID]).then((value) {
      value.forEach((element) {
        print(element);
      });
      subTasksStoredDBList = value;
      subTasksList = modifySubTasksList(value);
      emit(AddTaskGetSubTasksFromDatabaseState());
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

  void updateTask(
  context,{required String title,
      required String taskDate,
      required String taskTime,
      required int id}) async {

    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);

    database.rawUpdate(
        'UPDATE tasks SET title = ? , createdTime = ? ,createdDate = ? ,taskDate = ? ,taskTime = ? WHERE id = ?',
        [
          '$title',
          '$createdTime',
          '$createdDate',
          '$taskDate',
          '$taskTime',
          id
        ]).then((value) {
      getTaskDataFromDatabase();

      // titleFocus.unfocus();
      // bodyFocus.unfocus();
      emit(AddTaskUpdateTitleAndBodyState());
    });
  }

  void saveTaskBTNFun(context) {
    if (taskID == null) {
      insertNewTask(
        context,
        title: titleController.text,
        taskDate: dateController!,
        taskTime: timeController!,
      );
      if (newTasksList.isNotEmpty) insertSubTasks(newTasks: newTasksList);
    } else {
      updateTask(context,
          id: taskID!,
          taskDate: dateController!,
          taskTime: timeController!,
          title: titleController.text);

      if (newTasksList.isNotEmpty) insertSubTasks(newTasks: newTasksList);

      updateSubTasks();
    }
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
    emit(AddSubTasksUpdateSubTaskState());
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
    print('----------------------');
    temp.forEach((element) {
      print(element);
    });

    return temp;
  }

  void addToFavorite(){
    print('1/');
    database.rawUpdate(
        'UPDATE tasks SET is_favorite = ? WHERE id = ?',
        [!isFavorite, taskID]).then((val){
      isFavorite = !isFavorite ;
      print('$val $isFavorite is done');
      emit(AddTaskToFavoriteState());
      getTaskDataFromDatabase();
    }).catchError((error){
      print(error);
    });
  }

  @override
  Future<void> close() async{
    // database.close();
    return super.close();
  }
}
