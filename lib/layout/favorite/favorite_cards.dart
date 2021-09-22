import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/layout/note/note_preview.dart';

class FavoriteNoteCard extends StatelessWidget {
  final data, onTapFun, onLongTapFun;

  FavoriteNoteCard({this.data, this.onTapFun, this.onLongTapFun});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              // title
              // data['is_favorite'] == 1 ?  Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: SvgPicture.asset('assets/icons/fill_star.svg',color: Theme.of(context).textTheme.headline1!.color,),
              // ):SizedBox(),
              data['title'].toString().isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        data['title'],
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    )
                  : SizedBox(),

              // show 2 images if body not exist but image exist
              data['body'].toString().isEmpty && data['images'].isNotEmpty
                  ? Row(
                      children: [
                        image(data['images'][0]['link']),
                        data['body'].toString().isEmpty &&
                                data['images'].length > 2
                            ? image(data['images'][1]['link'])
                            : SizedBox(),
                      ],
                    )
                  : SizedBox(),

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

              Row(
                children: [
                  data['voices'].isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SvgPicture.asset('assets/icons/voice.svg'),
                        )
                      : SizedBox(),
                  data['images'].isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 15, right: 15),
                          child: Icon(
                            Icons.image_outlined,
                            color: Color(0xff7D7D7D),
                          ),
                        )
                      : SizedBox(),
                ],
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Notes',
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteMemoryCard extends StatelessWidget {
  final noTapFun;
  final data;

  FavoriteMemoryCard({this.noTapFun, this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: noTapFun,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(14),
            color: Theme.of(context).cardTheme.color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['title'].toString(),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(fontSize: 17),
            ),
            SizedBox(
              height: 5,
            ),
            data['body'].toString().isNotEmpty
                ? Text(
                    data['body'].toString(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.caption,
                  )
                : SizedBox(),
            Row(
              children: [
                data['images'].isNotEmpty
                    ? Container(
                        constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 30,
                            maxWidth: 65,
                            maxHeight: 60),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 50,
                        width: 65,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: FileImage(
                                    File(data['images'][0]['link'].toString())),
                                fit: BoxFit.cover)),
                      )
                    : SizedBox(
                        height: 15,
                      ),
                data['images'].isNotEmpty && data['images'].length > 2
                    ? Container(
                        constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 30,
                            maxWidth: 65,
                            maxHeight: 60),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        height: 50,
                        width: 65,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: FileImage(
                                    File(data['images'][1]['link'].toString())),
                                fit: BoxFit.cover)),
                      )
                    : SizedBox(
                        height: 15,
                      ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Memory',
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
