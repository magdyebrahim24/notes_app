import 'package:flutter/material.dart';
import 'package:notes_app/shared/components/note_card.dart';
import 'package:notes_app/shared/constants.dart';

class SearchScreen extends StatelessWidget {
  final searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()=> Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios,size: 20,),
        ),
        bottom: PreferredSize(
          preferredSize: Size(60,60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                focusColor: greyColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white60)),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.white60,
                  ),
                ),
                fillColor: Colors.grey.withOpacity(.1),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(width: 1, color: Colors.grey.withOpacity(.4)),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: TextStyle(
                  color: greyColor,
                ),
                hintText: 'Search ...',
                suffixStyle: TextStyle(color: greyColor),
                suffixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.white60,
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
              cursorColor: Colors.white,
              textInputAction: TextInputAction.search,
              onEditingComplete: (){
                print('search done');
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: 10,
          padding: EdgeInsets.only(top: 10,right: 10,left: 10),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: NoteCard(bodyMaxLines: 1,),
          )),
    );
  }
}
