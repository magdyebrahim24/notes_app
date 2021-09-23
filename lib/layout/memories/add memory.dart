import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/layout/memories/bloc/memory_cubit.dart';
import 'package:notes_app/layout/memories/bloc/memory_states.dart';
import 'package:notes_app/layout/task/add_task.dart';
import 'package:notes_app/shared/components/bottom_icon_bar.dart';
import 'package:notes_app/shared/components/images_gridview.dart';
import 'package:notes_app/shared/components/reusable/reusable.dart';

class AddMemory extends StatelessWidget {
  final data;

  AddMemory({this.data});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddMemoryCubit()..onBuild(data),
      child: BlocConsumer<AddMemoryCubit, AppMemoryStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AddMemoryCubit cubit = AddMemoryCubit.get(context);
          return WillPopScope(
            onWillPop: ()=> cubit.onCloseSave(context),
            child: Scaffold(
                appBar: AppBar(
                  // leading: IconButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   icon: Icon(Icons.arrow_back_ios),
                  //   iconSize: 20,
                  // ),
                  actions: [
                    cubit.titleController.text.isNotEmpty ||
                            cubit.memoryTextController.text.isNotEmpty ||
                            cubit.pickedGalleryImagesList.isNotEmpty
                        ? IconButton(
                            onPressed: () => cubit.saveButton(context),
                            icon: Icon(Icons.done))
                        : SizedBox(),
                  ],
                ),
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    Form(
                      key: cubit.formKey,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 37),
                              child: Text(
                                'Title',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(fontSize: 28),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15, top: 15, left: 37, right: 37),
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 4),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardTheme.color,
                                  borderRadius: BorderRadius.circular(10)),
                              child: DefaultFormField(
                                onTap: () {
                                  cubit.onFocusTitleChange();
                                },
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .color,
                                  fontSize: 16,
                                ),
                                onChanged: (value) {
                                  cubit.onTextChange();
                                },
                                focusNode: cubit.titleFocus,
                                controller: cubit.titleController,
                                maxLines: 3,
                                minLines: 1,
                                hintText: 'Title',
                                validator: (value) {
                                  if (value.toString().isEmpty)
                                    return 'Memory title can\'t be empty';
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsetsDirectional.only(
                                bottom: 25,
                                start: 37,
                                end: MediaQuery.of(context).size.width * .22,
                              ),
                              padding: EdgeInsets.fromLTRB(15, 7, 15, 5),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardTheme.color,
                                  borderRadius: BorderRadius.circular(10)),
                              child: DefaultFormField(
                                focusNode: cubit.bodyFocus,
                                controller: cubit.memoryTextController,
                                onTap: () {
                                  cubit.onFocusBodyChange();
                                },
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .color,
                                  fontSize: 16,
                                ),
                                onChanged: (value) {
                                  cubit.onTextChange();
                                },
                                maxLines: 10,
                                minLines: 4,
                                keyboardType: TextInputType.multiline,
                                hintText: 'Memory details',
                                fillColor: Theme.of(context).primaryColor,
                                // hintStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 20),
                              ),
                            ),
                            Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: 37, bottom: 20),
                              width: MediaQuery.of(context).size.width * .45,
                              child: dateTimeWidget(context,
                                  errorText: cubit.showDateErrorText
                                      ? 'memory Date Required'
                                      : null,
                                  label: 'Date',
                                  textSize: 14.0,
                                  height: 62.0,
                                  fun: () => cubit.datePicker(context),
                                  text: cubit.memoryDate ?? 'MM DD,YYYY',
                                  iconPath: 'assets/icons/date.svg'),
                            ),
                            cubit.cachedImagesList.isNotEmpty
                                ? GridViewForImages(
                                    cubit.cachedImagesList,
                                    deleteFun: (id, index) {
                                      cubit.deleteImage(
                                          imageID: id, index: index);
                                    },
                                    expansionTileHeader: 'Images',
                                  )
                                : SizedBox(),
                            cubit.pickedGalleryImagesList.isNotEmpty
                                ? GridViewForImages(
                                    cubit.pickedGalleryImagesList,
                                    deleteFun: (id, index) {
                                      cubit.deleteUnSaveImage(index);
                                    },
                                    expansionTileHeader: 'Images',
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    cubit.memoryID != null
                        ? Positioned(
                            bottom: 0,
                            child: BottomIconBar(
                              isFavorite: cubit.isFavorite,
                              deleteFun: () => cubit.deleteMemory(context),
                              addImageFun: () =>
                                  cubit.pickMultiImageFromGallery(context),
                              addToFavoriteFun: () => cubit.addToFavorite(context),
                              addToSecretFun: () =>
                                  cubit.addNoteToSecret(context),
                              isRecording: false,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: MaterialButton(
                    onPressed: () => cubit.pickMultiImageFromGallery(context),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 6)),
                    child: SvgPicture.asset(
                      'assets/icons/take_image.svg',
                      height: 28,
                      width: 28,
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    height: 96,
                    minWidth: 96,
                    elevation: 0,
                  ),
                )),
          );
        },
      ),
    );
  }
}
