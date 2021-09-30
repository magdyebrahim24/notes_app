import 'languages.dart';

class LanguageEn extends Languages {
  @override
  Map get setting => {
        'title': 'Setting',
        'version': 'Version',
        'about': 'About',
        'termsOfUse': 'Terms Of Use',
        'shareApp': 'Share App',
        'language': 'Language',
        'darkMode': 'Dark Mode',
        'contact': 'Contact Us',
      };

  Map get home => {
        'notes': 'Notes',
        'tasks': 'Tasks',
        'memories': 'Memories ',
      };

  Map get search => {
        'search': 'Search',
        'searchResult': 'No Result For',
        'note': 'Note',
        'task': 'Task',
        'memory': 'Memory',
      };

  Map get drawer => {
        'notes': 'Notes',
        'tasks': 'Tasks',
        'memories': 'Memories',
        'favorite': 'Favorite',
        'secret': 'Secret',
        'setting': 'Setting',
      };
  Map get secret => {
        'createPass': 'Create Password',
        'confirmPass': 'Confirm Password',
        'enterPass': 'Enter Password',
        'confirmError': 'Passwords isn\'t identical, try again',
        'error': 'Password is in correct, try again',
        'updatePass': 'Update Password'
      };
  Map get addTask => {
        'title': 'Title',
        'titleBody': 'Your title...',
        'titleError': 'task title can\'t be empty',
        'date': 'Date',
        'dateError': 'date required',
        'time': 'Time',
        'timeError': 'time required',
        'addSubTask': 'Add SubTask',
        'bodySubTask': 'write subtask',
        'bodySubTaskError': 'can\'t be empty',
      };
  Map get alertBottomSheetForAddItemInFavorite => {
        'alertTitle': 'Add To Favorite',
        'alertQuestion': 'Put this item in favorite?',
        'massage':
            '*Putting this item in Favorite will\ndelete it from the Secret',
        'favoriteButton': 'Favorite',
        'closeButton': 'Close',
      };
  Map get addNote => {
        'titleHint': 'Title...',
        'bodyHint': 'Your text...',
        'images': 'Images',
        'records': 'Records',
      };
  Map get toast => {
        'delete': 'Deleted Successfully',
        'addToFav': 'Add to Favorite',
        'removeFav': 'Removed from Favorite',
        'saved': 'Saved',
      };
  Map get addMemory => {
        'titleHint': 'Title',
        'titleValidateText': 'Memory title can\'t be empty',
        'detailsHint': 'Memory details',
        'date': 'Date',
        'dateValidateText': 'memory Date Required'
      };

  Map get discardAndSaveAlert => {
        'warning': 'Warning !!',
        'memoryEmpty': 'Title Or Memory Date can\'t be empty.',
        'memoryMessage':
            '- if you discard you will continue and go back\n,- if you cancel you will continue edit your memory.',
        'taskEmpty': 'Title Or Task Date can\'t be empty.',
        'taskMessage':
            '- if you discard you will continue and go back\n,- if you cancel you will continue edit your task.',
      };
  Map get onBoarding => {
        'notes': 'Notes',
        'notesBody':
            'You can write whatever you want, put a picture or an audio recording to hear it whenever you want !',
        'tasks': 'Tasks',
        'tasksBody':
            'Add your Missions as a tasks to motivate you to complete them and organize your tasks',
        'memories': 'Memories',
        'memoriesBody':
            'Put all your memories here to always remember them whenever you want!',
        'nextButton': 'NEXT',
        'startedButton': 'GET STARTED'
      };
  Map get appInfo => {
        'title': 'About',
        'onBoarding': 'Introduction Page',
        'info': 'APP Info',
        'appInfoBody':
            'NOTA app the free app that you can write whatever you want, put a picture or an audio recording to hear it whenever you want, Add your Missions as a tasks to motivate you to complete them and organize your tasks, Put all your memories details and photo to always remember them whenever you want\n\n'
                'Save your private note ,task and memory in secret to be the only one how can with owin password you created.'
                '\n\nYou can save your preferable note, task and memory in favorite to get in any time.'
      };
  String get cancelBtn => 'Cancel';
  String get discardBtn => 'Discard';
  Map get terms => {
        'title': 'Terms Of Use',
        'termsBody':
            "These Terms of Use govern your use of MEGA MAR,and any information, text, graphics, photos or other materials "
                "appearing on the NOTA app, referencing these Terms. you must read and,"
                " understand these terms.",
        'privacy': 'Privacy',
        'privacyBody':
            "The NOTA app Privacy Policy is incorporated into these Terms. By accepting these Terms, you agree to access your storage and microphone through the Services in accordance with the Privacy Policy,",
        'userContent': 'User Content',
        'userContentBody':
            "The Services consist of interactive features and areas that allow users to create, delete or update, including but not limited to photos,"
                " voices, text, items, or other materials (collectively,). You understand that you are responsible for all data charges you incur by using the Services."
                " You also understand that your User Content can\'t be viewable by others and you only have the ability to control who can access such content by adjusting your privacy settings."
                " And you agree to abide by our Community Guidelines, which may be updated from time to time.",
        'feedback': 'Feedback',
        'feedbackBody': "You agree that any feedback, suggestions, ideas, or other information or materials regarding SNOW or the Services that you provide, whether by email or otherwise (Feedback),"
            " are non-confidential and shall become the sole property of SNOW. We will be entitled to the unrestricted use and dissemination of such Feedback for any purpose,"
            " commercial or otherwise, without acknowledging or compensating you. You waive any rights you may have to the Feedback (including any copyrights or moral rights)."
            " We like hearing from users, but please do not share your ideas with us if you expect to be paid or want to continue to own or claim rights in them."
      };
}
