import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';
import 'package:path_provider/path_provider.dart';
import 'package:undo/undo.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitialState());

  static AddNoteCubit get(context) => BlocProvider.of(context);

  TextEditingController noteTextController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  FocusNode bodyFocus = new FocusNode();
  FocusNode titleFocus = new FocusNode();
  List selectedGalleryImagesList = [];
  List cachedImagesList = [];
  int? noteId;
  List noteList = [];
  bool isFavorite = false ;

  onBuildAddNoteScreen(id, data, db) {
    if (id != null) {
      noteId = data['id'];
      titleController.text = data['title'].toString();
      noteTextController.text = data['body'].toString();
      cachedImagesList = data['images'];
      isFavorite =  data['is_favorite'] == 1 ? true : false;
    }
    emit(OnBuildAddNoteInitialState());
  }

  void onFocusBodyChange() {
    titleFocus.unfocus();
    bodyFocus.requestFocus();
    emit(AddNoteFocusBodyChangeState());
  }

  void onFocusTitleChange() {
    bodyFocus.unfocus();
    titleFocus.requestFocus();
    emit(AddNoteFocusTitleChangeState());
  }

  SimpleStack? stackController = SimpleStack<dynamic>(
    '',
    onUpdate: (val) {},
  );

  void clearStack() {
    stackController!.clearHistory();
    emit(AddNoteClearStackState());
  }

  undoFun() {
    stackController!.undo();
    noteTextController.text = stackController!.state;
    emit(AddNoteUndoState());
  }

  redoFun() {
    stackController!.redo();
    noteTextController.text = stackController!.state;
    emit(AddNoteRedoState());
  }

  onNoteTextChanged(value) {
    stackController!.modify(value);
    emit(AddNoteOnNoteTextChangedState());
  }

  onTitleChange() {
    emit(AddNoteTitleChangedState());
  }

  pickImageFromGallery(ImageSource src) async {
    XFile? _image = await ImagePicker().pickImage(source: src);
    if (_image != null) {
      selectedGalleryImagesList.add(_image.path);
      emit(AddNoteAddImageState());
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
        await Directory('$appDocPath/notes_images').create(recursive: true);

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
    emit(AddNoteAddImagesToCacheState());
  }

  // add cached images path to database

  Future insertCachedImagedToDatabase(database, {required List images}) async {
    await database.transaction((txn) {
      for (int i = 0; i < images.length; i++) {
        txn
            .rawInsert(
                'INSERT INTO notes_images (link ,note_id) VALUES ("${images[i]}","$noteId")')
            .then((value) {
          print(value);
        }).catchError((error) {
          print(error.toString());
        });
      }
      getNoteImagesFromDatabase(database, noteId);
      return Future.value(true);
    });

    emit(AddNoteAddCachedImagesPathToDatabaseState());
  }

  void getNoteImagesFromDatabase(db, id) async {
    cachedImagesList = [];
    db.rawQuery('SELECT * FROM notes_images WHERE note_id = ?', [id]).then((value) {
      value.forEach((element) {
        cachedImagesList.add(element['link']);

        print(element);
      });
      emit(AddNoteGetCachedImagesPathsFromDatabaseState());
    });

  }

  void deleteAllNoteCachedImages() {
    for (int i = 0; i < cachedImagesList.length; i++) {
      File('${cachedImagesList[i]}').delete(recursive: true);
    }
  }

  // start coding database

  Future insertNewNote(
    database, {
    required String title,
    required String body,
  }) async {
    // var db = await openDatabase('database.db');
    DateTime dateTime = DateTime.now();
    String createdDate = dateTime.toString().split(' ').first;
    String time = dateTime.toString().split(' ').last;
    String createdTime = time.toString().split('.').first;
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO notes (title ,body ,createdTime ,createdDate) VALUES ("$title","$body","$createdTime","$createdDate")')
          .then((value) {
        noteId = value;
        saveSelectedImagesToPhoneCache(database);
        getNoteImagesFromDatabase(database, noteId);
        print(value);
      }).catchError((error) {
        print(error.toString());
      });

      return Future.value(true);
    });
    titleFocus.unfocus();
    bodyFocus.unfocus();
    emit(AddNoteInsertDatabaseState());
  }


  void getNoteDataFromDatabase(db) async {
    noteList = [];
    // emit(AppLoaderState());
    db.rawQuery('SELECT * FROM notes').then((value) {
      noteList = value ;
      value.forEach((element) {
        print(element);
      });
      emit(AddNoteGetDatabaseState());
    });
  }

  void deleteNote(db, context, {required int id}) async {
    print(id);
    await db.rawDelete('DELETE FROM notes WHERE id = ?', [id]).then((value) {
      deleteAllNoteCachedImages();
      Navigator.pop(context);
      getNoteDataFromDatabase(db);
    }).catchError((error) {
      print(error);
    });
    emit(AddNoteDeleteOneNoteState());
  }

  void updateNote(db,
      {required String title, required String body, required int id}) async {
    DateTime dateTime = DateTime.now();
    String createdDate = dateTime.toString().split(' ').first;
    String time = dateTime.toString().split(' ').last;
    String createdTime = time.toString().split('.').first;

    db.rawUpdate(
        'UPDATE notes SET title = ? , body = ? , createdTime = ? ,createdDate = ? WHERE id = ?',
        ['$title', '$body', '$createdTime', '$createdDate', id]).then((value) {
      saveSelectedImagesToPhoneCache(db);
      getNoteImagesFromDatabase(db, noteId);
      getNoteDataFromDatabase(db);
      titleFocus.unfocus();
      bodyFocus.unfocus();
    });
    emit(AddNoteUpdateTitleAndBodyState());
  }
  void deleteImage(db, {required int imageID ,required int index}) async {
    print(imageID);
    await db.rawDelete('DELETE FROM notes_images WHERE id = ?', [imageID]).then((value) {
      File('${cachedImagesList[index]['link']}').delete(recursive: true);
      getNoteImagesFromDatabase(db,imageID);
      emit(AddNoteDeleteOneImageState());
    }).catchError((error) {
      print(error);
    });

  }

  void addToFavorite(db){
    db.rawUpdate(
        'UPDATE notes SET is_favorite = ? WHERE id = ?',
        [!isFavorite, noteId]).then((val){
      isFavorite = !isFavorite ;
      print('$val $isFavorite is done');
      emit(AddNoteFavoriteState());
      getNoteDataFromDatabase(db);
    }).catchError((error){
      print(error);
    });
  }
}
