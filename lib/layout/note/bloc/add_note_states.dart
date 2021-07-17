
abstract class AddNoteState{}

class AddNoteInitialState extends AddNoteState {}

class AddNoteClearStackState extends AddNoteState {}

class AddNoteUndoState extends AddNoteState {}

class AddNoteShowUndoRedoState extends AddNoteState {}
class AddNoteFocusBodyChangeState extends AddNoteState {}
class AddNoteFocusTitleChangeState extends AddNoteState {}

class AddNoteRedoState extends AddNoteState {}

class AddNoteOnNoteTextChangedState extends AddNoteState {}

class AddNoteAddImageState extends AddNoteState {}



