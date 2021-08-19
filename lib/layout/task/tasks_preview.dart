import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TasksPreview extends StatelessWidget {
  final isLoading;
  final onTapFun;
  final List body;

  TasksPreview({required this.body, this.onTapFun, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: body.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return TaskCard(onTapFun: () => onTapFun(body[index]), data: body[index]);
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
  final isFavorite;

  const TaskCard({this.onTapFun, this.data,this.isFavorite=false});
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
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'] ?? 'Title',
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 22),
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
                        onChanged: (value) => onTapFun,
                        value:
                            data['subTasks'][i]['isDone'] == 0 ? false : true,
                      ),
                      Expanded(
                        child: Text(
                          '${data['subTasks'][i]['body']}',
                          style: data['subTasks'][i]['isDone'] == 1?
                          Theme.of(context).textTheme.bodyText1:Theme.of(context).textTheme.bodyText2,
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
                        style: Theme.of(context).textTheme.subtitle1,
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
                          '${data[isFavorite?'type':'createdTime']}',
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
      ),
    );
  }
}
