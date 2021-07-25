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

//
//   final pickedFile = await picker.getImage(source: ImageSource.camera);
//   _image = File(pickedFile.path);
//
// // getting a directory path for saving
//   final Directory extDir = await getApplicationDocumentsDirectory();
//   String dirPath = extDir.path;
//   final String filePath = '$dirPath/image.png';
//
// // copy the file to a new path
//   final File newImage = await _image.copy(filePath);
//   setState(() {
//   if (pickedFile != null) {
//   _image = newImage;
//   } else {
//   print('No image selected.');
//   }
  // });

}
