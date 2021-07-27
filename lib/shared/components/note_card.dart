import 'package:flutter/material.dart';
import 'package:notes_app/layout/note/add_note.dart';

class NoteCard extends StatelessWidget {
  final bodyMaxLines ;
  final Map body;
  final database;

  NoteCard({this.bodyMaxLines = 4 ,this.body=const{}, this.database});
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
      child: InkWell(
        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNote(id: body['id'].toInt(),data: body,database: database,)));},
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                body['title'] ?? 'Title' ,
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
              Text(
                '${body['body']}',
                style: TextStyle(fontSize: 17, color: Colors.white),
                maxLines: bodyMaxLines,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(
                    '${body['createdTime']}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '${body['createdDate']}',
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
      ),
    );
  }
}
