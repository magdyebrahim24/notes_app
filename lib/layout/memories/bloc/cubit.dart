import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/memories/bloc/states.dart';
import 'package:intl/intl.dart';

class AddMemoryCubit extends Cubit<AppMemoryStates> {
  AddMemoryCubit() : super(AppMemoryInitialState());

  static AddMemoryCubit get(context) => BlocProvider.of(context);

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
      emit(AppMemoryTimePickerState());
    }).catchError((error){});


  }
}