import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GridViewForImages extends StatelessWidget {
  final isLoading;
  final List body;

  GridViewForImages(this.body, this.isLoading,);

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
        GestureDetector(
          onTap: (){},
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.file(
                File(body[index]['link']),
                fit: BoxFit.fitWidth,
              )),
        ),
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10.0,
          );
  }
}

