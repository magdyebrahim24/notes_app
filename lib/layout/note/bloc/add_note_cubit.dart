import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';
import 'package:notes_app/shared/components/reusable/time_date.dart';
import 'package:notes_app/shared/functions/functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitialState());

  static AddNoteCubit get(context) => BlocProvider.of(context);

  TextEditingController noteTextController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  FocusNode bodyFocus = new FocusNode();
  FocusNode titleFocus = new FocusNode();
  List pickedGalleryImagesList = [];
  List cachedImagesList = [];
  int? noteId;
  bool isFavorite = false;

  String? recordsDirectoryPath;

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
    getRecordsFromDatabase(noteId);
    recordsDirectoryPath = await createRecordsDirectory();
    initState();
    emit(OnBuildAddNoteInitialState());
  }

  onTextChange() {
    emit(OnNoteTextChangeState());
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

  pickMultiImageFromGallery(context) =>
      pickMultiImagesFromGallery(pickedGalleryImagesList).then((value) async {
        if (noteId == null) await insertNewNote(context, title: titleController.text, body: noteTextController.text);

        savePickedImages();
      });

  void savePickedImages() => savePickedImagesToPhoneCacheAndDataBase(database, pickedGalleryImagesList, noteId, 'notes_images', 'note_id', 'notes_images')
          .then((value) {
        pickedGalleryImagesList = [];
        getNoteImagesFromDatabase(noteId);
      });

  void getNoteImagesFromDatabase(id) {
    cachedImagesList = [];
    database.rawQuery(
        'SELECT * FROM notes_images WHERE note_id = ?', [id]).then((value) {
      cachedImagesList = makeModifiableResults(value);
      emit(AddNoteGetCachedImagesPathsFromDatabaseState());
    });
  }

  Future insertNewNote(
    context, {
    required String title,
    required String body,
  }) async {
    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);
    await database.transaction((txn) async{
      txn
          .rawInsert(
              'INSERT INTO notes (title ,body ,createdTime ,createdDate,type) VALUES ("$title","$body","$createdTime","$createdDate","note")')
          .then((value) {
        noteId = value;
      }).catchError((error) {
        print(error.toString());
      });
    });
    titleFocus.unfocus();
    bodyFocus.unfocus();
    emit(AddNoteInsertDatabaseState());
    return noteId;
  }

  void deleteNote(context) {
    deleteOneItem(context, database,
        id: noteId,
        tableName: 'notes',
        cachedImagesList: cachedImagesList,
        recordsList: recordsList);
  }

  void updateNote(context,
      {required String title, required String body, required int id}) async {
    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);
    database.rawUpdate(
        'UPDATE notes SET title = ? , body = ? , createdTime = ? ,createdDate = ? WHERE id = ?',
        ['$title', '$body', '$createdTime', '$createdDate', id]).then((value) {
      titleFocus.unfocus();
      bodyFocus.unfocus();
    });
    emit(UpdateNoteState());
  }

  void deleteSavedImage({required int imageID, required int index}) async {
    print(imageID);
    await database.rawDelete(
        'DELETE FROM notes_images WHERE id = ?', [imageID]).then((value) {
      File('${cachedImagesList[index]['link']}').delete(recursive: true);
      cachedImagesList.removeAt(index);
      emit(AddNoteDeleteOneImageState());
    }).catchError((error) {
      print(error);
    });
  }

  favFun() async {
    isFavorite = await favoriteFun(database, 'notes', isFavorite, noteId);
    emit(NoteFavoriteState());
  }

  void addNoteToSecret(context) => addToSecret(context, noteId, 'notes');

  onSave(context){
    if (noteId == null) {
      insertNewNote(
        context,
        title: titleController.text,
        body: noteTextController.text,
      );
    } else {
      updateNote(context,
          id: noteId!,
          body: noteTextController.text,
          title: titleController.text);
    }
  }
// ---------------------------------------------------------------------------------------------
// record functions

  createRecordsDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // create new folder
    Directory directoryPath =
        await Directory('$appDocPath/recorders').create(recursive: true);
    return directoryPath.path;
  }

  newRecord(context) async {
    int id = 0;
    await database.rawQuery('select MAX(id) from voices').then((value) {
      id = int.parse(jsonEncode(value[0]['MAX(id)'] ?? 0));
    });

    mPath = '$recordsDirectoryPath/record$id.mp4';

    getRecorderFn(context);
  }

  final theSource = AudioSource.microphone;

  // recorder code

  Codec _codec = Codec.aacMP4;
  String mPath = '';
  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;

  void initState() {
    mPlayer!.openAudioSession().then((value) {
      _mPlayerIsInited = true;
      emit(OpenAudioSessionState());
    });

    openTheRecorder().then((value) {
      _mRecorderIsInited = true;
      emit(OpenTheRecorderState());
    });
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await mRecorder!.openAudioSession();
    if (!await mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      mPath = 'tau_file.webm';
      if (!await mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() async {
    print(mPath.toString());
    mRecorder!
        .startRecorder(
      toFile: mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      emit(RecordAudioState());
    });
  }

  void stopRecorder(context) async {
    print('stop');
    await mRecorder!.stopRecorder().then((url) async {
      // var url = value;
      if (noteId == null) insertNewNote(context, title: titleController.text, body: noteTextController.text);

      await database.transaction((txn) async {
        txn.rawInsert(
            'INSERT INTO voices (link ,note_id) VALUES ("$url",$noteId)');
      }).then((value) {
        print(url.toString() + ' added success');
      });
      print(url.toString());
      getRecordsFromDatabase(noteId);
    });
  }

  List recordsList = [];
  void getRecordsFromDatabase(id) {
    recordsList = [];
    database
        .rawQuery('SELECT * FROM voices WHERE note_id = ?', [id]).then((value) {
      value.forEach((element) {
        recordsList = value;
        print(element);
      });
      emit(StopRecorderState());
    });
  }

  void play(path) async {
    print(path);

    mPlayer!
        .startPlayer(
            fromURI: path,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              emit(PlayAudioState());
            })
        .then((value) {
      emit(AfterPlayAudioState());
    });
  }

  void stopPlayer() {
    mPlayer!.stopPlayer().then((value) {
      emit(StopPlayAudio());
    });
  }

// ----------------------------- UI --------------------------------------------
  getRecorderFn(context) {
    if (!_mRecorderIsInited || !mPlayer!.isStopped) {
      return null;
    }
    return mRecorder!.isStopped ? record() : stopRecorder(context);
  }

  int? item;
  getPlaybackFn(path, index) {
    item = index;
    emit(GetIndexState());
    if (!_mPlayerIsInited) {
      return null;
    }

    return mPlayer!.isStopped ? play(path) : stopPlayer();
  }

  void deleteSavedRecord({required int recordID, required int index}) async {
    await database.rawDelete(
        'DELETE FROM voices WHERE id = ?', [recordID]).then((value) async {
      File('${recordsList[index]['link']}').delete(recursive: true);
      await recordsList.removeAt(index);
      // getRecordsFromDatabase(noteId);
      emit(AddNoteDeleteOneRecordState());
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Future<void> close() {
    mPlayer!.closeAudioSession();
    mPlayer = null;

    mRecorder!.closeAudioSession();
    mRecorder = null;
    titleController.dispose();
    noteTextController.dispose();
    titleFocus.dispose();
    bodyFocus.dispose();
    // onSave(context);
    return super.close();
  }
}
