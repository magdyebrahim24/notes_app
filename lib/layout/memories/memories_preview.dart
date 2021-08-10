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
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 15),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.all(5),
                // elevation: 5,
                color: Color(0xff2e2e3e),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                semanticContainer: true,
                // shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: InkWell(
                  onTap: () => onTapFun(data[index]),
                  child: Column(
                    children: [
                      data[index]['images'].isNotEmpty
                          ? Image.file(
                              File(data[index]['images'][0]['link'].toString()),
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
                           data[index]['title'].toString().isNotEmpty ? Text(
                              data[index]['title'] ?? 'Title',
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ):SizedBox(),
                            data[index]['title'].toString().isNotEmpty ? Container(
                              color: Colors.white24,
                              height: .5,
                              margin: EdgeInsets.symmetric(vertical: 10),
                            ):SizedBox(),
                            data[index]['body'].toString().isNotEmpty ? Padding(
                              padding: const EdgeInsets.only(bottom: 17),
                              child: Text(
                                '${data[index]['body']}',
                                style:
                                    TextStyle(fontSize: 17, color: Colors.white),
                                maxLines: 10,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ):SizedBox(),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${data[index]['createdDate']}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${data[index]['createdTime']}',
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
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
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          );
  }
}
