
import 'package:flutter/material.dart';
import 'package:notes_app/shared/components/gridvoew.dart';

class TaskScreen extends StatelessWidget {
 final List x = [
    Container(width: 100, height: 50, color: Colors.red,),
    Container(width: 100, height: 100, color: Colors.yellow,),
    Container(width: 100, height: 200, color: Colors.orange,),
    Container(width: 100, height: 30, color: Colors.grey,),
  ];

  @override
  Widget build(BuildContext context) {
    return GridViewComponents();
  }
}