import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/shared/components/note_card.dart';

class GridViewComponents extends StatelessWidget {
  final List body;
final database;

  GridViewComponents(this.body, this.database);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: body.length,
      itemBuilder: (BuildContext context, int index) => NoteCard(body: body[index],database: database,),
      staggeredTileBuilder: (int index) =>
      new StaggeredTile.fit(1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
