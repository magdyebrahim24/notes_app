import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/memories/bloc/cubit.dart';
import 'package:notes_app/layout/memories/bloc/states.dart';
import 'package:notes_app/shared/components/bottom_icon_bar.dart';
import 'package:notes_app/shared/components/gridview.dart';
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
          return Scaffold(
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
                        cubit.memoryTextController.text.isNotEmpty ||
                        cubit.selectedGalleryImagesList.isNotEmpty
                    ? IconButton(
                        onPressed: () => cubit.saveButton(context),
                        icon: Icon(Icons.done))
                    : SizedBox(),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: cubit.formKey,
                      child: DefaultFormField(
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
                        hintText: 'Title',
                        hintStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 28,
                            fontWeight: FontWeight.normal),
                        validator: (value){
                          if(value.toString().isEmpty){
                            return 'memory title required';
                          }
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).dividerColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Memory Date',
                            style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.headline4!.color),
                          ),
                          Spacer(),
                          MaterialButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            color: Theme.of(context).dividerColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              cubit.datePicker(context);
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    cubit.dateController ?? 'Add',
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                Icon(
                                  Icons.expand_more,
                                  color: Theme.of(context).textTheme.headline6!.color,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DefaultFormField(
                      focusNode: cubit.bodyFocus,
                      controller: cubit.memoryTextController,
                      onTap: () {
                        cubit.onFocusBodyChange();
                      },
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline4!.color,
                        fontSize: 20,
                      ),
                      onChanged: (value) {
                        cubit.onMemoryTextChanged(value);
                      },
                      maxLines: null,
                      minLines: null,
                      keyboardType: TextInputType.multiline,
                      hintText: 'Start typing your Memory ...',
                      fillColor: Theme.of(context).primaryColor,
                      hintStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 20),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GridViewForImages(cubit.selectedGalleryImagesList, false,
                        ),
                    GridViewForImages(cubit.cachedImagesList, false,
                        ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: cubit.memoryID != null
                ? BottomIconBar(
                    isFavorite: cubit.isFavorite,
                    deleteFun: () =>
                        cubit.deleteMemory(context, id: cubit.memoryID!),
                    addImageFun: () =>
                        cubit.pickImageFromGallery(ImageSource.gallery),
                    addToFavoriteFun: () => cubit.addToFavorite(),
                    addToSecretFun: ()=> cubit.addToSecret(context),
                  )
                : SizedBox(),
            floatingActionButton: cubit.memoryID == null
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
