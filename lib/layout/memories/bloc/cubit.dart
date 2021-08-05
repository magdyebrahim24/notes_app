import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/memories/bloc/states.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/shared/components/reusable/time_date.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
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
  bool isFavorite = false ;
  late Database database ;

  void onBuild(data) async{
    var db = await openDatabase('database.db');
    database = db ;

    print('memory data --------------------------');
    print(data.toString());
    if (data != null) {
      memoryID = data['id'];
      titleController.text = data['title'].toString();
      memoryTextController.text = data['body'].toString();
      dateController = data['memoryDate'];
      cachedImagesList = data['images'];
      isFavorite = data['is_favorite'] == 1 ? true : false;
    }
    emit(AppMemoryOnBuildState());
  }

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

  Future saveSelectedImagesToPhoneCache() async {
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
    insertCachedImagedToDatabase(images: cachedImagesPaths);
    // List listOfFiles = await directoryPath.list(recursive: true).toList();
    emit(AddMemoryAddImagesToCacheState());
  }

  Future insertCachedImagedToDatabase({required List images}) async {
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
      getMemoryImagesFromDatabase(memoryID);
      return Future.value(true);
    });

    emit(AddMemoryAddCachedImagesPathToDatabaseState());
  }

  void getMemoryImagesFromDatabase(id) async {
    cachedImagesList = [];
    database.rawQuery('SELECT * FROM memories_images WHERE memory_id = ?', [id]).then((value) {
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
      context, {
    required String title,
    required String body,
    required String memoryDate,
  }) async {

    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);

    database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO memories (title ,body ,createdTime ,createdDate, memoryDate) VALUES ("$title","$body","$createdTime","$createdDate","$memoryDate")')
          .then((value) {
        memoryID = value;
        saveSelectedImagesToPhoneCache();
        getMemoryImagesFromDatabase( memoryID);
        getMemoryDataFromDatabase();
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

  void getMemoryDataFromDatabase() async {
    memoryList = [];
    // emit(AppLoaderState());
    database.rawQuery('SELECT * FROM memories').then((value) {
      value.forEach((element) {
        print(element);
        memoryList.add(element);
      });
      emit(AddMemoryGetDatabaseState());
    });
  }

  void updateMemory(context,
      {required String title,
      required String body,
      required String memoryDate,
      required int id}) async {

    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);

    database.rawUpdate(
        'UPDATE memories SET title = ? , body = ? , createdTime = ? ,createdDate = ? ,memoryDate = ? WHERE id = ?',
        [
          '$title',
          '$body',
          '$createdTime',
          '$createdDate',
          '$memoryDate',
          id
        ]).then((value) {
      saveSelectedImagesToPhoneCache();
      getMemoryImagesFromDatabase(memoryID);
      getMemoryDataFromDatabase();
      titleFocus.unfocus();
      bodyFocus.unfocus();
    });
    emit(AddMemoryUpdateTitleAndBodyState());
  }

  void deleteMemory( context, {required int id}) async {
    print(id);
    await database.rawDelete('DELETE FROM memories WHERE id = ?', [id]).then((value) {
      deleteAllMemoryCachedImages();
      Navigator.pop(context);
      getMemoryDataFromDatabase();
    }).catchError((error) {
      print(error);
    });
    emit(AddMemoryDeleteOneMemoryState());
  }

  void deleteImage( {required int imageID ,required int index}) async {
    print(imageID);
    await database.rawDelete('DELETE FROM memories_images WHERE id = ?', [imageID]).then((value) {
      File('${cachedImagesList[index]['link']}').delete(recursive: true);
      getMemoryImagesFromDatabase(imageID);
      emit(AddMemoryDeleteOneImageState());
    }).catchError((error) {
      print(error);
    });

  }

  @override
  Future<void> close() async{
    // database.close();
    return super.close();
  }
}
