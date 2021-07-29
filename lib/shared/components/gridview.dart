import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/shared/components/note_card.dart';

class GridViewComponents extends StatelessWidget {
  final isLoading;
  final funForRebuild;
  final List body;
  final database;

  GridViewComponents(this.body, this.database, this.funForRebuild, this.isLoading);

  @override
  Widget build(BuildContext context) {
    return isLoading == true ?Center(child: CircularProgressIndicator()):StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: body.length,
      itemBuilder: (BuildContext context, int index) => NoteCard(data: body[index],database: database,funForRebuild: () => funForRebuild(),),
      staggeredTileBuilder: (int index) =>
      new StaggeredTile.fit(1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
