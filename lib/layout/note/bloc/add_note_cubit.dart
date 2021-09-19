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
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart' as ap;

class AddNoteCubit extends Cubit<AddNoteStates> {
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
  late Database database;
  List recordsList = [];

  bool isRecording = false;
  bool isPaused = false;
  int recordDuration = 0;
  Timer? timer;
  Timer? ampTimer;
  final audioRecorder = Record();
  Amplitude? amplitude;

  final audioPlayer = ap.AudioPlayer();
  late StreamSubscription<ap.PlayerState> playerStateChangedSubscription;
  late StreamSubscription<Duration?> durationChangedSubscription;
  late StreamSubscription<Duration> positionChangedSubscription;

  bool showPlayer = false;
  ap.AudioSource? audioSource;

  String? recordsDirectoryPath;

  onBuildAddNoteScreen(data) async {
    var db = await openDatabase('database.db');
    database = db;
    if (data != null) {
      noteId = data['id'];
      titleController.text = data['title'].toString();
      noteTextController.text = data['body'].toString();
      cachedImagesList = data['images'];
      recordsList = data['voices'];
      isFavorite = data['is_favorite'] == 1 ? true : false;
    }
    recordsDirectoryPath = await createRecordsDirectory();

    playerStateChangedSubscription =
        audioPlayer.playerStateStream.listen((state) async {
      if (state.processingState == ap.ProcessingState.completed) {
        await stopPlayerFun();
        emit(PlayerStateChangedSubscription());
      }
    });
    positionChangedSubscription = audioPlayer.positionStream.listen((position) {
      emit(PositionChangedSubscription());
    });
    durationChangedSubscription = audioPlayer.durationStream.listen((duration) {
      emit(DurationChangedSubscription());
    });

    emit(OnBuildAddNoteState());
  }

  onTextChange() {
    emit(OnNoteTextChangeState());
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

  pickMultiImageFromGallery(context) =>
      pickMultiImagesFromGallery(pickedGalleryImagesList).then((value) async {
        if (noteId == null)
          await insertNewNote(context,
              title: titleController.text, body: noteTextController.text);

        savePickedImages();
      });

  void savePickedImages() => savePickedImagesToPhoneCacheAndDataBase(
              database,
              pickedGalleryImagesList,
              noteId,
              'notes_images',
              'note_id',
              'notes_images')
          .then((value) {
        pickedGalleryImagesList = [];
        getNoteImagesFromDatabase(noteId);
      });

  void getNoteImagesFromDatabase(id) {
    cachedImagesList = [];
    database.rawQuery(
        'SELECT * FROM notes_images WHERE note_id = ?', [id]).then((value) {
      cachedImagesList = makeModifiableResults(value);
      emit(GetCachedImagesPathsFromDatabaseState());
    });
  }

  Future insertNewNote(
    context, {
    required String title,
    required String body,
  }) async {
    String createdDate = TimeAndDate.getDate();
    String createdTime = TimeAndDate.getTime(context);
    await database.transaction((txn) async {
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
    emit(InsertNewNoteState());
    return noteId;
  }

  void deleteNote(context) {
    deleteOneItem(context, database,
        id: noteId,
        tableName: 'notes',
        cachedImagesList: cachedImagesList,
        recordsList: []);
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
      emit(DeleteOneImageState());
    }).catchError((error) {
      print(error);
    });
  }

  favFun() async {
    isFavorite = await favoriteFun(database, 'notes', isFavorite, noteId);
    emit(NoteFavoriteState());
  }

  void addNoteToSecret(context) => addToSecret(context, noteId, 'notes');

  onSave(context) {
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
// record  functions

  Future<void> start() async {
    try {
      if (await audioRecorder.hasPermission()) {
        await getNewRecordPath(); // to get new path for next recording
        await audioRecorder.start(path: newRecordPath.toString());
        bool _isRecording = await audioRecorder.isRecording();
        isRecording = _isRecording;
        recordDuration = 0;
        emit(StartRecordingState());

        startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> stop(context) async {
    timer?.cancel();
    ampTimer?.cancel();
    final path = await audioRecorder.stop();

    isRecording = false;
    await saveRecordAfterStop(context, path);
    getRecordsFromDatabase(noteId);
    emit(StopRecordingState());
  }

  Future<void> pause() async {
    timer?.cancel();
    ampTimer?.cancel();
    await audioRecorder.pause();
    isPaused = true;
    emit(PauseRecordingState());
  }

  Future<void> resume() async {
    startTimer();
    await audioRecorder.resume();
    isPaused = false;
    emit(ResumeRecordingState());
  }

  void startTimer() {
    timer?.cancel();
    ampTimer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordDuration++;
      emit(StartTimerState());
    });

    ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      amplitude = await audioRecorder.getAmplitude();
      emit(AmpTimerState());
    });
  }
// -------------------------------------------------------------------------------------

  //  player functions

  int? recordIndex;
  void checkSelectedPlayerItem(i) {
    recordIndex = i;
    emit(CheckSelectedPlayerItem());
  }

  Future<void> playPlayer(path) async {
    await audioPlayer.setAudioSource(path!);
    return audioPlayer.play();
  }

  Future<void> pausePlayer() {
    return audioPlayer.pause();
  }

  Future<void> stopPlayerFun() async {
    await audioPlayer.stop();
    return audioPlayer.seek(const Duration(milliseconds: 0));
  }

  Future<void> deleteRecord({required int recordID, required int index}) async {
    await database.rawDelete('DELETE FROM voices WHERE id = ?', [recordID]);
    await File('${recordsList[index]['link']}').delete(recursive: true);
    await recordsList.removeAt(index);
    getRecordsFromDatabase(noteId);
    // emit(AddNoteDeleteOneRecordState());

    emit(DeleteRecordState());
  }

  String newRecordPath = '';
  int lastRecordId = 0;

  // ----------------------------------------------------------------------------------------------

  createRecordsDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // create new folder
    Directory directoryPath =
        await Directory('$appDocPath/recorders').create(recursive: true);
    getNewRecordPath();
    return directoryPath.path;
  }

