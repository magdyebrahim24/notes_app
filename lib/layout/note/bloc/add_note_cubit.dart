import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';
import 'package:notes_app/shared/components/reusable/time_date.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
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
  bool isFavorite = false;

  late Database database;
  onBuildAddNoteScreen(data) async {
    var db = await openDatabase('database.db');
    database = db;
    if (data != null) {
      noteId = data['id'];
      titleController.text = data['title'].toString();
      noteTextController.text = data['body'].toString();
      cachedImagesList = data['images'];
      isFavorite = data['is_favorite'] == 1 ? true : false;
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
      selectedGalleryImagesList.add({'link': _image.path});
      emit(AddNoteAddImageState());
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
        await Directory('$appDocPath/notes_images').create(recursive: true);

    XFile? _currentImageToSave;

    List cachedImagesPaths = [];
    for (int index = 0; index < selectedGalleryImagesList.length; index++) {
      String imageName =
          selectedGalleryImagesList[index]['link'].split('/').last;
      final String filePath = '${directoryPath.path}/$imageName';
      _currentImageToSave = XFile(selectedGalleryImagesList[index]['link']);
      await _currentImageToSave.saveTo(filePath);
      cachedImagesPaths.add(filePath);
    }
    selectedGalleryImagesList = [];
    insertCachedImagedToDatabase(images: cachedImagesPaths);
    // List listOfFiles = await directoryPath.list(recursive: true).toList();
    emit(AddNoteAddImagesToCacheState());
  }

  // add cached images path to database

  Future insertCachedImagedToDatabase({required List images}) async {
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
      getNoteImagesFromDatabase(noteId);
      return Future.value(true);
    });

    emit(AddNoteAddCachedImagesPathToDatabaseState());
  }

  void getNoteImagesFromDatabase(id) async {
    cachedImagesList = [];
    database.rawQuery(
        'SELECT * FROM notes_images WHERE note_id = ?', [id]).then((value) {
      value.forEach((element) {
        print(element);
      });
      cachedImagesList = value ;
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
    context, {
    required String title,
    required String body,
  }) async {
    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO notes (title ,body ,createdTime ,createdDate,type) VALUES ("$title","$body","$createdTime","$createdDate","note")')
          .then((value) {
        noteId = value;
        if (selectedGalleryImagesList.isNotEmpty) {
          saveSelectedImagesToPhoneCache();
          getNoteImagesFromDatabase(value);
        }
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

  void getNoteDataFromDatabase() async {
    noteList = [];
    // emit(AppLoaderState());
    database.rawQuery('SELECT * FROM notes').then((value) {
      noteList = value;
      value.forEach((element) {
        print(element);
      });
      emit(AddNoteGetDatabaseState());
    });
  }

  void deleteNote(context, {required int id}) async {
    print(id);
    await database
        .rawDelete('DELETE FROM notes WHERE id = ?', [id]).then((value) {
      deleteAllNoteCachedImages();
      Navigator.pop(context);
      getNoteDataFromDatabase();
    }).catchError((error) {
      print(error);
    });
    emit(AddNoteDeleteOneNoteState());
  }

  void updateNote(context,
      {required String title, required String body, required int id}) async {
    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);

    database.rawUpdate(
        'UPDATE notes SET title = ? , body = ? , createdTime = ? ,createdDate = ? WHERE id = ?',
        ['$title', '$body', '$createdTime', '$createdDate', id]).then((value) {
      if (selectedGalleryImagesList.isNotEmpty) {
        saveSelectedImagesToPhoneCache();
        getNoteImagesFromDatabase(noteId);
      }
      getNoteDataFromDatabase();
      titleFocus.unfocus();
      bodyFocus.unfocus();
    });
    emit(AddNoteUpdateTitleAndBodyState());
  }

  void deleteImage({required int imageID, required int index}) async {
    print(imageID);
    await database.rawDelete(
        'DELETE FROM notes_images WHERE id = ?', [imageID]).then((value) {
      File('${cachedImagesList[index]['link']}').delete(recursive: true);
      getNoteImagesFromDatabase(imageID);
      emit(AddNoteDeleteOneImageState());
    }).catchError((error) {
      print(error);
    });
  }

  void addToFavorite() {
    database.rawUpdate('UPDATE notes SET is_favorite = ? WHERE id = ?',
        [!isFavorite, noteId]).then((val) {
      isFavorite = !isFavorite;
      print('$val $isFavorite is done');
      emit(AddNoteFavoriteState());
      getNoteDataFromDatabase();
    }).catchError((error) {
      print(error);
    });
  }

  void addToSecret() {
    database.rawUpdate(
        'UPDATE notes SET is_secret = ? WHERE id = ?', [1, noteId]).then((val) {
      print('$val  is done');
      emit(AddNoteToSecretState());
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Future<void> close() async {
    // await database.close();
    return super.close();
  }
}
