import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/note/bloc/add_note_cubit.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';
import 'package:notes_app/shared/components/bottom_icon_bar.dart';
import 'package:notes_app/shared/components/images_gridview.dart';
import 'package:notes_app/shared/components/records_list.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';
import 'package:notes_app/shared/components/speedDial_FAB/speedDialFAB.dart';
import 'package:notes_app/shared/share/share_functions.dart';

class AddNote extends StatefulWidget {
  final data;

  AddNote({this.data});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AddNoteCubit()..onBuildAddNoteScreen(widget.data, this),
      child: BlocConsumer<AddNoteCubit, AddNoteStates>(
        listener: (context, AddNoteStates state) {},
        builder: (context, state) {
          AddNoteCubit cubit = AddNoteCubit.get(context);
          return WillPopScope(
            onWillPop: ()=> cubit.onClosePageSave(context),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                actions: [
                  cubit.titleController.text.isNotEmpty ||
                          cubit.noteTextController.text.isNotEmpty ||
                          cubit.pickedGalleryImagesList.isNotEmpty
                      ? IconButton(
                          onPressed: () => cubit.onSave(context),
                          icon: Icon(Icons.done))
                      : SizedBox(),
                ],
              ),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 50),
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(33, 0, 33, 0),
                          child: DefaultFormField(
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(fontSize: 30),
                              controller: cubit.titleController,
                              focusNode: cubit.titleFocus,
                              onTap: () => cubit.onFocusTitleChange(),
                              onChanged: (val) => cubit.onTextChange(),
                              maxLines: 3,
                              minLines: 1,
                              fillColor: Theme.of(context).primaryColor,
                              hintText: 'Title...',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(fontSize: 30)),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(33, 0, 33, 0),
                          child: DefaultFormField(
                            focusNode: cubit.bodyFocus,
                            controller: cubit.noteTextController,
                            onTap: () => cubit.onFocusBodyChange(),
                            onChanged: (val) => cubit.onTextChange(),
                            style: Theme.of(context).textTheme.subtitle2,
                            maxLines: null,
                            minLines: null,
                            keyboardType: TextInputType.multiline,
                            hintText: 'Your text...',
                            fillColor: Theme.of(context).primaryColor,
                            hintStyle: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        cubit.cachedImagesList.isNotEmpty
                            ? GridViewForImages(
                                cubit.cachedImagesList,
                                deleteFun: (id, index) {
                                  cubit.deleteSavedImage(
                                      imageID: id, index: index);
                                },
                                expansionTileHeader: 'Images',
                              )
                            : SizedBox(),
                        cubit.recordsList.isNotEmpty
                            ? RecordsList(
                                recordsList: cubit.recordsList,
                                deleteRecordFun: (index, recordId) =>
                                    cubit.deleteRecord(
                                        index: index, recordID: recordId))
                            : SizedBox(),
                      ],
                    ),
                  ),
                  (cubit.noteId != null &&
                              MediaQuery.of(context).viewInsets.bottom == 0) ||
                          cubit.isRecording
                      ? Positioned(
                          bottom: 0,
                          child: BottomIconBar(
                            shareFun: ()=> shareNoteAndMemory(cubit.cachedImagesList  ,cubit.titleController.text ,cubit.noteTextController.text,'note'),
                            isRecording: cubit.isRecording,
                            isFavorite: cubit.isFavorite,
                            deleteFun: () => cubit.deleteNote(context),
                            addImageFun: () =>
                                cubit.pickMultiImageFromGallery(context),
                            addToFavoriteFun:()=> cubit.favFun(context),
                            addToSecretFun: () => cubit.addNoteToSecret(context),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
                  ? ExpandableFab(
                      children: [
                        ActionButton(
                          onPressed: () =>
                              cubit.pickMultiImageFromGallery(context),
                          iconPath: 'assets/icons/take_image.svg',
                        ),
                        ActionButton(
                          onPressed: () {
                            cubit.isRecording
                                ? cubit.stopRecorder(context)
                                : cubit.startRecorder();
                          },
                          iconPath: 'assets/icons/mic.svg',
                        ),
                      ],
                    )
                  : SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
