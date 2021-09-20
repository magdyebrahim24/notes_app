import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';

class NotePreview extends StatelessWidget {
  final data;
  final navFun;
  final isLoading;
  final onLongPress;
  NotePreview(
      {required this.data,
      this.navFun,
      this.isLoading = false,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return circleProcessInductor();
    } else {
      if (data.length != 0) {
        return ListView.builder(
            itemCount: data.length,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) {
              return NoteCard(
                  onLongTapFun: () => onLongPress(data[index], index),
                  data: data[index],
                  onTapFun: () => navFun(data[index]));
            });
      } else {
        return shadedImage('assets/intro/notes.png');
      }
    }
  }
}

class NoteCard extends StatelessWidget {
  final onTapFun;
  final onLongTapFun;
  final data;
  final isFavorite;

  const NoteCard(
      {this.onTapFun, this.data, this.isFavorite = false, this.onLongTapFun});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: InkWell(
        onTap: onTapFun,
        onLongPress: onLongTapFun,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    // title
                    data['title'].toString().isNotEmpty ?  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        data['title'],
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline1,
                      ),
                    ) : SizedBox(),

                    // show 2 images if body not exist but image exist
                    data['body'].toString().isEmpty && data['images'].isNotEmpty? Row( children: [
                      image(data['images'][0]['link']),
                      data['body'].toString().isEmpty && data['images'].length > 2
                          ?  image(data['images'][1]['link']) : SizedBox(),
                    ],):SizedBox(),

                    // body
                    data['body'].toString().isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              data['body'],
                              style: Theme.of(context).textTheme.caption,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : SizedBox(),

                   data['voices'].isNotEmpty ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SvgPicture.asset('assets/icons/voice.svg'),
                    ): SizedBox(),

                    Text(
                      '${data['createdDate']}',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 9.5),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  data['is_favorite'] == 1 ?  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SvgPicture.asset('assets/icons/fill_star.svg',color: Theme.of(context).textTheme.headline1!.color,),
                  ):SizedBox(),

                  SizedBox(
                    height: 15
                  ),
                  data['images'].isNotEmpty && data['body'].toString().isNotEmpty
                      ?  image(data['images'][0]['link']) : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget image(imgPath){
    return Container(
      width: 65,
      height: 54,
      margin: EdgeInsets.only(bottom: 10,left: 5,right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(
              File(imgPath.toString()),
            ),
          )),
    );
  }
}
