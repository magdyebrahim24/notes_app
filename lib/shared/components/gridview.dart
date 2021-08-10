import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GridViewComponents extends StatelessWidget {
  final isLoading;
  final funForRebuild;
  final List body;
  final childCard;

  GridViewComponents(
      this.body, this.funForRebuild, this.isLoading, this.childCard);

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : StaggeredGridView.countBuilder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 10),
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            itemCount: body.length,
            itemBuilder: (BuildContext context, int index) =>
                childCard(body[index]),
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10.0,
          );
  }
}

Widget imagesCards(
  final imagesObject,
) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.file(
        File(imagesObject['link']),
        fit: BoxFit.fitWidth,
      ));
}
