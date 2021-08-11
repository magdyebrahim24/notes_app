import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/shared/constants.dart';

class TasksPreview extends StatelessWidget {
  final isLoading;
  final onTapFun;
  final List body;

  TasksPreview(this.body, this.onTapFun, this.isLoading);

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: body.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return TaskCard(() => onTapFun(body[index]), body[index]);
              // return Card(
              //   margin: EdgeInsets.all(5),
              //   // elevation: 5,
              //   clipBehavior: Clip.antiAliasWithSaveLayer,
              //   semanticContainer: true,
              //   // shadowColor: Colors.grey,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(5.0),
              //   ),
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => AddTask(
              //               data: body[index],
              //             ),
              //           )).then((value) {
              //         funForRebuild();
              //       });
              //     },
              //     child: Container(
              //       decoration: BoxDecoration(
              //           color: Color(0xff2e2e3e)),
              //       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             body[index]['title'] ?? 'Title',
              //             maxLines: 2,
              //             softWrap: true,
              //             overflow: TextOverflow.ellipsis,
              //             style: TextStyle(
              //                 fontSize: 22,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white),
              //           ),
              //           Container(
              //             color: Colors.white24,
              //             height: .5,
              //             margin: EdgeInsets.symmetric(vertical: 10),
              //           ),
              //           ListView.builder(
              //             padding: EdgeInsets.zero,
              //             shrinkWrap: true,
              //             physics: NeverScrollableScrollPhysics(),
              //             itemCount: body[index]['subTasks'].length,
              //             itemBuilder: (context, i) {
              //               return Row(
              //                 children: [
              //                   Checkbox(
              //                     shape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(50)),
              //                     onChanged: (value){
              //                       Navigator.push(
              //                           context,
              //                           MaterialPageRoute(
              //                             builder: (context) => AddTask(
              //                               data: body[index],
              //                             ),
              //                           )).then((value) {
              //                         funForRebuild();
              //                       });
              //                     },
              //                     splashRadius: 0 ,
              //                     value:
              //                         body[index]['subTasks'][i]['isDone'] == 0
              //                             ? false
              //                             : true,
              //                     fillColor: MaterialStateProperty.resolveWith(
              //                         (states) => blueColor),
              //                     materialTapTargetSize:
              //                         MaterialTapTargetSize.shrinkWrap,
              //                   ),
              //                   Expanded(
              //                     child: Text(
              //                       '${body[index]['subTasks'][i]['body']}',
              //                       style: TextStyle(
              //                         fontSize: 17,
              //                         color: body[index]['subTasks'][i]
              //                                     ['isDone'] ==
              //                                 1
              //                             ? Colors.white60
              //                             : Colors.white,
              //                         decoration: body[index]['subTasks'][i]
              //                                     ['isDone'] ==
              //                                 1
              //                             ? TextDecoration.lineThrough
              //                             : TextDecoration.none,
              //                       ),
              //                       maxLines: 1,
              //                       softWrap: true,
              //                       overflow: TextOverflow.ellipsis,
              //                     ),
              //                   ),
              //                 ],
              //               );
              //             },
              //           ),
              //           body[index]['subTasks'].isNotEmpty
              //               ? Container(
              //                   color: Colors.white24,
              //                   height: .5,
              //                   margin: EdgeInsets.symmetric(vertical: 10),
              //                 )
              //               : SizedBox(),
              //           Directionality(
              //             textDirection: TextDirection.ltr,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Expanded(
              //                   flex: 4,
              //                   child: Text(
              //                     '${body[index]['createdDate']}',
              //                     maxLines: 1,
              //                     style: TextStyle(
              //                         color: Colors.white, fontSize: 13),
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Expanded(
              //                   flex: 3,
              //                   child: Align(
              //                     alignment: Alignment.centerRight,
              //                     child: Text(
              //                       '${body[index]['createdTime']}',
              //                       maxLines: 1,
              //                       softWrap: true,
              //                       overflow: TextOverflow.clip,
              //                       style: TextStyle(
              //                           color: Colors.white, fontSize: 13),
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // );
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            // mainAxisSpacing: 5.0,
            // crossAxisSpacing: 5.0,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          );
  }
}

class TaskCard extends StatelessWidget {
  final onTapFun;
  final data;

  const TaskCard(this.onTapFun, this.data);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        onTap: onTapFun,
        child: Container(
          decoration: BoxDecoration(color: Color(0xff2e2e3e)),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'] ?? 'Title',
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                color: Colors.white24,
                height: .5,
                margin: EdgeInsets.symmetric(vertical: 10),
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data['subTasks'].length,
                itemBuilder: (context, i) {
                  return Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onChanged: (value) => onTapFun,
                        splashRadius: 0,
                        value:
                            data['subTasks'][i]['isDone'] == 0 ? false : true,
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => blueColor),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Expanded(
                        child: Text(
                          '${data['subTasks'][i]['body']}',
                          style: TextStyle(
                            fontSize: 17,
                            color: data['subTasks'][i]['isDone'] == 1
                                ? Colors.white60
                                : Colors.white,
                            decoration: data['subTasks'][i]['isDone'] == 1
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
              data['subTasks'].isNotEmpty
                  ? Container(
                      color: Colors.white24,
                      height: .5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                    )
                  : SizedBox(),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        '${data['createdDate']}',
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${data['createdTime']}',
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
