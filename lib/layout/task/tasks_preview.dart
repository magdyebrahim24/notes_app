import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';

class TasksPreview extends StatelessWidget {
  final isLoading;
  final onTapFun;
  final List body;

  TasksPreview({required this.body, this.onTapFun, this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return circleProcessInductor();
    } else {
      if (body.length != 0) {
        return StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          itemCount: body.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return TaskCard(
              onTapFun: () => onTapFun(body[index]),
              data: body[index],
              index: index,
            );
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        );
      } else {
        return shadedImage('assets/intro/tasks.png');
      }
    }
  }
}

class TaskCard extends StatelessWidget {
  final onTapFun;
  final data;
  final index;
  // final isFavorite;

  const TaskCard({this.onTapFun, this.data, this.index});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // task date
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
          child: Text(
            data['taskDate'],
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          semanticContainer: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(index.isOdd ? 20 : 0),
          //       topLeft: Radius.circular(index.isOdd ? 30 : 0),
          //       bottomRight: Radius.circular(index.isOdd ? 0 : 30),
          //       topRight: Radius.circular(index.isOdd ? 0 : 30),
          //
          //   ),
          // ),
          child: InkWell(
            onTap: onTapFun,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] ?? 'Title',
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                  ),
                  SizedBox(height: 10,),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data['subTasks'].length,
                    itemBuilder: (context, i) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 22,
                            width: 20,
                            child: Transform.scale(
                              scale: .55 ,
                              child: Checkbox(tristate: true,

                                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) => onTapFun,
                                value: data['subTasks'][i]['isDone'] == 0
                                    ? false
                                    : true,
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: Text(
                              '${data['subTasks'][i]['body']}',
                              style: data['subTasks'][i]['isDone'] == 1
                                  ? Theme.of(context).textTheme.bodyText1!.copyWith(decoration: TextDecoration.lineThrough,fontSize: 13,fontWeight: FontWeight.w400)
                                  : Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 13,fontWeight: FontWeight.w400),
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
                  // Directionality(
                  //   textDirection: TextDirection.ltr,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Expanded(
                  //         flex: 4,
                  //         child: Text(
                  //           '${data['createdDate']}',
                  //           maxLines: 1,
                  //           style: Theme.of(context).textTheme.subtitle1,
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Expanded(
                  //         flex: 3,
                  //         child: Align(
                  //           alignment: Alignment.centerRight,
                  //           child: Text(
                  //             '${data[isFavorite?'type':'createdTime']}',
                  //             maxLines: 1,
                  //             softWrap: true,
                  //             overflow: TextOverflow.clip,
                  //             style: Theme.of(context).textTheme.subtitle1,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
