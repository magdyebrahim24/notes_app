import 'languages.dart';

class LanguageAr extends Languages {
  @override
  Map get setting => {
        'title': 'الاعدادات',
        'version': 'الاصدار',
        'about': 'عن الابلكيشن',
        'termsOfUse': 'سياسة الاستخدام',
        'shareApp': 'مشاركة التطبيق',
        'language': 'اللغة',
        'darkMode': 'الوضع الليلى',
        'contact': 'تواصل معنا',
      };

  Map get home => {
        'notes': 'ملاحظات',
        'tasks': 'مـهــام',
        'memories': 'ذكريات ',
      };

  Map get search => {};
  Map get addNote => {
        'titleHint': 'العنوان...',
        'bodyHint': 'النـص...',
        'images': 'الــصــور',
        'records': 'التسجيلات',
      };
  Map get toast => {
        'delete': 'تم الحذف',
        'addToFav': 'ضيفت للمفضلة',
        'removeFav': 'حذفت من المفضلة',
        'saved': 'تم الحفظ',
      };

  Map get addMemory => {
    'titleHint': 'العنوان',
    'titleValidateText':'العنوان لا يمكن ان يكون فارغ',
    'detailsHint': 'تفاصيل الذكرى',
    'date':'التاريخ',
    'dateValidateText':'التاريخ مطلوب'
  };
  Map get discardAndSaveAlert => {
    'warning':'تحذير !!',
    'memoryEmpty':'عنوان او تاريخ الذكرى لا يمكن ان يكون فارغ',
    'memoryMessage': '- اذا ضغطت تجاهل لن يتم الحفظ و تخرج من الصفحة.\n- اذا ضغطت الغاء سوف تستكمل تعديل الذكرى.',
      'taskEmpty':'عنوان او تاريخ المهمه لا يمكن ان يكون فارغ',
    'taskMessage': '- اذا ضغطت تجاهل لن يتم الحفظ و تخرج من الصفحة.\n- اذا ضغطت الغاء سوف تستكمل تعديل المهمه.'
  };

  String get cancelBtn =>'الغاء';
  String get discardBtn =>'تجاهل';
}
