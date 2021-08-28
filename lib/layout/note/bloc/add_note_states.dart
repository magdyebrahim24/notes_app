abstract class AddNoteState {}

class AddNoteInitialState extends AddNoteState {}

class OnBuildAddNoteInitialState extends AddNoteState {}

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
class AddNoteDeleteOneImageState extends AddNoteState {}
class AddNoteDeleteUnSavedImageState extends AddNoteState {}

class AddNoteAddImagesToCacheState extends AddNoteState {}

class AddNoteAddCachedImagesPathToDatabaseState extends AddNoteState {}

class AddNoteGetCachedImagesPathsFromDatabaseState extends AddNoteState {}
class AddNoteFavoriteState extends AddNoteState {}
class AddNoteToSecretState extends AddNoteState {}


class OpenAudioSessionState extends AddNoteState {}
class OpenTheRecorderState extends AddNoteState {}
class RecordAudioState extends AddNoteState {}
class StopRecorderState extends AddNoteState {}
class PlayAudioState extends AddNoteState {}
class AfterPlayAudioState extends AddNoteState {}
class StopPlayAudio extends AddNoteState {}
