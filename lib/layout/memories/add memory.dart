import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/memories/bloc/cubit.dart';
import 'package:notes_app/layout/memories/bloc/states.dart';
import 'package:notes_app/shared/components/bottom_navigation_bar.dart';
import 'package:notes_app/shared/components/image_list.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
import 'package:notes_app/shared/constants.dart';

class AddMemory extends StatelessWidget {
  final database;

  AddMemory({this.database});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=>AddMemoryCubit(),
        child: BlocConsumer<AddMemoryCubit,AppMemoryStates>(
    listener: (context,state){},
        builder: (context,state){
          AddMemoryCubit cubit = AddMemoryCubit.get(context);
      return Scaffold(
          appBar: AppBar(

            actions: [
              // cubit.bodyFocus.hasFocus ?    IconButton(
              //   tooltip: 'Undo',
              //   icon: Icon(Icons.undo,),
              //   onPressed: cubit.stackController!.state == '' &&
              //       !(cubit.stackController!.canUndo)
              //       ? null
              //       : cubit.undoFun,
              // ) : SizedBox(),
              // cubit.bodyFocus.hasFocus ?  IconButton(
              //   tooltip: 'Redo',
              //   icon: Icon(Icons.redo),
              //   onPressed:
              //   !cubit.stackController!.canRedo ? null : cubit.redoFun,
              // ) : SizedBox(),
              IconButton(
                  onPressed: () {
                    if (cubit.memoryID == null) {
                      cubit.insertNewMemory(
                        database,
                        memoryDate: cubit.dateController!,
                        title: cubit.titleController.text,
                        body: cubit.memoryTextController.text,
                      );
                    }
                    // else {
                    //   cubit.updateNote(database,
                    //       id: cubit.noteId!,
                    //       body: cubit.memoryTextController.text,
                    //       title: cubit.titleController.text);
                    // }
                  },
                  icon: Icon(Icons.done))
            ],
          ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultFormField(
                  controller: cubit.titleController,
                  focusNode: cubit.titleFocus,
                  onTap:  (){cubit.onFocusTitleChange();},
                  maxLines: null,
                  minLines: null,
                  fillColor: Theme.of(context).primaryColor,
                  hintText: 'Title',
                  hintStyle: TextStyle(
                      color: greyColor,
                      fontSize: 28,
                      fontWeight: FontWeight.normal),
                ),
                // TextFormField(
                //   controller: _titleController,
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 28,
                //       fontWeight: FontWeight.w800
                //   ),
                //   maxLines: null,
                //   minLines: null,
                //   decoration: InputDecoration(
                //     hintText: 'Title',
                //     disabledBorder: InputBorder.none,
                //     hintStyle: TextStyle(color: greyColor, fontSize: 28,fontWeight: FontWeight.normal),
                //     fillColor: Theme.of(context).primaryColor,
                //     border: InputBorder.none,
                //   ),),
                Container(
                  margin: EdgeInsets.only(bottom: 10,),
                  height: 2,width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white24
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  width: double.infinity,

                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Text('Memory Date',style: TextStyle(fontSize: 18,color: Colors.white),),
                      Spacer(),
                      MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        color: Colors.white24,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onPressed: (){
                        cubit.datePicker(context);},
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(cubit.dateController ?? 'Add',style: TextStyle(fontSize: 16,color: Colors.white),),
                            ),
                            Icon(Icons.expand_more,color: Colors.white,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                DefaultFormField(
                  focusNode: cubit.bodyFocus,
                  controller: cubit.memoryTextController,
                  onTap: (){cubit.onFocusBodyChange();},
                  style: TextStyle(color: Colors.white, fontSize: 20,),
                  onChanged: (value) {cubit.onNoteTextChanged(value);},
                  maxLines: null,
                  minLines: null,
                  keyboardType: TextInputType.multiline,
                  hintText: 'Start typing your Memory ...',
                  fillColor: Theme.of(context).primaryColor,
                  hintStyle: TextStyle(color: greyColor, fontSize: 20),

                ),
                SizedBox(height: 15,),
                ImageList(imageList: cubit.addedImages),
              ],
            ),
          ),
        ),
          bottomNavigationBar: MyBottomNavigationBar(
            onPressedForAddImage: () => cubit.pickImage(ImageSource.gallery),
            onPressedForDeleteNote: (){}
          )
      );
        },),

    );
  }
}
