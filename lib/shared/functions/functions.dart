import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/verify/create_pass.dart';
import 'package:notes_app/layout/verify/login.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:path_provider/path_provider.dart';


// fun to convert RawQuery type to List<Map<String, dynamic>>
List<Map<String, dynamic>> makeModifiableResults(
    List<Map<String, dynamic>> results) {
  // Generate modifiable
  return List<Map<String, dynamic>>.generate(
      results.length, (index) => Map<String, dynamic>.from(results[index]),
      growable: true);
}

// fun to assign images and subTasks to notes and memories and tasks
List<Map<String, dynamic>> assignSubListToData(List<Map<String, dynamic>> data,
    List subData, String subDataKey, String subDataId,{List? voices,String? voiceKey,String? voiceId,}) {
  List<Map<String, dynamic>> dataModified = makeModifiableResults(data);
  List<Map<String, dynamic>> sortedSubData = [];
  List<Map<String, dynamic>> sortedVoicesData = [];
  Map<String, dynamic> oneDataItem = {};
  Map<String, dynamic> oneVoicesItem = {};
  List<Map<String, dynamic>> allDataWithSubData = [];

  for (int i = 0; i < dataModified.length; i++) {
    sortedSubData = [];
    oneDataItem = dataModified[i];
    oneDataItem.putIfAbsent(subDataKey, () => []);
    for (int y = 0; y < subData.length; y++) {
      if (dataModified[i]['id'] == subData[y][subDataId]) {
        sortedSubData.add(subData[y]);
      }
    }
    if (sortedSubData.isNotEmpty)
      oneDataItem.update(subDataKey, (dynamic val) => sortedSubData);
    if(voices!=null){
      sortedVoicesData = [];
      oneDataItem.putIfAbsent(voiceKey!, () => []);
      for (int y = 0; y < voices.length; y++) {
        if (dataModified[i]['id'] == voices[y][voiceId]) {
          sortedVoicesData.add(voices[y]);
        }
      }
      if (sortedVoicesData.isNotEmpty)
        oneDataItem.update(voiceKey, (dynamic val) => sortedVoicesData);
    }
    allDataWithSubData.add(oneDataItem);
  }


  return allDataWithSubData;
}

// pick single image function
void pickImage(ImageSource src, addToList, emitFun) {
  ImagePicker().pickImage(source: src).then((value) {
    if (value != null) {
      addToList.add(value.path);
      emitFun();
    }
  });
}

// pick multi images from gallery function
Future pickMultiImagesFromGallery(addToList) async {
  await ImagePicker().pickMultiImage().then((value) {
    if (value != null) {
      value.forEach((element) {
        addToList.add({'link': element.path});
      });
    }
  });
}

Future savePickedImagesToPhoneCacheAndDataBase(database, listOfPickedImages, id,
    String tableName, String keyName, String folderName) async {
  // get app path
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  // create new folder
  Directory directoryPath =
      await Directory('$appDocPath/$folderName').create(recursive: true);

  XFile? _currentImageToSave;
  List cachedImagesPaths = [];
  for (int index = 0; index < listOfPickedImages.length; index++) {
    String imageName = listOfPickedImages[index]['link'].split('/').last;
    final String filePath = '${directoryPath.path}/$imageName';
    _currentImageToSave = XFile(listOfPickedImages[index]['link']);
    await _currentImageToSave.saveTo(filePath);
    cachedImagesPaths.add(filePath);
  }
  listOfPickedImages = [];
  // save images paths to database
  await database.transaction((txn) {
    for (int i = 0; i < cachedImagesPaths.length; i++) {
      txn
          .rawInsert(
              'INSERT INTO $tableName (link ,$keyName) VALUES ("${cachedImagesPaths[i]}","$id")')
          .catchError((error) {
        print(error.toString());
      });
    }
    return Future.value(true);
  });
}

// delete item [ note , memory , task ]
Future deleteOneItem(context, database,
    {required int? id,
    cachedImagesList,
    required tableName,
    recordsList}) async {
  await database.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]).then(
      (value) async {
    // delete images from database then delete from cache
    if (tableName == 'notes' || tableName == 'memories') {
      // delete images from phone cache
      for (int i = 0; i < cachedImagesList.length; i++) {
        await File('${cachedImagesList[i]['link']}').delete(recursive: true);
      }
      // delete all notes cached records
      if (tableName == 'notes') {
        for (int i = 0; i < recordsList.length; i++) {
          await File('${recordsList[i]['link']}').delete(recursive: true);
        }
      }
    }
    Navigator.pop(context);
  }).catchError((error) {
    print(error);
  });
}

Future<bool> favoriteFun(database, tableName, isFavorite, id) async {
  await database.rawUpdate(
      'UPDATE $tableName SET is_favorite = ? , favorite_add_date = ? WHERE id = ?',
      [!isFavorite ? 1 : 0, DateTime.now().toString(), id]).catchError((error) {
    print(error);
  });
  isFavorite = !isFavorite;
  return isFavorite;
}

void itemFavoriteFun(context, database,
    {isFavorite, noteId, tableName, isFavoriteItem, index}) {
  database!.rawUpdate(
      'UPDATE $tableName SET is_favorite = ? , favorite_add_date = ? WHERE id = ?',
      [!isFavorite, DateTime.now().toString(), noteId]).then((val) {
    List<Map<String, dynamic>> temp = isFavoriteItem;
    Map<String, dynamic> item = temp[index];
    item['is_favorite'] = !isFavorite == true ? 1 : 0;
    isFavoriteItem[index] = item;

    // print('$val $isFavorite is done');
    // emit(AddToFavoriteState());
    Navigator.pop(context);
  }).catchError((error) {
    print(error);
  });
}

void addToSecret(context, id, tableName) {
  String? pass = CacheHelper.getString(key: 'secret_password');
  if (pass == null) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreatePass(
                  id: id,
                  table: tableName,
                )));
  } else {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Login(
                  id: id,
                  table: tableName,
                )));
  }
}
