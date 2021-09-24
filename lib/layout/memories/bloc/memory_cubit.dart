import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/memories/bloc/memory_states.dart';
import 'package:notes_app/shared/components/reusable/time_date.dart';
import 'package:notes_app/shared/functions/functions.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';
import 'package:sqflite/sqflite.dart';

class AddMemoryCubit extends Cubit<AppMemoryStates> {
  AddMemoryCubit() : super(InitialState());

  static AddMemoryCubit get(context) => BlocProvider.of(context);

  TextEditingController memoryTextController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  FocusNode bodyFocus = new FocusNode();
  FocusNode titleFocus = new FocusNode();
  int? memoryID;
  String? memoryDate;
  List pickedGalleryImagesList = [];
  List cachedImagesList = [];
  bool isFavorite = false;
  late Database database;
  bool showDateErrorText = false;
  final formKey = GlobalKey<FormState>();
  int? isSecret;

  void onBuild(data) async {
    var db = await openDatabase('database.db');
    database = db;
    if (data != null) {
      memoryID = data['id'];
      titleController.text = data['title'].toString();
      memoryTextController.text = data['body'].toString();
      if (data['memoryDate'] != 'null') memoryDate = data['memoryDate'];
      cachedImagesList = data['images'];
      isFavorite = data['is_favorite'] == 1 ? true : false;
      isSecret = data['is_secret'];
    }
    emit(OnBuildState());
  }

  void onFocusBodyChange() {
    titleFocus.unfocus();
    bodyFocus.requestFocus();
    emit(FocusBodyChangeState());
  }

  void onFocusTitleChange() {
    bodyFocus.unfocus();
    titleFocus.requestFocus();
    emit(FocusTitleChangeState());
  }

  onTextChange() {
    emit(OnMemoryTextChangedState());
  }

  void datePicker(context) async {
    titleFocus.unfocus();
    bodyFocus.unfocus();
    await TimeAndDate.getDatePicker(
      context,
      firstDate: DateTime.parse('1900-09-22'),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        memoryDate = value;
        showDateErrorText = false;
        emit(TimePickerState());
      }
    });
  }

  pickMultiImageFromGallery(context) {
    pickMultiImagesFromGallery(pickedGalleryImagesList).then((value) async {
      if (memoryID != null) {
        savePickedImages();
      } else {
        emit(ShowUnSavedPickedImagesState());
      }
    });
  }

  void deleteUnSaveImage(index) {
    pickedGalleryImagesList.removeAt(index);
    emit(DeleteUnSaveImageState());
  }

  void savePickedImages() => savePickedImagesToPhoneCacheAndDataBase(
              database,
              pickedGalleryImagesList,
              memoryID,
              'memories_images',
              'memory_id',
              'memories_images')
          .then((value) {
        pickedGalleryImagesList = [];
        getMemoryImagesFromDatabase(memoryID);
      });

  void getMemoryImagesFromDatabase(id) async {
    cachedImagesList = [];
    database.rawQuery('SELECT * FROM memories_images WHERE memory_id = ?',
        [id]).then((value) {
      cachedImagesList = makeModifiableResults(value);
      emit(GetCachedImagesPathsFromDatabaseState());
    });
  }

  Future insertNewMemory(
    context, {
    required String title,
    required String body,
    required String memoryDate,
  }) async {
    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);

    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO memories (title ,body ,createdTime ,createdDate, memoryDate,type) VALUES ("$title","$body","$createdTime","$createdDate","${memoryDate.toString()}","memory")')
          .then((value) {
        memoryID = value;
        print(value);
      }).catchError((error) {
        print(error.toString());
      });
    });
    if(titleFocus.hasFocus || bodyFocus.hasFocus){
      titleFocus.unfocus();
      bodyFocus.unfocus();
    }
    if (pickedGalleryImagesList.isNotEmpty) savePickedImages();

    emit(InsertDatabaseState());
    return memoryID;
  }

  Future updateMemory(context,
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
      getMemoryImagesFromDatabase(memoryID);
      if(titleFocus.hasFocus || bodyFocus.hasFocus){
        titleFocus.unfocus();
        bodyFocus.unfocus();
      }
    });
    emit(UpdateTitleAndBodyState());
  }

  void deleteMemory(context) {
    deleteOneItem(
      context,
      database,
      id: memoryID,
      tableName: 'memories',
      cachedImagesList: cachedImagesList,
    );
  }

  void deleteImage({required int imageID, required int index}) async {
    await database.rawDelete(
        'DELETE FROM memories_images WHERE id = ?', [imageID]).then((value) {
      File('${cachedImagesList[index]['link']}').delete(recursive: true);
      cachedImagesList.removeAt(index);
      emit(DeleteOneImageState());
    }).catchError((error) {
      print(error);
    });
  }

  addToFavorite(context) async {
    isFavorite = await favoriteFun(
        context, database, 'memories', isFavorite, memoryID, isSecret);
    emit(FavoriteState());
  }

  void addNoteToSecret(context) => addToSecret(context, memoryID, 'memories');

  void saveButton(context) {
    if (formKey.currentState!.validate() && memoryDate != null ) {
      showDateErrorText = false;
      if (memoryID == null) {
        insertNewMemory(
          context,
          memoryDate: memoryDate.toString(),
          title: titleController.text,
          body: memoryTextController.text,
        );
      } else {
        updateMemory(context,
            id: memoryID!,
            body: memoryTextController.text,
            memoryDate: memoryDate.toString(),
            title: titleController.text);
      }
      showToast(Languages.of(context)!.toast['saved']);
    } else {
      if(memoryDate == null ) showDateErrorText = true;

    }
    emit(ShowDateErrorText());
  }

  Future<bool> onCloseSave(context) async {
    // return false ;
    if(titleFocus.hasFocus || bodyFocus.hasFocus){
      titleFocus.unfocus();
      bodyFocus.unfocus();
    }

    if (formKey.currentState!.validate() && memoryDate != null) {
      showDateErrorText = false;
      if (memoryID == null) {
        await insertNewMemory(
          context,
          memoryDate: memoryDate.toString(),
          title: titleController.text,
          body: memoryTextController.text,
        );
      } else {
        await updateMemory(context,
            id: memoryID!,
            body: memoryTextController.text,
            memoryDate: memoryDate.toString(),
            title: titleController.text);
      }
      return true;
    } else {
      showDateErrorText = true;
      if (
          titleController.text.isEmpty &&
          memoryTextController.text.isEmpty &&
          cachedImagesList.isEmpty&& memoryDate == null) {
        // delete
        if(memoryID != null){
          deleteMemory(context);
        }
        return true;
      } else {
        if(memoryDate == null ) showDateErrorText = true;
        print('show alert');
        await discardAndSaveAlert(context, Languages.of(context)!.discardAndSaveAlert['memoryMessage'],Languages.of(context)!.discardAndSaveAlert['memoryEmpty']);
        // show alert
        return false;
      }
    }
  }



  @override
  Future<void> close() async {
    // database.close();
    return super.close();
  }
}
Future<void> discardAndSaveAlert(context,subHeadText,head) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          Languages.of(context)!.discardAndSaveAlert['warning'],
          style:
          Theme.of(context).textTheme.headline1!.copyWith(fontSize: 22),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                head ,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontSize: 16),
              ),
              SizedBox(
                height: 3,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 5),
                child: Text(subHeadText,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              Languages.of(context)!.cancelBtn,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(
            width: 15,
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)),
            color: Theme.of(context).colorScheme.secondary,
            child: Text(
              Languages.of(context)!.discardBtn,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
    },
  );
}