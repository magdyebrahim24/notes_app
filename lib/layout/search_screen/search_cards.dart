import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/layout/memories/add%20memory.dart';
import 'package:notes_app/layout/note/add_note.dart';
import 'package:notes_app/layout/task/add_task.dart';

class NoteSearchCard extends StatelessWidget {
  final data;

  const NoteSearchCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: InkWell(
        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote(data: data,),)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Note',style: TextStyle(color: Theme.of(context).hintColor,fontWeight: FontWeight.w500,fontSize: 13),),
                  data['is_favorite'] == 1
                      ? Padding(
                    padding: const EdgeInsets.only(top: 10,right: 10,left: 10),
                    child: SvgPicture.asset(
                      'assets/icons/fill_star.svg',
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  )
                      : SizedBox(),
                ],
              ),
              Divider(endIndent: MediaQuery.of(context).size.width * .4,),
              SizedBox(
                height: 5,
              ),
              // title
              data['title'].toString().isNotEmpty
                  ? Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 10,start: 15),
                      child: Text(
                        data['title'],
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    )
                  : SizedBox(),

              // body
              data['body'].toString().isNotEmpty
                  ? Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 10,start: 15),
                      child: Text(
                        data['body'],
                        style: Theme.of(context).textTheme.caption,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : SizedBox(),

              Padding(
                padding: const EdgeInsetsDirectional.only(start: 15),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      '${data['createdDate']}',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 9.5),
                    ),
                  ),
                  data['voices'].isNotEmpty? Icon(
                    Icons.graphic_eq,
                    color: Theme.of(context).textTheme.headline4!.color,
                    size: 15,
                  ):SizedBox(),

                  SizedBox(width: 10,),
                  data['images'].isNotEmpty? Icon(
                    Icons.image_outlined,
                    color: Theme.of(context).textTheme.headline4!.color,
                    size: 15,
                  ):SizedBox(),
                ],),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TaskSearchCard extends StatelessWidget {
final data ;

  const TaskSearchCard({Key? key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: InkWell(
        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask(data: data,),)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Task',style: TextStyle(color: Theme.of(context).hintColor,fontWeight: FontWeight.w500,fontSize: 13),),
                  data['is_favorite'] == 1
                      ? Padding(
                    padding: const EdgeInsets.only(top: 10,right: 10,left: 10),
                    child: SvgPicture.asset(
                      'assets/icons/fill_star.svg',
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  )
                      : SizedBox(),
                ],
              ),
              Divider(endIndent: MediaQuery.of(context).size.width * .4,),

              Padding(
                padding: EdgeInsetsDirectional.only(start: 15),
                child: Text(
                    data['title'] ?? 'Title',
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline1
                ),
              ),
              SizedBox(height: 10,),
              ListView.builder(
                padding: EdgeInsetsDirectional.only(start: 15),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data['subTasks'].length,
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
                            onChanged: (value) => () {

                            },
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
            ],
          ),
        ),
      ),
    );
  }
}


class MemorySearchCard extends StatelessWidget {
  final data;

  const MemorySearchCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: InkWell(
        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => AddMemory(data: data,),)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Memory',style: TextStyle(color: Theme.of(context).hintColor,fontWeight: FontWeight.w500,fontSize: 13),),
                  data['is_favorite'] == 1
                      ? Padding(
                    padding: const EdgeInsets.only(top: 10,right: 10,left: 10),
                    child: SvgPicture.asset(
                      'assets/icons/fill_star.svg',
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  )
                      : SizedBox(),
                ],
              ),
              Divider(endIndent: MediaQuery.of(context).size.width * .4,),
              SizedBox(
                height: 5,
              ),
              // title
              data['title'].toString().isNotEmpty
                  ? Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 10,start: 15),
                child: Text(
                  data['title'],
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline1,
                ),
              )
                  : SizedBox(),

              // body
              data['body'].toString().isNotEmpty
                  ? Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 10,start: 15),
                child: Text(
                  data['body'],
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
