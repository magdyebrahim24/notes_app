import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff3c3b4e),
              Color(0xff2e2e3e),
            ],
          ),
        ),
        padding: EdgeInsets.all(15),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tittle',
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
