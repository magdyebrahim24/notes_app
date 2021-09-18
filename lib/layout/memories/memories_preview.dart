import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';

class MemoriesPreview extends StatelessWidget {
  final isLoading;
  final onTapFun;
  final List data;

  MemoriesPreview({required this.data, this.onTapFun, this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return circleProcessInductor();
    } else {
      if (data.length != 0) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          // physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
          itemBuilder: (context, index) {
            return MemoryCard(
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

  MemoryCard({this.noTapFun, this.data, this.isFavorite = false, this.index});

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
          child: Padding(
            padding:  EdgeInsetsDirectional.only(start: 20, top: index != 0 ? 12 : 61),
            child: InkWell(
              onTap: noTapFun,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(32),
                        bottomStart: Radius.circular(32),
                        bottomEnd: Radius.circular(32)),
                    color: Theme.of(context).cardTheme.color),
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
    // return Card(
    //   margin: EdgeInsets.all(5),
    //   elevation: 8,
    //   clipBehavior: Clip.antiAliasWithSaveLayer,
    //   semanticContainer: true,
    //   // shadowColor: Colors.grey,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(15.0),
    //   ),
    //   child: InkWell(
    //     onTap: noTapFun,
    //     child: Column(
    //       children: [
    //         data['images'].isNotEmpty
    //             ? Image.file(
    //           File(data['images'][0]['link'].toString()),
    //           fit: BoxFit.fitWidth,
    //           isAntiAlias: true,
    //           excludeFromSemantics: true,
    //           gaplessPlayback: true,
    //         )
    //             : SizedBox(),
    //         Padding(
    //           padding:
    //           EdgeInsets.symmetric(vertical: 20, horizontal: 12),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               data['title'].toString().isNotEmpty
    //                   ? Text(
    //                 data['title'] ?? 'Title',
    //                 maxLines: 2,
    //                 softWrap: true,
    //                 overflow: TextOverflow.ellipsis,
    //                 style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 22),
    //               )
    //                   : SizedBox(),
    //               data['title'].toString().isNotEmpty
    //                   ? Container(
    //                 color: Colors.white24,
    //                 height: .5,
    //                 margin: EdgeInsets.symmetric(vertical: 10),
    //               )
    //                   : SizedBox(),
    //               data['body'].toString().isNotEmpty
    //                   ? Padding(
    //                 padding: const EdgeInsets.only(bottom: 17),
    //                 child: Text(
    //                   '${data['body']}',
    //                   style:
    //                   Theme.of(context).textTheme.bodyText2,
    //                   maxLines: 10,
    //                   softWrap: true,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //               )
    //                   : SizedBox(),
    //               Directionality(
    //                 textDirection: TextDirection.ltr,
    //                 child: Row(
    //                   mainAxisAlignment:
    //                   MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Expanded(
    //                       child: Text(
    //                         '${data['createdDate']}',
    //                         maxLines: 1,
    //                         style: Theme.of(context).textTheme.subtitle1,
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       width: 7,
    //                     ),
    //                     Expanded(
    //                       child: Align(
    //                         alignment: Alignment.centerRight,
    //                         child: Text(
    //                           '${data[isFavorite ?'type':'createdTime']}',
    //                           maxLines: 1,
    //                           softWrap: true,
    //                           overflow: TextOverflow.clip,
    //                           style: Theme.of(context).textTheme.subtitle1,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
