import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';

class MemoriesPreview extends StatelessWidget {
  final isLoading;
  final onTapFun;
  final List data;
  final onLongPress;
  final selectedItemIndex;

  MemoriesPreview({required this.data, this.onTapFun, this.isLoading, this.onLongPress, this.selectedItemIndex});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return circleProcessInductor();
    } else {
      if (data.length != 0) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
          itemBuilder: (context, index) {
            return MemoryCard(
              color: index != selectedItemIndex ? Theme.of(context).cardTheme.color!.withOpacity(.85) : Theme.of(context).hintColor.withOpacity(.4),
              onLongPress: ()=>onLongPress(data[index],index),
                noTapFun: () => onTapFun(data[index]), data: data[index],index: index,);
          },
        );
      } else {
        return shadedImage('assets/intro/memories.png');
      }
    }
  }
}

class MemoryCard extends StatelessWidget {
  final noTapFun;
  final data;
  final isFavorite;
  final index ;
  final onLongPress;
  final color;

  MemoryCard({this.noTapFun, this.data, this.isFavorite = false, this.index, this.onLongPress, this.color});

  @override
  Widget build(BuildContext context) {
    var memoryDate = DateFormat.yMMMd().parse(data['memoryDate']);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsetsDirectional.only(top: index != 0 ? 5 : 55, end: 10),
          child: Text(
            '${memoryDate.day.toString()}/${memoryDate.month.toString()}'
                .toString(),
            style: TextStyle(
                color: Color(0xff666666),
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          index == 0 ?  Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 2.0,
                height: 50,
                color: Theme.of(context).textTheme.subtitle1!.color,
                constraints: BoxConstraints(maxHeight: 200, minHeight: 50)) : SizedBox(),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      color: Theme.of(context).dividerColor, width: 1)),
              alignment: Alignment.center,
              child: Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xff666666),
                    border: Border.all(color:Theme.of(context).scaffoldBackgroundColor, width: 2)),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 2.0,
                height: 150,
                color: Theme.of(context).textTheme.subtitle1!.color,
                constraints: BoxConstraints(maxHeight: 200, minHeight: 50)),
          ],
        ),
        Expanded(
          child: Card(
            margin: EdgeInsetsDirectional.only(start: 20, top: index != 0 ? 12 : 61),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,borderOnForeground: false,elevation: 0,
            color: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(32),
                bottomStart: Radius.circular(32),
                bottomEnd: Radius.circular(32)),),
            child: InkWell(
              onTap: noTapFun,
              onLongPress: onLongPress,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['title'].toString(),
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 17),
                          ),
                        ),
                        data['is_favorite'] == 1 ?  Padding(
                          padding: const EdgeInsets.all(6),
                          child: SvgPicture.asset('assets/icons/fill_star.svg',color: Theme.of(context).textTheme.headline1!.color,),
                        ):SizedBox(),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        data['body'].toString().isNotEmpty
                            ? Expanded(
                                child: Text(
                                data['body'].toString(),
                                maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                style: Theme.of(context).textTheme.caption,
                              ))
                            : SizedBox(),
                        data['images'].isNotEmpty
                            ? Container(
                          margin: EdgeInsetsDirectional.only(start: 7),
                          height: 50,width: 60,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)
                              ,image: DecorationImage(image: FileImage(File(data['images'][0]['link'].toString())),
                                  fit: BoxFit.cover
                              )
                          ),
                        ): SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
