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

  TextEditingController noteTextController = TextEditingController();


  undoFun()  {
    stackController!.undo();
    noteTextController.text = stackController!.state;
    emit(AddMemoryUndoState());
  }

  redoFun() {
    stackController!.redo();
    noteTextController.text = stackController!.state;
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
}