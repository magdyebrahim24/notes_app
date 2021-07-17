import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

}
