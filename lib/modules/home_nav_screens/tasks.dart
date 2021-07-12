
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/shared/components/note_card.dart';

class TaskScreen extends StatelessWidget {
  List x = [
    Container(width: 100, height: 50, color: Colors.red,),
    Container(width: 100, height: 100, color: Colors.yellow,),
    Container(width: 100, height: 200, color: Colors.orange,),
    Container(width: 100, height: 30, color: Colors.grey,),
  ];

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) => x[index],
      staggeredTileBuilder: (int index) =>
      new StaggeredTile.fit(1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}