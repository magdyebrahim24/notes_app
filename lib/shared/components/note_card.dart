import 'package:flutter/material.dart';
import 'package:notes_app/layout/search_screen/search_screen.dart';
import 'package:notes_app/shared/constants.dart';

class NoteCard extends StatelessWidget {
 final SearchScreen mohamed=new SearchScreen();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        // height: 300.0,
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.4),
          //     spreadRadius: 2,
          //     blurRadius: 4,
          //     offset: Offset(.5, 2), // changes position of shadow
          //   ),
          // ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff3c3b4e),
              Color(0xff2e2e3e),
            ],
          ),
          // borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.all(15),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${mohamed.x[0]['title']}',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Container(
              color: Colors.white24,
              height: 1,
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            Expanded(
              child: Text(
                "He'd have you all unravel at the ;alsdkfja;lsd falsdkfja;lsdkfj sda;lkfja;lskdfj asdf lasdkfjal;skdfj ;asldkfja ;sdlkfja l;sdkfja;l sdkfj sdlfkjasd;lfkjas;ldf j;lsdkfj ;alsdkfj ; ",
                style: TextStyle(fontSize: 17, color: Colors.white),
                maxLines: 4,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Text(
                  'jon 17',
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Text(
                  'Note',
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