  Future<void> getNewRecordPath() async {
    await database
        .rawQuery('SELECT id FROM voices ORDER BY id DESC LIMIT 1')
        .then((value) {
      lastRecordId =
          value.length != 0 ? int.parse(jsonEncode(value[0]['id'])) : 0;
      newRecordPath = '$recordsDirectoryPath/record$lastRecordId.m4a';
    });
  }

  Future<void> saveRecordAfterStop(context, path) async {
    if (noteId == null)
      insertNewNote(context,
          title: titleController.text, body: noteTextController.text);

    recordsList.add({'id': lastRecordId + 1, 'link': path.toString()});

    await database.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO voices (link ,note_id) VALUES ("$path",$noteId)');
    });
  }

  void getRecordsFromDatabase(id) {
    database
        .rawQuery('SELECT * FROM voices WHERE note_id = ?', [id]).then((value) {
      print(
          'Records DB -------------------------------- -----------------------');
      value.forEach((element) {
        print(element);
      });
      print(
          'List List -------------------------------- -----------------------');

      recordsList.forEach((element) {
        print(element);
      });
      emit(StopRecorderState());
    });
  }

  // final theSource = AudioSource.microphone;

  // recorder code

  // Codec _codec = Codec.aacMP4;

  // FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  // FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  // bool _mPlayerIsInited = false;
  // bool _mRecorderIsInited = false;

  // void initState() {
  // mPlayer!.openAudioSession().then((value) {
  //   _mPlayerIsInited = true;
  //   emit(OpenAudioSessionState());
  // });

  // openTheRecorder().then((value) {
  //   _mRecorderIsInited = true;
  //   emit(OpenTheRecorderState());
  // });
  // }
//
//   Future<void> openTheRecorder() async {
//     if (!kIsWeb) {
//       var status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         throw RecordingPermissionException('Microphone permission not granted');
//       }
//     }
//     await mRecorder!.openAudioSession();
//     if (!await mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
//       _codec = Codec.opusWebM;
//       mPath = 'tau_file.webm';
//       if (!await mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
//         _mRecorderIsInited = true;
//         return;
//       }
//     }
//     _mRecorderIsInited = true;
//   }
//
//   // ----------------------  Here is the code for recording and playback -------
//
//   void record() async {
//     print(mPath.toString());
//     mRecorder!
//         .startRecorder(
//       toFile: mPath,
//       codec: _codec,
//       audioSource: theSource,
//     )
//         .then((value) {
//       emit(RecordAudioState());
//     });
//   }
//
//   void stopRecorder(context) async {
//     print('stop');
//     await mRecorder!.stopRecorder().then((url) async {
//       // var url = value;
//       if (noteId == null)
//         insertNewNote(context,
//             title: titleController.text, body: noteTextController.text);
//
//       await database.transaction((txn) async {
//         txn.rawInsert(
//             'INSERT INTO voices (link ,note_id) VALUES ("$url",$noteId)');
//       }).then((value) {
//         print(url.toString() + ' added success');
//       });
//       print(url.toString());
//       getRecordsFromDatabase(noteId);
//     });
//   }
//
//   List recordsList = [];
//   void getRecordsFromDatabase(id) {
//     recordsList = [];
//     database
//         .rawQuery('SELECT * FROM voices WHERE note_id = ?', [id]).then((value) {
//       value.forEach((element) {
//         recordsList = value;
//         print(element);
//       });
//       emit(StopRecorderState());
//     });
//   }
//
//   void play(path) async {
//     print(path);
//
//     mPlayer!
//         .startPlayer(
//             fromURI: path,
//             //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
//             whenFinished: () {
//               emit(PlayAudioState());
//             })
//         .then((value) {
//       emit(AfterPlayAudioState());
//     });
//   }
//
//   void stopPlayer() {
//     mPlayer!.stopPlayer().then((value) {
//       emit(StopPlayAudio());
//     });
//   }
//
// // ----------------------------- UI --------------------------------------------
//   getRecorderFn(context) {
//     if (!_mRecorderIsInited || !mPlayer!.isStopped) {
//       return null;
//     }
//     return mRecorder!.isStopped ? record() : stopRecorder(context);
//   }
//
//   int? item;
//   getPlaybackFn(path, index) {
//     item = index;
//     emit(GetIndexState());
//     if (!_mPlayerIsInited) {
//       return null;
//     }
//
//     return mPlayer!.isStopped ? play(path) : stopPlayer();
//   }
//
//   void deleteSavedRecord({required int recordID, required int index}) async {
//     await database.rawDelete(
//         'DELETE FROM voices WHERE id = ?', [recordID]).then((value) async {
//       File('${recordsList[index]['link']}').delete(recursive: true);
//       await recordsList.removeAt(index);
//       // getRecordsFromDatabase(noteId);
//       emit(AddNoteDeleteOneRecordState());
//     }).catchError((error) {
//       print(error);
//     });
//   }
//

  @override
  Future<void> close() {
    titleController.dispose();
    noteTextController.dispose();
    titleFocus.dispose();
    bodyFocus.dispose();

    timer?.cancel();
    ampTimer?.cancel();
    audioRecorder.dispose();

    playerStateChangedSubscription.cancel();
    positionChangedSubscription.cancel();
    durationChangedSubscription.cancel();
    audioPlayer.dispose();

    return super.close();
  }
}
