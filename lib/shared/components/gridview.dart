import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/shared/components/note_card.dart';

class GridViewComponents extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) => NoteCard(),
      staggeredTileBuilder: (int index) =>
      new StaggeredTile.fit(1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
