import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/note/bloc/add_note_cubit.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';
import 'package:notes_app/shared/components/bottom_navigation_bar.dart';
import 'package:notes_app/shared/components/image_list.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
import 'package:notes_app/shared/constants.dart';

class AddNote extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddNoteCubit()..clearStack(),
      child: BlocConsumer<AddNoteCubit, AddNoteState>(
        listener: (context, AddNoteState state) {},
        builder: (context, state) {
          AddNoteCubit cubit = AddNoteCubit.get(context);
          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                actions: [
                  IconButton(onPressed: (){cubit.saveImagesToPhone();}, icon: Icon(Icons.done)),
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
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DefaultFormField(
                        controller: _titleController,
                        focusNode: cubit.titleFocus,
                        onTap: () {
                          cubit.onFocusTitleChange();
                        },
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
                      //   focusNode: cubit.titleFocus,
                      //   onTap: (){
                      //     cubit.onFocusTitleChange();
                      //
                      //   },
                      //   controller: _titleController,
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 28,
                      //       fontWeight: FontWeight.w800),
                      //   maxLines: null,
                      //   minLines: null,
                      //   decoration: InputDecoration(
                      //     hintText: 'Title',
                      //     disabledBorder: InputBorder.none,
                      //     hintStyle: TextStyle(
                      //         color: greyColor,
                      //         fontSize: 28,
                      //         fontWeight: FontWeight.normal),
                      //     fillColor: Theme.of(context).primaryColor,
                      //     border: InputBorder.none,
                      //   ),
                      // ),
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
                      DefaultFormField(
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
                      // TextFormField(
                      //   focusNode: cubit.bodyFocus,
                      //   onTap: (){
                      //     cubit.onFocusBodyChange();
                      //
                      //   },
                      //   // expands: true,
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 20,
                      //   ),
                      //   onChanged: (value) {
                      //     cubit.onNoteTextChanged(value);
                      //   },
                      //   maxLines: null,
                      //   minLines: null,
                      //   keyboardType: TextInputType.multiline,
                      //   decoration: InputDecoration(
                      //     hintText: 'Start typing your note ...',
                      //     disabledBorder: InputBorder.none,
                      //     hintStyle: TextStyle(color: greyColor, fontSize: 20),
                      //     fillColor: Theme.of(context).primaryColor,
                      //     border: InputBorder.none,
                      //   ),
                      // ),
                      SizedBox(),
                      ImageList(imageList: cubit.selectedGalleryImagesList),
                      // ListView.builder(
                      //     physics: NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     itemCount: cubit.addedImages.length,
                      //     itemBuilder: (ctx, index) {
                      //       return InkWell(
                      //         onTap:()=> Navigator.push(context, MaterialPageRoute(fullscreenDialog: true,builder: (context) => FullImage(fullImagePath: cubit.addedImages[index],),)),
                      //         child: Container(
                      //           margin: EdgeInsets.symmetric(vertical: 7),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(8),
                      //             border: Border.all(color: Colors.grey),
                      //           ),
                      //           padding: EdgeInsets.symmetric(
                      //               vertical: 4, horizontal: 10),
                      //           child: Row(
                      //             children: [
                      //               // SizedBox(width: 5,),
                      //               Icon(
                      //                 Icons.image_rounded,
                      //                 color: Colors.grey,
                      //                 size: 30,
                      //               ),
                      //               SizedBox(
                      //                 width: 5,
                      //               ),
                      //               Expanded(
                      //                   child: Text(
                      //                 '${cubit.addedImages[index].split('/').last}',
                      //                 maxLines: 1,
                      //                 style: TextStyle(
                      //                     color: Colors.grey, fontSize: 17),
                      //               )),
                      //               IconButton(
                      //                   onPressed: () {},
                      //                   icon: Icon(
                      //                     Icons.delete_outline_rounded,
                      //                     color: Colors.grey,
                      //                   ))
                      //               // Image.file(File(cubit.image!.path),width: 50,height: 50 ,fit: BoxFit.cover ,),
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     }),
                      // ListView.builder(
                      //     physics: NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     itemCount: cubit.addedImages.length,
                      //     itemBuilder: (ctx, index) {
                      //       return Column(
                      //         children: [
                      //           Image.file(File(cubit.addedImages[index])),
                      //           Container(
                      //             height: 200,
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(10),
                      //                 image: DecorationImage(fit: BoxFit.scaleDown,
                      //                     image: FileImage(File(cubit.addedImages[index]))
                      //                 )
                      //             ),
                      //           )
                      //         ],
                      //       );
                      //     }),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: MyBottomNavigationBar(
                onPressed: () => cubit.pickImage(ImageSource.gallery),
              ));
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
