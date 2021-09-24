import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
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
List<Map<String, dynamic>> assignSubListToData(
  List<Map<String, dynamic>> data,
  List subData,
  String subDataKey,
  String subDataId, {
  List? voices,
  String? voiceKey,
  String? voiceId,
}) {
  List<Map<String, dynamic>> dataModified = makeModifiableResults(data);
  List<Map<String, dynamic>> sortedSubData = [];
  List<Map<String, dynamic>> sortedVoicesData = []; // ----
  Map<String, dynamic> oneDataItem = {};
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

    if (voices != null) {
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
  showToast('Deleted Successfully');
}

Future<bool> favoriteFun(context, database, tableName, isFavorite, id, isSecret,
    {insideSecretHome = false}) async {
  if (isSecret == 1) {
    if (insideSecretHome) {
      await database.rawUpdate(
          'UPDATE $tableName SET is_favorite = ? , favorite_add_date = ? WHERE id = ?',
          [!isFavorite ? 1 : 0, DateTime.now().toString(), id]);
      isFavorite = !isFavorite;
    }
    else {
      // show dialog
      await warmAddSecretToFav(context, () async {
        await database.rawUpdate(
            'UPDATE $tableName SET is_secret = ? WHERE id = ?', [0, id]);
        await database.rawUpdate(
            'UPDATE $tableName SET is_favorite = ? , favorite_add_date = ? WHERE id = ?',
            [!isFavorite ? 1 : 0, DateTime.now().toString(), id]);
        isFavorite = !isFavorite;
        Navigator.pop(context);
        Navigator.pop(context);
        showToast(isFavorite ? 'Add to Favorite' : 'Removed from Favorite');
      });
    }
    return isFavorite;
  } else {
    await database.rawUpdate(
        'UPDATE $tableName SET is_favorite = ? , favorite_add_date = ? WHERE id = ?',
        [
          !isFavorite ? 1 : 0,
          DateTime.now().toString(),
          id
        ]).catchError((error) {
      print(error);
    });
    isFavorite = !isFavorite;
    showToast(isFavorite ? 'Add to Favorite' : 'Removed from Favorite');
    return isFavorite;
  }
}

Future<void> warmAddSecretToFav(context, addToFavoriteFun) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Warning !!',
          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 22),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Put this item in favorite?',
                style:
                    Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
              ),
              Text(
                'Putting this item in favorite will delete it from secret.',
                style:
                    Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(
            width: 15,
          ),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            color: Theme.of(context).colorScheme.secondary,
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: addToFavoriteFun,
          ),
          SizedBox(
            width: 10,
          )
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
    },
  );
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

void showToast(text) {
  BotToast.showText(text: text, align: Alignment(0, .55));
}
