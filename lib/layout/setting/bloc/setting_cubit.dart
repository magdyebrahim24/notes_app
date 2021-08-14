import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/setting/bloc/setting_states.dart';
import 'package:notes_app/shared/cache_helper.dart';
import 'package:notes_app/shared/localizations/localization/locale_constant.dart';
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

  onShare(context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final RenderBox box = context.findRenderObject() as RenderBox;

    // await Share.shareFiles(imagePaths,
    //     text: text,
    //     subject: subject,
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    //
    await Share.share('Notes App',
        subject: 'Download Notes App Application Via Link',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future onShareWithEmptyOrigin(context) async {
    await Share.share(
      'Notes App',
      subject:
          'Download Notes App Application Via Link https://www.facebook.com/migoamasha224',
    );
  }
}
