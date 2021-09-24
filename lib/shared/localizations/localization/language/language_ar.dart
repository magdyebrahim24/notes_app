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

  Map get search=>{
    'search':'بحث',
    'searchResult':'لا توجد نتائج ل ',
    'note':'ملاحظه',
    'task':'مهمه',
    'memory':'ذاكره',
  };

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

  Map get drawer=>{
    'notes':'ملاحظات',
    'tasks':'مهام',
    'memories':'ذكريات',
    'favorite':'المفضله',
    'secret':'سريه',
    'setting':'الاعدادات',
  };

  Map get secret =>{
    'createPass':'انشاء كلمة السر',
    'confirmPass':'تاكيد كلمة السر',
    'enterPass':'ادخل كلمة السر',
    'confirmError':'كلمة السر غي متطابقه, حاول مره اخري',
    'error':'كلمة السر غير صحيحه, حاول مره اخري ',
  'updatePass':'تغير كلمة السر',
  };
  Map get addTask =>{
    'title':'العنوان',
    'titleBody':'عنوان المهمه...',
    'titleError':'يجب ادخال العنوان',
    'date':'التاريخ',
    'dateError':'ادخل التاريخ',
    'time':'الوقت',
    'timeError':'ادخل الوقت',
    'addSubTask':'أضف مهمة فرعية',
    'bodySubTask':'اكتب مهمة فرعية',
    'bodySubTaskError':'يجب الا تكون فارغه',
  };
  Map get alertBottomSheetForAddItemInFavorite =>{
    'alertTitle':'الاضافه الى المفضله',
    'alertQuestion':'هل تريد اضافة هذا العنصر الي المفضله؟',
    'massage':'*اضافة هذا العنصر الى المفضله سيؤدي الى\nحذف هذا العنصر من السريه',
    'favoriteButton':'المفضله',
    'closeButton':'اغلاق',
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
  Map get onBoarding =>{
    'notes':'الملاحظات',
    'notesBody':'يمكنك كتابة ما تريد،و وضع الصور والتسجيلات لسماعها في اي وقت تريد.',
    'tasks':'المهام',
    'tasksBody':'أضف نشاطاتك بمثابة مهام لتحفيزك لإكمالها وتنظيم مهامك.',
    'memories':'الذكرايات',
    'memoriesBody':'ضع كل ذكرياتك هنا لتذكرها دائما كلما أردت!',
    'nextButton':'التالي',
    'startedButton':'بدأ الاستخدام'
  };

  String get cancelBtn =>'الغاء';
  String get discardBtn =>'تجاهل';
}
