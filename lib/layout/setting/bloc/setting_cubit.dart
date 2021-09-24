import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/setting/bloc/setting_states.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/shared/localizations/localization/locale_constant.dart';
import 'package:notes_app/shared/localizations/localization_models/language_data.dart';
import 'package:notes_app/shared/share/share_functions.dart';

class SettingCubit extends Cubit<SettingStates> {
  SettingCubit() : super(SettingInitialState());

  static SettingCubit get(context) => BlocProvider.of(context);

  bool darkMode = true;

  bool? checkMode;

  String language = "en";
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

  shareApp(context)=> shareText(text: 'Download Nota App From AppStore .\nTo save your notes , memories and tasks',
      subject: 'Download Notes App Application Via Link https://www.facebook.com/migoamasha224',
  );

  languageBottomSheet(context){
    return showModalBottomSheet<void>(
        barrierColor: Colors.transparent,
        context: context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32),topRight: Radius.circular(32))),
            margin: EdgeInsets.fromLTRB(34, 7, 34, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 22,top: 17),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5)),
                  height: 3,
                  width: 80,

                ),
                RadioListTile<String>(
                  title: Text(LanguageData.languageList()[0].name.toString(),style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 14),),
                  value: LanguageData.languageList()[0].languageCode,
                  activeColor: Color(0xff73D3DA),
                  groupValue: language,
                  onChanged: (value) {
                    language = value! ;
                    changeLanguage(context, value);
                    emit(SettingChangeLanguageState());
                  },
                ),
                RadioListTile<String>(
                  title: Text(LanguageData.languageList()[1].name.toString(),style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 14),),
                  value: LanguageData.languageList()[1].languageCode,
                  groupValue: language,
                  activeColor: Color(0xff73D3DA),
                  onChanged: (value) {
                    language = value! ;
                    changeLanguage(context, value);
                    emit(SettingChangeLanguageState());
                  },
                ),
              ],
            ),
          );});
  }


}
