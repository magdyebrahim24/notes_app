abstract class AddNoteState {}

class AddNoteInitialState extends AddNoteState {}

class AddNoteClearStackState extends AddNoteState {}

class AddNoteUndoState extends AddNoteState {}

class AddNoteShowUndoRedoState extends AddNoteState {}

class AddNoteFocusBodyChangeState extends AddNoteState {}

class AddNoteFocusTitleChangeState extends AddNoteState {}

class AddNoteRedoState extends AddNoteState {}

class AddNoteOnNoteTextChangedState extends AddNoteState {}
class AddNoteTitleChangedState extends AddNoteState {}

class AddNoteAddImageState extends AddNoteState {}

class AddNoteInsertDatabaseState extends AddNoteState {}

class AddNoteGetDatabaseState extends AddNoteState {}

class AddNoteUpdateTitleAndBodyState extends AddNoteState {}

class AddNoteDeleteOneNoteState extends AddNoteState {}

class AddNoteAddImagesToCacheState extends AddNoteState {}

class AddNoteAddCachedImagesPathToDatabaseState extends AddNoteState {}

class AddNoteGetCachedImagesPathsFromDatabaseState extends AddNoteState {}
