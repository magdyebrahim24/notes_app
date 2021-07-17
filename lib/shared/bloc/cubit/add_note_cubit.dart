
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/shared/bloc/states/add_note_states.dart';
import 'package:undo/undo.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitialState());

  static AddNoteCubit get(context) => BlocProvider.of(context);

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

  List addedImages = [];
  XFile? image;
  pickImage(ImageSource src) async {
    XFile? _image = await ImagePicker().pickImage(source: src);
    if (_image != null) {
      image = _image ;
      addedImages.add(_image.path);
      emit(AddNoteAddImageState());
    } else {
      print('No Image Selected');
    }
  }

}
