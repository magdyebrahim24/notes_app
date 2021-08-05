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
}