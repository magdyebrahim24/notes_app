import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/memories/bloc/states.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:undo/undo.dart';

class AddMemoryCubit extends Cubit<AppMemoryStates> {
  AddMemoryCubit() : super(AppMemoryInitialState());

  static AddMemoryCubit get(context) => BlocProvider.of(context);

  FocusNode bodyFocus = new FocusNode();
  FocusNode titleFocus = new FocusNode();
  int? memoryID;
  String? dateController;
  List memoryList = [];
  List cachedImagesList = [];
  TextEditingController memoryTextController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  List selectedGalleryImagesList = [];
  XFile? image;

  void onFocusBodyChange() {
    titleFocus.unfocus();
    bodyFocus.requestFocus();
    emit(AddMemoryFocusBodyChangeState());
  }

  void onFocusTitleChange() {
    bodyFocus.unfocus();
    titleFocus.requestFocus();
    emit(AddMemoryFocusTitleChangeState());
  }

  SimpleStack? stackController = SimpleStack<dynamic>(
    '',
    onUpdate: (val) {},
  );

  void clearStack() {
    stackController!.clearHistory();
    emit(AddMemoryClearStackState());
  }

  undoFun() {
    stackController!.undo();
    memoryTextController.text = stackController!.state;
    emit(AddMemoryUndoState());
  }

  redoFun() {
    stackController!.redo();
    memoryTextController.text = stackController!.state;
    emit(AddMemoryRedoState());
  }

  onMemoryTextChanged(value) {
    stackController!.modify(value);
    emit(AddMemoryOnMemoryTextChangedState());
  }

  onTitleChange() {
    emit(AddMemoryTitleChangedState());
  }


  void datePicker(context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.parse('1900-09-22'),
      lastDate: DateTime.now(),
    ).then((value) {
      dateController = DateFormat.yMMMd().format(value!);
      emit(AppMemoryTimePickerState());
    }).catchError((error) {});
  }

  pickImageFromGallery(ImageSource src) async {
    XFile? _image = await ImagePicker().pickImage(source: src);
    if (_image != null) {
      selectedGalleryImagesList.add(_image.path);
      emit(AddMemoryAddImageStateState());
    } else {
      print('No Image Selected');
    }
  }

  Future saveSelectedImagesToPhoneCache(db) async {
    // get app path
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // create new folder
    Directory directoryPath =
        await Directory('$appDocPath/memories_images').create(recursive: true);

    XFile? _currentImageToSave;

    List cachedImagesPaths = [];
    for (int index = 0; index < selectedGalleryImagesList.length; index++) {
      String imageName = selectedGalleryImagesList[index].split('/').last;
      final String filePath = '${directoryPath.path}/$imageName';
      _currentImageToSave = XFile(selectedGalleryImagesList[index]);
      await _currentImageToSave.saveTo(filePath);
      cachedImagesPaths.add(filePath);
    }
    selectedGalleryImagesList = [];
    insertCachedImagedToDatabase(db, images: cachedImagesPaths);
    // List listOfFiles = await directoryPath.list(recursive: true).toList();
    emit(AddMemoryAddImagesToCacheState());
  }

  Future insertCachedImagedToDatabase(database, {required List images}) async {
    await database.transaction((txn) {
      for (int i = 0; i < images.length; i++) {
        txn
            .rawInsert(
            'INSERT INTO memories_images (link ,memory_id) VALUES ("${images[i]}","$memoryID")')
            .then((value) {
          print(value);
        }).catchError((error) {
          print(error.toString());
        });
      }
      getMemoryImagesFromDatabase(database, memoryID);
      return Future.value(true);
    });

    emit(AddMemoryAddCachedImagesPathToDatabaseState());
  }

  void getMemoryImagesFromDatabase(db, id) async {
    cachedImagesList = [];
    db.rawQuery('SELECT * FROM memories_images WHERE memory_id = ?', [id]).then((value) {
      value.forEach((element) {
        cachedImagesList.add(element);

        print(element);
      });
      emit(AddMemoryGetCachedImagesPathsFromDatabaseState());
    });

  }

  void deleteAllMemoryCachedImages() {
    for (int i = 0; i < cachedImagesList.length; i++) {
      File('${cachedImagesList[i]}').delete(recursive: true);
    }
  }

  Future insertNewMemory(
    database, {
    required String title,
    required String body,
    required String memoryDate,
  }) async {
    // var db = await openDatabase('database.db');
    DateTime dateTime = DateTime.now();
    String createdDate = dateTime.toString().split(' ').first;
    String time = dateTime.toString().split(' ').last;
    String createdTime = time.toString().split('.').first;
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO memories (title ,body ,createdTime ,createdDate, memoryDate) VALUES ("$title","$body","$createdTime","$createdDate","$memoryDate")')
          .then((value) {
        memoryID = value;
        saveSelectedImagesToPhoneCache(database);
        getMemoryImagesFromDatabase(database, memoryID);
        getMemoryDataFromDatabase(database);
        print(value);
      }).catchError((error) {
        print(error.toString());
      });

      return Future.value(true);
    });
    titleFocus.unfocus();
    bodyFocus.unfocus();
    emit(AddMemoryInsertDatabaseState());
  }

  void getMemoryDataFromDatabase(db) async {
    memoryList = [];
    // emit(AppLoaderState());
    db.rawQuery('SELECT * FROM memories').then((value) {
      value.forEach((element) {
        print(element);
        memoryList.add(element);
      });
      emit(AddMemoryGetDatabaseState());
    });
  }

  void updateMemory(db,
      {required String title,
      required String body,
      required String memoryDate,
      required int id}) async {
    DateTime dateTime = DateTime.now();
    String createdDate = dateTime.toString().split(' ').first;
    String time = dateTime.toString().split(' ').last;
    String createdTime = time.toString().split('.').first;

    db.rawUpdate(
        'UPDATE memories SET title = ? , body = ? , createdTime = ? ,createdDate = ? ,memoryDate = ? WHERE id = ?',
        [
          '$title',
          '$body',
          '$createdTime',
          '$createdDate',
          '$memoryDate',
          id
        ]).then((value) {
      saveSelectedImagesToPhoneCache(db);
      getMemoryImagesFromDatabase(db, memoryID);
      getMemoryDataFromDatabase(db);
      titleFocus.unfocus();
      bodyFocus.unfocus();
    });
    emit(AddMemoryUpdateTitleAndBodyState());
  }

  void deleteMemory(db, context, {required int id}) async {
    print(id);
    await db.rawDelete('DELETE FROM memories WHERE id = ?', [id]).then((value) {
      deleteAllMemoryCachedImages();
      Navigator.pop(context);
      getMemoryDataFromDatabase(db);
    }).catchError((error) {
      print(error);
    });
    emit(AddMemoryDeleteOneMemoryState());
  }

  void deleteImage(db, {required int imageID ,required int index}) async {
    print(imageID);
    await db.rawDelete('DELETE FROM memories_images WHERE id = ?', [imageID]).then((value) {
      File('${cachedImagesList[index]['link']}').delete(recursive: true);
      getMemoryImagesFromDatabase(db,imageID);
      emit(AddMemoryDeleteOneImageState());
    }).catchError((error) {
      print(error);
    });

  }
}
