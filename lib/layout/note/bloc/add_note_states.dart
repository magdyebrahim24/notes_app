abstract class AddNoteStates {}

class AddNoteInitialState extends AddNoteStates {}

class OnBuildAddNoteState extends AddNoteStates {}

class FocusBodyChangeState extends AddNoteStates {}

class FocusTitleChangeState extends AddNoteStates {}

class OnNoteTextChangedState extends AddNoteStates {}

class OnNoteTextChangeState extends AddNoteStates {}

class InsertNewNoteState extends AddNoteStates {}

class UpdateNoteState extends AddNoteStates {}

class DeleteOneImageState extends AddNoteStates {}

class GetCachedImagesPathsFromDatabaseState extends AddNoteStates {}

class NoteFavoriteState extends AddNoteStates {}

// record states

class OpenAudioSessionState extends AddNoteStates {}

class OpenTheRecorderState extends AddNoteStates {}

class RecordAudioState extends AddNoteStates {}

class StopRecorderState extends AddNoteStates {}

class PlayAudioState extends AddNoteStates {}

class AfterPlayAudioState extends AddNoteStates {}

class StopPlayAudio extends AddNoteStates {}

class GetIndexState extends AddNoteStates {}

class AddNoteDeleteOneRecordState extends AddNoteStates {}
