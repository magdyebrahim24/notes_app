import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/layout/memories/bloc/states.dart';
import 'package:intl/intl.dart';
import 'package:undo/undo.dart';

class AddMemoryCubit extends Cubit<AppMemoryStates> {
  AddMemoryCubit() : super(AppMemoryInitialState());

  static AddMemoryCubit get(context) => BlocProvider.of(context);

  FocusNode bodyFocus = new FocusNode();
  FocusNode titleFocus = new FocusNode();
  int? memoryID;
  List memoryList=[];

  void onFocusBodyChange(){
    titleFocus.unfocus();
    bodyFocus.requestFocus();
    emit(AddMemoryFocusBodyChangeState());
  }
  void onFocusTitleChange(){
    bodyFocus.unfocus();
    titleFocus.requestFocus();
    emit(AddMemoryFocusTitleChangeState());
  }

  SimpleStack? stackController = SimpleStack<dynamic>(
    '',
    onUpdate: (val) {
      print('New Value -> $val');
    },
  );

  void clearStack() {
    stackController!.clearHistory();
    emit(AddMemoryClearStackState());
  }

  TextEditingController memoryTextController = TextEditingController();
  TextEditingController titleController = TextEditingController();


  undoFun()  {
    stackController!.undo();
    memoryTextController.text = stackController!.state;
    emit(AddMemoryUndoState());
  }

  redoFun() {
    stackController!.redo();
    memoryTextController.text = stackController!.state;
    emit(AddMemoryRedoState());

  }

  onNoteTextChanged(value){
    stackController!.modify(value);
    emit(AddMemoryOnNoteTextChangedState());
  }

  String? dateController;
  void datePicker(context){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.parse('1900-09-22'),
        lastDate: DateTime.now(),
        )
        .then((value) {
      dateController = DateFormat.yMMMd()
          .format(value!);
      emit(AppMemoryTimePickerState());
    }).catchError((error){});


  }

  List addedImages = [];
  XFile? image;
  pickImage(ImageSource src) async {
    XFile? _image = await ImagePicker().pickImage(source: src);
    if (_image != null) {
      image = _image ;
      addedImages.add(_image.path);
      emit(AddMemoryAddImageStateState());
    } else {
      print('No Image Selected');
    }
  }
  Future insertNewMemory(
      database, {
        required String title,
        required String body,
        required String memoryDate,
      }) async {
    // var db = await openDatabase('database.db');
    DateTime dateTime = DateTime.now();
    String createdDate = dateTime.toString().split(' ').first;
    String time = dateTime.toString().split(' ').last;
    String createdTime = time.toString().split('.').first;
    await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO memories (title ,body ,createdTime ,createdDate, memoryDate) VALUES ("$title","$body","$createdTime","$createdDate","$memoryDate")')
          .then((value) {
        memoryID=value;
        // saveSelectedImagesToPhoneCache(database);
        // getNoteImagesFromDatabase(database, noteId);
        getMemoryDataFromDatabase(database);
        print(value);
      }).catchError((error) {
        print(error.toString());
      });

      return Future.value(true);
    });
    titleFocus.unfocus();
    bodyFocus.unfocus();
    emit(AddMemoryInsertDatabaseState());
  }
  void getMemoryDataFromDatabase(db) async {
    memoryList = [];
    // emit(AppLoaderState());
    db.rawQuery('SELECT * FROM memories').then((value) {
      value.forEach((element) {
        print(element);
        memoryList.add(element);
      });
      emit(AddMemoryGetDatabaseState());
    });
  }

}