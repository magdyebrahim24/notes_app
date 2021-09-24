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

  Map get home =>{
    'notes':'Notes',
    'tasks':'Tasks',
    'memories':'Memories ',
  };

  Map get search=>{
    'search':'Search',
    'searchResult':'No Result For',
    'search':'Search',
    'search':'Search',
    'search':'Search',
  };
}
