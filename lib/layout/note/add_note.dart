import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
        listener: (context, AddNoteState state) {
        },
        builder: (context, state) {
          // AppCubit appCubit = AppCubit.get(context);
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
                cubit.titleController.text.isNotEmpty ||
                        cubit.noteTextController.text.isNotEmpty ||
                        cubit.selectedGalleryImagesList.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          if (cubit.noteId == null) {
                            cubit.insertNewNote(
                              context,
                              title: cubit.titleController.text,
                              body: cubit.noteTextController.text,
                            );
                          } else {
                            cubit.updateNote(context,
                                id: cubit.noteId!,
                                body: cubit.noteTextController.text,
                                title: cubit.titleController.text);
                          }
                        },
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
                    onTap: () {
                      cubit.onFocusTitleChange();
                    },
                    onChanged: (value) {
                      cubit.onTitleChange();
                    },
                    maxLines: null,
                    minLines: null,
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
                      onTap: () {
                        cubit.onFocusBodyChange();
                      },
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline4!.color,
                        fontSize: 20,
                      ),
                      onChanged: (value) {
                        cubit.onNoteTextChanged(value);
                      },
                      maxLines: null,
                      minLines: null,
                      keyboardType: TextInputType.multiline,
                      hintText: 'typing your note ...',
                      fillColor: Theme.of(context).primaryColor,
                      hintStyle: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 20),
                    ),
                  ),
                  SizedBox(),
                  GridViewForImages(cubit.selectedGalleryImagesList,
                  deleteFun: (id,index){
                    cubit.deleteUnSavedImage(index: index);
                  },
                    expansionTileHeader: 'Un Saved Images',

                  ),
                  GridViewForImages(
                      cubit.cachedImagesList, deleteFun:(id,index){
                    cubit.deleteSavedImage(imageID: id, index: index);
                  },                      expansionTileHeader: 'Saved Images',
                  ),
                ], ),
            ),
            bottomNavigationBar: cubit.noteId != null
                ? BottomIconBar(
                    isFavorite: cubit.isFavorite,
                    deleteFun: () =>
                        cubit.deleteNote(context, id: cubit.noteId!),
                    addImageFun: () =>
                        cubit.pickImageFromGallery(ImageSource.gallery),
                    addToFavoriteFun: () => cubit.addToFavorite(),
                    addToSecretFun: () => cubit.addToSecret(context),
                  )
                : SizedBox(),
            floatingActionButton: cubit.noteId == null
                ? FloatingActionButton(
                    onPressed: () {
                      cubit.pickImageFromGallery(ImageSource.gallery);
                    },
                    child: Icon(Icons.add_photo_alternate_outlined),
                  )
                : SizedBox(),
          );
        },
      ),
    );
  }
}
