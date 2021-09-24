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

  String get cancelBtn =>'Cancel';
  String get discardBtn =>'Discard';
}
