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

  Map get search=>{
    'search':'Search',
    'searchResult':'No Result For',
    'note':'Note',
    'task':'Task',
    'memory':'Memory',
  };

  Map get drawer=>{
    'notes':'Notes',
    'tasks':'Tasks',
    'memories':'Memories',
    'favorite':'Favorite',
    'secret':'Secret',
    'setting':'Setting',
  };
  Map get secret =>{
    'createPass':'Create Password',
    'confirmPass':'Confirm Password',
    'enterPass':'Enter Password',
    'confirmError':'Passwords isn\'t identical, try again',
    'error':'Password is in correct, try again',
    'updatePass':'Update Password'
  };
  Map get addTask =>{
    'title':'Title',
    'titleBody':'Your title...',
    'titleError':'task title can\'t be empty',
    'date':'Date',
    'dateError':'date required',
    'time':'Time',
    'timeError':'time required',
    'addSubTask':'Add SubTask',
    'bodySubTask':'write subtask',
    'bodySubTaskError':'can\'t be empty',
  };
  Map get alertBottomSheetForAddItemInFavorite =>{
    'alertTitle':'Add To Favorite',
    'alertQuestion':'Put this item in favorite?',
    'massage':'*Putting this item in Favorite will\ndelete it from the Secret',
    'favoriteButton':'Favorite',
    'closeButton':'Close',
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
    'titleValidateText':'Memory title can\'t be empty',
    'detailsHint': 'Memory details',
    'date':'Date',
    'dateValidateText':'memory Date Required'
  };

  Map get discardAndSaveAlert => {

    'warning':'Warning !!',
    'memoryEmpty':'Title Or Memory Date can\'t be empty.',
    'memoryMessage': '- if you discard you will continue and go back\n,- if you cancel you will continue edit your memory.',
    'taskEmpty':'Title Or Task Date can\'t be empty.',
    'taskMessage': '- if you discard you will continue and go back\n,- if you cancel you will continue edit your task.',

  };
  Map get onBoarding =>{
    'notes':'Notes',
    'notesBody':'You can write whatever you want, put a picture or an audio recording to hear it whenever you want !',
    'tasks':'Tasks',
    'tasksBody':'Add your Missions as a tasks to motivate you to complete them and organize your tasks',
    'memories':'Memories',
    'memoriesBody':'Put all your memories here to always remember them whenever you want!',
    'nextButton':'NEXT',
    'startedButton':'GET STARTED'
  };
  String get cancelBtn =>'Cancel';
  String get discardBtn =>'Discard';
}
