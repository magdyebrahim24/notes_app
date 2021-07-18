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

  String? dateController;
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
  String? timeController;
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

}
