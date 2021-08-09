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
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                color: Color(0xff2e2e3e),
                elevation: 5,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                semanticContainer: true,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () => navFun(data[index]),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index]['title'] ?? 'Title',
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              // Container(
                              //   color: Colors.white24,
                              //   height: .5,
                              //   margin: EdgeInsets.symmetric(vertical: 10),
                              // ),
                              data[index]['images'].isEmpty ?  Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  data[index]['body'],
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ) : SizedBox(),
                              SizedBox(
                                height: 15,
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${data[index]['createdDate']}',
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${data[index]['createdTime']}',
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width:data[index]['images'].isNotEmpty ? 20 : 0,),
                        data[index]['images'].isNotEmpty
                            ? Container(
                          width: 55,height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(data[index]['images'][0]['link']
                                        .toString()),
                                  ),
                                )),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              );
            });
  }
}
