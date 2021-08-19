import 'dart:io';

import 'package:flutter/material.dart';

class NotePreview extends StatelessWidget {
  final data;
  final navFun;
  final isLoading;

  NotePreview(
      {Key? key, required this.data, this.navFun, this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: data.length,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) {
              return NoteCard(
                  data: data[index], onTapFun: () => navFun(data[index]));
            });
  }
}

class NoteCard extends StatelessWidget {
  final onTapFun;
  final data;
  final isFavorite;

  const NoteCard({ this.onTapFun, this.data,this.isFavorite=false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
      elevation: 8,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onTapFun,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 11),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'] ?? 'Title',
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 22),
                    ),
                    data['images'].isEmpty && data['body'].toString().isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              data['body'],
                              style:
                                 Theme.of(context).textTheme.bodyText2,
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 12,
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${data['createdDate']}',
                              maxLines: 1,
                              style:Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Expanded(
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
              SizedBox(
                width: data['images'].isNotEmpty ? 20 : 0,
              ),
              data['images'].isNotEmpty
                  ? Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                              File(data['images'][0]['link'].toString()),
                            ),
                          )),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
