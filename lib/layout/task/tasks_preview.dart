import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';

class TasksPreview extends StatelessWidget {
  final isLoading;
  final onTapFun;
  final List body;
  final onLongPress;
  final selectedItemIndex;

  TasksPreview({required this.body, this.onTapFun, this.isLoading, this.onLongPress, this.selectedItemIndex});

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
              color: index != selectedItemIndex ?Theme.of(context).cardTheme.color: Theme.of(context).hintColor.withOpacity(.4),
              onTapFun: () => onTapFun(body[index]),
              data: body[index],
              index: index,
              onLongPress: ()=>onLongPress(body[index], index),
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
  final onLongPress;
  final color;
  // final isFavorite;

  const TaskCard({this.onTapFun, this.data, this.index, this.onLongPress, this.color});
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
          elevation: 0,
          color: color,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          semanticContainer: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onLongPress: onLongPress,
            onTap: onTapFun,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data['is_favorite'] == 1 ?
                  Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                    SvgPicture.asset('assets/icons/fill_star.svg',color: Theme.of(context).textTheme.headline1!.color,),
                  ],) : SizedBox(height: 10,),
                  Text(
                    data['title'] ?? 'Title',
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline1
                  ),
                  SizedBox(height: 10,),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data['subTasks'].length < 10 ? data['subTasks'].length : 10,
                    itemBuilder: (context, i) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 5,),
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
              Padding(
                padding:  EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Row(
                  children: [
                    Icon(Icons.access_time_outlined,
                      size: 12, color: Theme.of(context).textTheme.headline1!.color,),
                    SizedBox(width: 10,),
                    Text(
                                '${data['taskTime']}', maxLines: 1,
                                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 9.5),
                              ),
                  ],
                ),
              ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
