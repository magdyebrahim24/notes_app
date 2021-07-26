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

  DateTime dateTime=DateTime.now();
  FocusNode bodyFocus = new FocusNode();
  FocusNode titleFocus = new FocusNode();

  void onFocusBodyChange(){
    titleFocus.unfocus();
    bodyFocus.requestFocus();
    emit(AddNoteFocusBodyChangeState());
  }
  void onFocusTitleChange(){
    bodyFocus.unfocus();
    titleFocus.requestFocus();
    emit(AddNoteFocusTitleChangeState());
  }

  SimpleStack? stackController = SimpleStack<dynamic>(
    '',
    onUpdate: (val) {
      print('New Value -> $val');
    },
  );

  void clearStack() {
    stackController!.clearHistory();
    emit(AddNoteClearStackState());
  }

  TextEditingController noteTextController = TextEditingController();


  undoFun()  {
      stackController!.undo();
      noteTextController.text = stackController!.state;
      emit(AddNoteUndoState());
  }

  redoFun() {
      stackController!.redo();
      noteTextController.text = stackController!.state;
      emit(AddNoteRedoState());

  }

  onNoteTextChanged(value){
    stackController!.modify(value);
    emit(AddNoteOnNoteTextChangedState());
  }

  List selectedGalleryImagesList = [];
  XFile? image;
  pickImage(ImageSource src) async {
    XFile? _image = await ImagePicker().pickImage(source: src);
    if (_image != null) {
      image = _image ;
      selectedGalleryImagesList.add(_image.path);
      emit(AddNoteAddImageState());
    } else {
      print('No Image Selected');
    }
  }

// Future saveImagesToPhone() async{
  //
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   String appDocPath = appDocDir.path;
  //   XFile? _currentImageToSave ;
  //
  //   print('pre loop');
  //
  //   new File('$appDocPath/notes_images').create(recursive: true)
  //       .then((File directoryPath) {
  //
  //     for(int index = 0 ; index < selectedGalleryImagesList.length ; index++ ){
  //       String imageName = selectedGalleryImagesList[index].split('/').last;
  //       final String filePath = '${directoryPath.path}/$imageName';
  //       _currentImageToSave = XFile(selectedGalleryImagesList[index]);
  //       final  savedImage =  _currentImageToSave!.saveTo(filePath);
  //       print('inside loop');
  //
  //       print('image saved success $savedImage .');
  //     }    });
  //   print(appDocPath);
  //   print('after loop');
  //
  //
  // }
  Future saveImagesToPhone() async{
    // get app path
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // create new folder
    Directory directoryPath = await Directory('$appDocPath/notes_images').create(recursive: true);
    XFile? _currentImageToSave ;
    print('pre loop');
    for(int index = 0 ; index < selectedGalleryImagesList.length ; index++ ){
      String imageName = selectedGalleryImagesList[index].split('/').last;
      final String filePath = '${directoryPath.path}/$imageName';
      _currentImageToSave = XFile(selectedGalleryImagesList[index]);
       await _currentImageToSave.saveTo(filePath);
      print('inside loop');
    }
    print('after loop');

    var listOfFiles = await directoryPath.list(recursive: true).toList();
    print(listOfFiles[0].path );
  }

  int? notId;
  Future insertDatabase(
      database,
          {
        required String title,
        required String body,
        required String image,
        required String voice,
      }
      ) async{
    String createdTime = dateTime.toString().split(' ').first;
    String time =dateTime.toString().split(' ').last;
  String createdDate=time.toString().split('.').first;
    await database!.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO notes (title ,body ,image ,voice ,createdTime ,createdDate) VALUES ("$title","$body","$image","$voice","$createdTime","$createdDate")')
          .then((value) {
            notId=value;
            print(value);
        emit(AddNoteInsertDatabaseState());
      }).catchError((error)  {print(error.toString());});
      return Future.value(false);
    });
  }

  void deleteData(
  database,context,{

    required int id
  }
      ){
    database!.rawDelete('DELETE FROM notes WHERE id = ?', [id])
        .then((value)  {
          Navigator.pop(context);
          // print('dddddddd');
      // getDataFromDatabase(database);
      // emit(AppDeleteDatabaseState());
    }).ctactError((error){print(error);});
  }
}
