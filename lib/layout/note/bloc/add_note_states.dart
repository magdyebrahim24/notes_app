abstract class AddNoteStates {}

class AddNoteInitialState extends AddNoteStates {}

class OnBuildAddNoteState extends AddNoteStates {}
class PlayerStateChangedSubscription extends AddNoteStates {}
class PositionChangedSubscription extends AddNoteStates {}
class DurationChangedSubscription extends AddNoteStates {}

class FocusBodyChangeState extends AddNoteStates {}

class FocusTitleChangeState extends AddNoteStates {}

class OnNoteTextChangedState extends AddNoteStates {}

class OnNoteTextChangeState extends AddNoteStates {}

class InsertNewNoteState extends AddNoteStates {}

class UpdateNoteState extends AddNoteStates {}

class DeleteOneImageState extends AddNoteStates {}

class GetCachedImagesPathsFromDatabaseState extends AddNoteStates {}

class NoteFavoriteState extends AddNoteStates {}
class OnCloseSave extends AddNoteStates {}

// ---------------------------------------------------------

class StartRecordingState extends AddNoteStates {}
class StopRecordingState extends AddNoteStates {}
class PauseRecordingState extends AddNoteStates {}
class ResumeRecordingState extends AddNoteStates {}
class StartTimerState extends AddNoteStates {}
class AmpTimerState extends AddNoteStates {}
class DeleteRecordState extends AddNoteStates {}
class GetRecordPath extends AddNoteStates {}
class CheckSelectedPlayerItem extends AddNoteStates {}

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
