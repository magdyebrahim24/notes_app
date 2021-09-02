import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/note/bloc/add_note_cubit.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';
import 'package:notes_app/shared/components/bottom_icon_bar.dart';
import 'package:notes_app/shared/components/images_gridview.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';

class AddNote extends StatelessWidget {
  final data;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AddNote({this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AddNoteCubit()..onBuildAddNoteScreen(data),
      child: BlocConsumer<AddNoteCubit, AddNoteState>(
        listener: (context, AddNoteState state) {},
        builder: (context, state) {
          // AppCubit appCubit = AppCubit.get(context);
          AddNoteCubit cubit = AddNoteCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              actions: [

                ElevatedButton(
                  onPressed: ()=> cubit.newRecord(context),
                  //color: Colors.white,
                  //disabledColor: Colors.grey,
                  child: Text(cubit.mRecorder!.isRecording ? 'Stop' : 'Record'),
                ),

                cubit.titleController.text.isNotEmpty ||
                        cubit.noteTextController.text.isNotEmpty ||
                        cubit.pickedGalleryImagesList.isNotEmpty
                    ? IconButton(
                        onPressed: ()=> cubit.onSave(context),
                        icon: Icon(Icons.done))
                    : SizedBox(),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  DefaultFormField(
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline4!.color,
                      fontSize: 28,
                    ),
                    controller: cubit.titleController,
                    focusNode: cubit.titleFocus,
                    onTap: () => cubit.onFocusTitleChange(),
                    onChanged: (val)=> cubit.onTextChange(),
                    maxLines: 2,
                    minLines: 1,
                    fillColor: Theme.of(context).primaryColor,
                    hintText: 'title',
                    hintStyle: TextStyle(
                        color: Theme.of(context).hintColor,
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
                      onTap: () => cubit.onFocusBodyChange(),
                      onChanged:(val)=> cubit.onTextChange(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline4!.color,
                        fontSize: 20,
                      ),
                      maxLines: null,
                      minLines: null,
                      keyboardType: TextInputType.multiline,
                      hintText: 'typing your note ...',
                      fillColor: Theme.of(context).primaryColor,
                      hintStyle: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 20),
                    ),
                  ),
                  GridViewForImages(
                    cubit.cachedImagesList,
                    deleteFun: (id, index) {
                      cubit.deleteSavedImage(imageID: id, index: index);
                    },
                    expansionTileHeader: 'Saved Images',
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cubit.recordsList.length,
                      itemBuilder:(context,index)=> Row(
                        children: [
                          ElevatedButton(
                            onPressed:()=> cubit.getPlaybackFn(cubit.recordsList[index]['link'],index),
                            // color: Colors.white,
                            //disabledColor: Colors.grey,
                            child: Text(cubit.mPlayer!.isPlaying&&index==cubit.item ? 'Stop' : 'Play'),
                          ),
                          IconButton(onPressed: ()=>cubit.deleteSavedRecord(recordID: cubit.recordsList[index]['id'], index: index), icon: Icon(Icons.clear_rounded))
                        ],
                      ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: cubit.noteId != null
                ? BottomIconBar(
                    isFavorite: cubit.isFavorite,
                    deleteFun: () => cubit.deleteNote(context),
                    addImageFun: ()=> cubit.pickMultiImageFromGallery(context),
                    addToFavoriteFun: cubit.favFun,
                    addToSecretFun: () => cubit.addNoteToSecret(context),
                  )
                : SizedBox(),
            floatingActionButton: cubit.noteId == null
                ? FloatingActionButton(
                    onPressed: () => cubit.pickMultiImageFromGallery(context),
                    child: Icon(Icons.add_photo_alternate_outlined),
                  )
                : SizedBox(),
          );
        },
      ),
    );
  }
}
