import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes_app/shared/components/gridvoew.dart';
import 'package:notes_app/shared/components/note_card.dart';
import 'package:notes_app/shared/constants.dart';

class SearchScreen extends StatelessWidget {
  final List x=[{'title':'Play Football'},{'body':'I Play Football in the playground'},{'time':'jon 17'},{'type':'Note'}];
  final searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
              TextFormField(

                controller: searchController,
                decoration: InputDecoration(
                  focusColor: greyColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50)
                  ),
                  hintStyle: TextStyle(color: greyColor,),
                  hintText: 'Search...',
                  suffixStyle: TextStyle(color: greyColor),
                  suffix: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 25,
                    height: 25,
                    color: greyColor,

                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  itemCount: 10,
                    itemBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NoteCard(),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
