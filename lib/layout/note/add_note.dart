
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/note/bloc/add_note_cubit.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';
import 'package:notes_app/shared/bloc/cubit/cubit.dart';
import 'package:notes_app/shared/components/bottom_navigation_bar.dart';
import 'package:notes_app/shared/components/image_list.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
import 'package:notes_app/shared/constants.dart';

class AddNote extends StatelessWidget {
  final database;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AddNote({this.database});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AddNoteCubit(),
      child: BlocConsumer<AddNoteCubit, AddNoteState>(
        listener: (context, AddNoteState state) {},
        builder: (context, state) {
          AddNoteCubit cubit = AddNoteCubit.get(context);
          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                actions: [
                  cubit.bodyFocus.hasFocus
                      ? IconButton(
                          tooltip: 'Undo',
                          icon: Icon(
                            Icons.undo,
                          ),
                          onPressed: cubit.stackController!.state == '' &&
                                  !(cubit.stackController!.canUndo)
                              ? null
                              : cubit.undoFun,
                        )
                      : SizedBox(),
                  cubit.bodyFocus.hasFocus
                      ? IconButton(
                          tooltip: 'Redo',
                          icon: Icon(Icons.redo),
                          onPressed: !cubit.stackController!.canRedo
                              ? null
                              : cubit.redoFun,
                        )
                      : SizedBox(),
                  cubit.titleController.text.isNotEmpty || cubit.noteTextController.text.isNotEmpty || cubit.selectedGalleryImagesList.isNotEmpty ? IconButton(onPressed: (){
                    if(cubit.noteId == null){
                      cubit.insertNewNote(
                        database,
                          title: cubit.titleController.text,
                          body: cubit.noteTextController.text,
                      );
                    }else{
                      cubit.updateNote(database,id: cubit.noteId!,body: cubit.noteTextController.text,title: cubit.titleController.text);
                    }
                    }, icon: Icon(Icons.done)) :SizedBox(),


                ],

              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    DefaultFormField(
                      controller: cubit.titleController,
                      focusNode: cubit.titleFocus,
                      onTap: () {
                        cubit.onFocusTitleChange();
                      },
                      onChanged: (value){cubit.onTitleChange();},
                      maxLines: null,
                      minLines: null,
                      fillColor: Theme.of(context).primaryColor,
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          color: greyColor,
                          fontSize: 28,
                          fontWeight: FontWeight.normal),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white24),
                    ),
                    Center(
                      child: DefaultFormField(
                        focusNode: cubit.bodyFocus,
                        controller: cubit.noteTextController,
                        onTap: () {
                          cubit.onFocusBodyChange();
                        },
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        onChanged: (value) {
                          cubit.onNoteTextChanged(value);
                        },
                        maxLines: null,
                        minLines: null,
                        keyboardType: TextInputType.multiline,
                        hintText: 'Start typing your note ...',
                        fillColor: Theme.of(context).primaryColor,
                        hintStyle: TextStyle(color: greyColor, fontSize: 20),
                      ),
                    ),
                    SizedBox(),
                    // Image.file(File('/data/user/0/com.example.notes_app/app_flutter/notes_images/image_picker7464063783057228289.jpg'),height: 50,width: 100,cacheHeight: 100,cacheWidth: 100,),
                    ImageList(imageList: cubit.selectedGalleryImagesList),
                    ImageList(imageList: cubit.cachedImagesList),

                  ],
                ),
              ),
              bottomNavigationBar: MyBottomNavigationBar(
                onPressedForAddImage: () => cubit.pickImageFromGallery(ImageSource.gallery),
                  onPressedForDeleteNote: (){cubit.deleteNote(database , context , id: cubit.noteId!);},
              )
          );
        },
      ),
    );
  }
}

// BottomAppBar(color: Colors.transparent,
// elevation: 0,
// child: Padding(
// padding: const EdgeInsets.all(10.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// MaterialButton(
// minWidth: MediaQuery.of(context).size.width * .4,
// onPressed: () => cubit.pickImage(ImageSource.gallery),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10)),
// color: Colors.grey.withOpacity(.3),
// padding: EdgeInsets.symmetric(
// horizontal: 25,
// vertical: 10
// ),
// child: Text('Add Image',style: TextStyle(color: Colors.white,fontSize: 16)),
// ),
// MaterialButton(
// minWidth: MediaQuery.of(context).size.width * .4,
// padding: EdgeInsets.symmetric(
// horizontal: 25,
// vertical: 10
// ),
// onPressed: () {},
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10)),
// color: Colors.redAccent.withOpacity(.1),
// child: Text('Delete Note',style: TextStyle(color: Colors.red,fontSize: 16),),
// )
// ],
// ),
// ),
// )
