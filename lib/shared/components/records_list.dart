import 'package:flutter/material.dart';
import 'package:notes_app/shared/audio/player.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:notes_app/shared/localizations/localization/language/languages.dart';

class RecordsList extends StatelessWidget {

  final recordsList ;
  final deleteRecordFun;

  const RecordsList({required this.recordsList,required this.deleteRecordFun}) ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15,bottom: 25),
      child: Material(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(25),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          decoration: BoxDecoration(border: BorderDirectional(start: BorderSide(color: Theme.of(context).colorScheme.secondary,width: 10),),),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                childrenPadding: EdgeInsets.zero,
                tilePadding: EdgeInsets.zero,
                title: Text(
                  Languages.of(context)!.addNote['records'].toString(),
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline4!.color, fontSize: 18),
                ),
                leading: Icon(
                  Icons.graphic_eq,
                  color: Theme.of(context).textTheme.headline4!.color,
                  size: 18,
                ),
                maintainState: false,
                initiallyExpanded: true,
                iconColor: Theme.of(context).textTheme.headline4!.color,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: recordsList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                        child: CustomAudioPlayer(
                          index: index,
                          source: ap.AudioSource.uri(Uri.parse(recordsList[index]['link'].toString())) ,
                          onDelete:()=> deleteRecordFun(index,recordsList[index]['id'])
                        ),
                      )
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

