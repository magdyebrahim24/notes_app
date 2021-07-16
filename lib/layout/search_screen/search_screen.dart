import 'package:flutter/material.dart';
import 'package:notes_app/shared/components/note_card.dart';
import 'package:notes_app/shared/components/txt_field.dart';
import 'package:notes_app/shared/constants.dart';

class SearchScreen extends StatelessWidget {

  final searchController = TextEditingController();

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
                    borderRadius: BorderRadius.circular(20)
                  ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),

                    ),
                    fillColor: Colors.redAccent,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color(0xff707070).withOpacity(.15)),
                      borderRadius: BorderRadius.circular(10),
                    ),

                  hintStyle: TextStyle(color: greyColor,),
                  hintText: 'Search...',
                  suffixStyle: TextStyle(color: greyColor),
                  suffixIcon:Icon(Icons.search_rounded,)
                ),
                readOnly: false,

              ),
            TxtField(
              hintText:'Search ...',
              inputTextFunction: (value) {
              },
              textInputType: TextInputType.emailAddress,
              validatorFun: (value) {
                if (value.toString().isEmpty) {
                  return 'Email Required';
                }
              },
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
