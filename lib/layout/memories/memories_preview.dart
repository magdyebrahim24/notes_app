import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MemoriesPreview extends StatelessWidget {
  final isLoading;
  final onTapFun;
  final List data;

  MemoriesPreview({required this.data, this.onTapFun, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: data.length,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            itemBuilder: (BuildContext context, int index) {
              return MemoryCard(noTapFun: ()=> onTapFun(data[index]), data: data[index]);
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          );
  }
}

class MemoryCard extends StatelessWidget {
  final noTapFun;
  final data;
  final isFavorite;

  const MemoryCard({this.noTapFun, this.data,this.isFavorite=false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 8,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      // shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: noTapFun,
        child: Column(
          children: [
            data['images'].isNotEmpty
                ? Image.file(
              File(data['images'][0]['link'].toString()),
              fit: BoxFit.fitWidth,
              isAntiAlias: true,
              excludeFromSemantics: true,
              gaplessPlayback: true,
            )
                : SizedBox(),
            Padding(
              padding:
              EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data['title'].toString().isNotEmpty
                      ? Text(
                    data['title'] ?? 'Title',
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 22),
                  )
                      : SizedBox(),
                  data['title'].toString().isNotEmpty
                      ? Container(
                    color: Colors.white24,
                    height: .5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                  )
                      : SizedBox(),
                  data['body'].toString().isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(bottom: 17),
                    child: Text(
                      '${data['body']}',
                      style:
                      Theme.of(context).textTheme.bodyText2,
                      maxLines: 10,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                      : SizedBox(),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${data['createdDate']}',
                            maxLines: 1,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${data[isFavorite ?'type':'createdTime']}',
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.clip,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
