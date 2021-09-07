import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/setting/bloc/setting_states.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/shared/localizations/localization/locale_constant.dart';
import 'package:notes_app/shared/share/share_functions.dart';
import 'package:share/share.dart';

class SettingCubit extends Cubit<SettingStates> {
  SettingCubit() : super(SettingInitialState());

  static SettingCubit get(context) => BlocProvider.of(context);

  bool darkMode = true;

  bool? checkMode;

  String? language = "en";
  void onBuild() async{
    checkMode = CacheHelper.getBool(key: 'mode');
    if (checkMode != null) {
      darkMode = checkMode!;
    } else {
      var brightness = SchedulerBinding.instance!.window.platformBrightness;
      darkMode = brightness == Brightness.dark;
      CacheHelper.putBool(key: 'mode', value: darkMode);
    }
     language = await getLanguage();
    emit(SettingOnBuildState());
  }

  void onChangeMode(value) {
    darkMode = value;
    CacheHelper.putBool(key: 'mode', value: value);
    print(darkMode);
    emit(SettingChangeModeState());
  }

  shareApp(context) => share([],text: 'Download Nota App From AppStore . \n To save your notes , memories and tasks',
      subject: 'Download Notes App Application Via Link https://www.facebook.com/migoamasha224',
  );
  final Uri emailLaunchUri =
  Uri(
      scheme: 'Nota App',
      path: 'migoamasha27@gmail.com',
      queryParameters: {
        'subject': 'Please Write Your Problem .',
      });
  // async {
  //   await Share.share(
  //     'Download Nota App From AppStore . \n To save your notes , memories and tasks',
  //     subject:
  //         'Download Notes App Application Via Link https://www.facebook.com/migoamasha224',
  //   );
  // }
}
