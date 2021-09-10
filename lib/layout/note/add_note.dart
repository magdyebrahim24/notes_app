import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/note/bloc/add_note_cubit.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';
import 'package:notes_app/shared/components/bottom_icon_bar.dart';
import 'package:notes_app/shared/components/images_gridview.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
import 'package:notes_app/shared/components/speedDialFAB.dart';
import 'package:notes_app/shared/constants.dart';

class AddNote extends StatelessWidget {
  final data;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AddNote({this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AddNoteCubit()..onBuildAddNoteScreen(data),
      child: BlocConsumer<AddNoteCubit, AddNoteStates>(
        listener: (context, AddNoteStates state) {},
        builder: (context, state) {
          // AppCubit appCubit = AppCubit.get(context);
          AddNoteCubit cubit = AddNoteCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                // ElevatedButton(
                //   onPressed: () => cubit.newRecord(context),
                //   //color: Colors.white,
                //   //disabledColor: Colors.grey,
                //   child: Text(cubit.mRecorder!.isRecording ? 'Stop' : 'Record'),
                // ),
                cubit.titleController.text.isNotEmpty ||
                        cubit.noteTextController.text.isNotEmpty ||
                        cubit.pickedGalleryImagesList.isNotEmpty
                    ? IconButton(
                        onPressed: () => cubit.onSave(context),
                        icon: Icon(Icons.done))
                    : SizedBox(),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(33, 0, 33, 0),
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  DefaultFormField(
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline4!.color,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    controller: cubit.titleController,
                    focusNode: cubit.titleFocus,
                    onTap: () => cubit.onFocusTitleChange(),
                    onChanged: (val) => cubit.onTextChange(),
                    maxLines: 3,
                    minLines: 1,
                    fillColor: Theme.of(context).primaryColor,
                    hintText: 'Title...',
                    hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.headline4!.color,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  DefaultFormField(
                    focusNode: cubit.bodyFocus,
                    controller: cubit.noteTextController,
                    onTap: () => cubit.onFocusBodyChange(),
                    onChanged: (val) => cubit.onTextChange(),
                    style: TextStyle(
                      color: Color(0xff666666),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                    maxLines: null,
                    minLines: null,
                    keyboardType: TextInputType.multiline,
                    hintText: 'Your text...',
                    fillColor: Theme.of(context).primaryColor,
                    hintStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 20),
                  ),
                  GridViewForImages(
                    cubit.cachedImagesList,
                    deleteFun: (id, index) {
                      cubit.deleteSavedImage(imageID: id, index: index);
                    },
                    expansionTileHeader: 'Images',
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cubit.recordsList.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => cubit.getPlaybackFn(
                              cubit.recordsList[index]['link'], index),
                          child: Text(
                              cubit.mPlayer!.isPlaying && index == cubit.item
                                  ? 'Stop'
                                  : 'Play'),
                        ),
                        IconButton(
                            onPressed: () => cubit.deleteSavedRecord(
                                recordID: cubit.recordsList[index]['id'],
                                index: index),
                            icon: Icon(Icons.clear_rounded))
                      ],
                    ),
                  ),

                ],
              ),
            ),
            bottomNavigationBar: cubit.noteId != null
                ?                       BottomIconBar(
                          isFavorite: cubit.isFavorite,
                          deleteFun: () => cubit.deleteNote(context),
                          addImageFun: () => cubit.pickMultiImageFromGallery(context),
                          addToFavoriteFun: cubit.favFun,
                          addToSecretFun: () => cubit.addNoteToSecret(context),


                )
                : SizedBox(),
            floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0 ? ExpandableFab(
              children: [
                ActionButton(
                  onPressed: ()=> cubit.pickMultiImageFromGallery(context),
                  iconPath: 'assets/icons/take_image.svg',
                ),
                ActionButton(
                  onPressed: () {},
                  iconPath: 'assets/icons/mic.svg',
                ),
              ],
            ) : SizedBox(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          );

        },
      ),
    );
  }
}
