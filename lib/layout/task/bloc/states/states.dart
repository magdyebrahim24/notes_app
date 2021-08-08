abstract class AppTaskStates {}

class AppTaskInitialState extends AppTaskStates {}
class AppTaskBuildState extends AppTaskStates {}
class AppTaskChengCheckboxState extends AppTaskStates {}
class AppTaskNewTaskState extends AppTaskStates {}
class AppTaskRemoveSubTaskState extends AppTaskStates {}
class AppTaskTimePickerState extends AppTaskStates {}
class AddTaskInsertDatabaseState extends AppTaskStates {}
class AddTaskGetSubTasksFromDatabaseState extends AppTaskStates {}
class AddTaskUpdateTitleAndBodyState extends AppTaskStates {}
class AddSubTasksIntoDatabaseState extends AppTaskStates {}
class AddSubTasksUpdateSubTaskState extends AppTaskStates {}
class DeleteTaskState extends AppTaskStates {}
class AddTaskToFavoriteState extends AppTaskStates {}
class AddNoteToSecretState extends AppTaskStates {}


