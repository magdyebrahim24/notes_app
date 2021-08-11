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
              // return Card(
              //   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
              //   color: Color(0xff2e2e3e),
              //   elevation: 5,
              //   clipBehavior: Clip.antiAliasWithSaveLayer,
              //   semanticContainer: true,
              //   shadowColor: Colors.grey,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10.0),
              //   ),
              //   child: InkWell(
              //     onTap: () => navFun(data[index]),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 15 ,vertical: 11),
              //       child: Row(
              //         children: [
              //           Expanded(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                   data[index]['title'] ?? 'Title',
              //                   maxLines: 1,
              //                   softWrap: true,
              //                   overflow: TextOverflow.ellipsis,
              //                   style: TextStyle(
              //                       fontSize: 22,
              //                       fontWeight: FontWeight.bold,
              //                       color: Colors.white),
              //                 ),
              //                 data[index]['images'].isEmpty && data[index]['body'].toString().isNotEmpty ?  Padding(
              //                   padding: const EdgeInsets.only(top: 10),
              //                   child: Text(
              //                     data[index]['body'],
              //                     style: TextStyle(
              //                         fontSize: 17, color: Colors.white),
              //                     maxLines: 1,
              //                     softWrap: true,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 ) : SizedBox(),
              //                 SizedBox(
              //                   height: 12,
              //                 ),
              //                 Directionality(
              //                   textDirection: TextDirection.ltr,
              //                   child: Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     children: [
              //                       Expanded(
              //                         child: Text(
              //                           '${data[index]['createdDate']}',
              //                           maxLines: 1,
              //                           style: TextStyle(
              //                               color: Colors.white, fontSize: 13),
              //                         ),
              //                       ),
              //                       SizedBox(
              //                         width: 7,
              //                       ),
              //                       Expanded(
              //                         child: Align(
              //                           alignment: Alignment.centerRight,
              //                           child: Text(
              //                             '${data[index]['createdTime']}',
              //                             maxLines: 1,
              //                             softWrap: true,
              //                             overflow: TextOverflow.clip,
              //                             style: TextStyle(
              //                                 color: Colors.white,
              //                                 fontSize: 13),
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ),
              //           SizedBox(width:data[index]['images'].isNotEmpty ? 20 : 0,),
              //           data[index]['images'].isNotEmpty
              //               ? Container(
              //             width: 55,height: 55,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(10),
              //                       image: DecorationImage(
              //                     fit: BoxFit.cover,
              //                     image: FileImage(
              //                       File(data[index]['images'][0]['link']
              //                           .toString()),
              //                     ),
              //                   )),
              //                 )
              //               : SizedBox(),
              //         ],
              //       ),
              //     ),
              //   ),
              // );
            });
  }
}

class NoteCard extends StatelessWidget {
  final onTapFun;
  final data;

  const NoteCard({Key? key, this.onTapFun, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
      color: Color(0xff2e2e3e),
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      shadowColor: Colors.grey,
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
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    data['images'].isEmpty && data['body'].toString().isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              data['body'],
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${data['createdTime']}',
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
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
