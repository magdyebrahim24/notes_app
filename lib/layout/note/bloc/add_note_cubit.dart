import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/shared/components/reusable/time_date.dart';
import 'package:notes_app/verify/create_pass.dart';
import 'package:notes_app/verify/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:undo/undo.dart';
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
  List selectedGalleryImagesList = [];
  List cachedImagesList = [];
  int? noteId;
  List noteList = [];
  bool isFavorite = false;

  String? recordsDirectoryPath ;

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
    recordsDirectoryPath = await createRecordsDirectory();
    initState();
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
      cachedImagesList = value;
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

  void deleteSavedImage({required int imageID, required int index}) async {
    print(imageID);
    await database.rawDelete(
        'DELETE FROM notes_images WHERE id = ?', [imageID]).then((value) {
      File('${cachedImagesList[index]['link']}').delete(recursive: true);
      cachedImagesList.removeAt(index);
      // getNoteImagesFromDatabase(imageID);
      emit(AddNoteDeleteOneImageState());
    }).catchError((error) {
      print(error);
    });
  }

  void deleteUnSavedImage({required int index}) async {
    selectedGalleryImagesList.removeAt(index);
    emit(AddNoteDeleteUnSavedImageState());
  }

  void addToFavorite() {
    database.rawUpdate(
        'UPDATE notes SET is_favorite = ? , favorite_add_date = ? WHERE id = ?',
        [!isFavorite, DateTime.now().toString(), noteId]).then((val) {
      isFavorite = !isFavorite;
      print('$val $isFavorite is done');
      emit(AddNoteFavoriteState());
      getNoteDataFromDatabase();
    }).catchError((error) {
      print(error);
    });
  }

  void addToSecret(context) {
    String? pass = CacheHelper.getString(key: 'secret_password');
    if (pass == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreatePass(
                    id: noteId,
                    table: 'notes',
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Login(
                    id: noteId,
                    table: 'notes',
                  )));
    }
  }

  createRecordsDirectory() async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // create new folder
    Directory directoryPath =
        await Directory('$appDocPath/recorders').create(recursive: true);
    return directoryPath.path;
  }



  newRecord(context) async{
    int id = 0;
    await database.rawQuery('select MAX(id) from voices').then((value) {
      id = int.parse(jsonEncode(value[0]['MAX(id)'] ?? 0));
    });

    _mPath = '$recordsDirectoryPath/record$id.mp4';

    getRecorderFn(context);



  }

  final theSource = AudioSource.microphone;

  // recorder code

  Codec _codec = Codec.aacMP4;
  String _mPath = '' ;
  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

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
      _mPath = 'tau_file.webm';
      if (!await mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record()  {
    print(_mPath.toString());
    mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      emit(RecordAudioState());
    });
  }

  void stopRecorder(context) async {
    print('stop');
    await mRecorder!.stopRecorder().then((url) {
      // var url = value;
      if(noteId == null)
        insertNewNote(context, title: '', body: '');


      database.transaction((txn) async{
        txn
            .rawInsert(
            'INSERT INTO voices (link ,note_id) VALUES ("$url",$noteId)');}).then((value) {
        print(url.toString() + ' added success');

      });
      print(url.toString());
      _mplaybackReady = true;
      emit(StopRecorderState());
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        mRecorder!.isStopped &&
        mPlayer!.isStopped);
    mPlayer!
        .startPlayer(
            fromURI: _mPath,
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

  getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !mRecorder!.isStopped) {
      return null;
    }
    return mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  Future<void> close() {
    mPlayer!.closeAudioSession();
    mPlayer = null;

    mRecorder!.closeAudioSession();
    mRecorder = null;
    return super.close();
  }
}
