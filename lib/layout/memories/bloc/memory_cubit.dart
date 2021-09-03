import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/memories/bloc/memory_states.dart';
import 'package:notes_app/shared/components/reusable/time_date.dart';
import 'package:notes_app/shared/functions/functions.dart';
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
  List pickedGalleryImagesList=[];
  List cachedImagesList = [];
  bool isFavorite = false ;
  late Database database ;

  final formKey = GlobalKey<FormState>();


  void saveButton(context){
   if(formKey.currentState!.validate()) {
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
    }
  }

  void onBuild(data) async{
    var db = await openDatabase('database.db');
    database = db ;
    if (data != null) {
      memoryID = data['id'];
      titleController.text = data['title'].toString();
      memoryTextController.text = data['body'].toString();
     if(data['memoryDate'] != 'null') memoryDate = data['memoryDate'];
      cachedImagesList = data['images'];
      isFavorite = data['is_favorite'] == 1 ? true : false;
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

  void datePicker(context) async{
    memoryDate= await TimeAndDate.getDatePicker(context, firstDate: DateTime.parse('1900-09-22'), lastDate: DateTime.now(),);
    emit(TimePickerState());
  }


  pickMultiImageFromGallery(context) =>
      pickMultiImagesFromGallery(pickedGalleryImagesList).then((value) async {
        if (memoryID == null) await insertNewMemory(context, title: titleController.text, body: memoryTextController.text,memoryDate: memoryDate??'');
        print('$memoryID ///////////////////////////////');
        savePickedImages();
      });

  void savePickedImages() => savePickedImagesToPhoneCacheAndDataBase(database, pickedGalleryImagesList, memoryID, 'memories_images', 'memory_id', 'memories_images')
      .then((value) {
    pickedGalleryImagesList = [];
    getMemoryImagesFromDatabase(memoryID);
  });

  void getMemoryImagesFromDatabase(id) async {
    cachedImagesList = [];
    database.rawQuery('SELECT * FROM memories_images WHERE memory_id = ?', [id]).then((value) {
      cachedImagesList = makeModifiableResults(value);
      emit(GetCachedImagesPathsFromDatabaseState());
    });

  }

  // void deleteAllMemoryCachedImages() {
  //   for (int i = 0; i < cachedImagesList.length; i++) {
  //     File('${cachedImagesList[i]}').delete(recursive: true);
  //   }
  // }

  Future insertNewMemory(
      context, {
    required String title,
    required String body,
    required String memoryDate,
  }) async {

    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);

   await database.transaction((txn) async{
      txn
          .rawInsert(
              'INSERT INTO memories (title ,body ,createdTime ,createdDate, memoryDate,type) VALUES ("$title","$body","$createdTime","$createdDate","${memoryDate.toString()}","memory")')
          .then((value) {
        memoryID = value;
        // getMemoryImagesFromDatabase( memoryID);
        // getMemoryDataFromDatabase();
        print(value);
      }).catchError((error) {
        print(error.toString());
      });
    });
    titleFocus.unfocus();
    bodyFocus.unfocus();
    emit(InsertDatabaseState());
    return memoryID;
  }

  // void getMemoryDataFromDatabase() async {
  //   memoryList = [];
  //   // emit(AppLoaderState());
  //   database.rawQuery('SELECT * FROM memories').then((value) {
  //     value.forEach((element) {
  //       print(element);
  //       memoryList.add(element);
  //     });
  //     emit(AddMemoryGetDatabaseState());
  //   });
  // }

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
      // saveSelectedImagesToPhoneCache();
      getMemoryImagesFromDatabase(memoryID);
      // getMemoryDataFromDatabase();
      titleFocus.unfocus();
      bodyFocus.unfocus();
    });
    emit(UpdateTitleAndBodyState());
  }

  // void deleteMemory( context, {required int id}) async {
  //   print(id);
  //   await database.rawDelete('DELETE FROM memories WHERE id = ?', [id]).then((value) {
  //     deleteAllMemoryCachedImages();
  //     Navigator.pop(context);
  //     // getMemoryDataFromDatabase();
  //   }).catchError((error) {
  //     print(error);
  //   });
  //   emit(AddMemoryDeleteOneMemoryState());
  // }
  void deleteMemory(context) {
    deleteOneItem(context, database,
        id: memoryID,
        tableName: 'memories',
        cachedImagesList: cachedImagesList,
        );
  }

  void deleteImage( {required int imageID ,required int index}) async {
    print(imageID);
    await database.rawDelete('DELETE FROM memories_images WHERE id = ?', [imageID]).then((value) {
      File('${cachedImagesList[index]['link']}').delete(recursive: true);
      cachedImagesList.removeAt(index);
      emit(DeleteOneImageState());
    }).catchError((error) {
      print(error);
    });

  }




  // void addToFavorite(){
  //   database.rawUpdate(
  //       'UPDATE memories SET is_favorite = ? , favorite_add_date = ? WHERE id = ?',
  //       [!isFavorite, DateTime.now().toString() , memoryID]).then((val){
  //     isFavorite = !isFavorite ;
  //     print('$val $isFavorite is done');
  //     emit(AddMemoryFavoriteState());
  //     // getMemoryDataFromDatabase();
  //   }).catchError((error){
  //     print(error);
  //   });
  // }
  addToFavorite() async {
    isFavorite = await favoriteFun(database, 'memories', isFavorite, memoryID);
    emit(FavoriteState());
  }

  void addNoteToSecret(context) => addToSecret(context, memoryID, 'memories');

  // void addNoteToSecret(context) {
  //   String? pass = CacheHelper.getString(key: 'secret_password');
  //   if (pass == null) {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => CreatePass(id: memoryID,table: 'memories',)));
  //   } else {
  //     Navigator.push(context,
  //         MaterialPageRoute(builder: (context) => Login(id: memoryID,table: 'memories',)));
  //   }
  // }

  @override
  Future<void> close() async{
    // database.close();
    return super.close();
  }
}
