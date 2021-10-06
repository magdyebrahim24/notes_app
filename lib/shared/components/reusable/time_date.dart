import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeAndDate{

  static getDate(){
    var now = new DateTime.now();
    String date = DateFormat.yMMMd().format(now).toString();
    return date ;
  }

  static getTime(context){
    var time = TimeOfDay.now();
    String formatter = time.format(context).toString();
    return formatter ;
  }

 static Future<String?> getDatePicker(context, {required firstDate,required lastDate})async {
    String? date;
   await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
     // initialEntryMode: DatePickerEntryMode.input,

    ).then((value) {
      date = DateFormat.yMMMd().format(value!);
    }).catchError((error) {print(error);});
    return date;
  }

  static Future<String?> getTimePicker(context) async {
    String? time;
    await  showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

      // initialEntryMode: TimePickerEntryMode.input,
    ).then((value) {
      time = value!.format(context).toString();
    }).catchError((error) {print(error);});
    return time;
  }
}

