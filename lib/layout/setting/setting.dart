import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_app/layout/setting/bloc/setting_cubit.dart';
import 'package:notes_app/layout/setting/bloc/setting_states.dart';
import 'package:notes_app/layout/terms_of_use/terms_of_use.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';
import 'package:notes_app/shared/localizations/localization/locale_constant.dart';
import 'package:notes_app/shared/localizations/localization_models/language_data.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingCubit, SettingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var theme = Theme.of(context).textTheme;
        SettingCubit cubit = SettingCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
            title: Text(
              'Setting',
              style: theme.headline5,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    subtitle: Text("10.1.6", style: theme.bodyText2),
                    title: Text('Version', style: theme.headline6),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  tileItem(context,
                      fun: () {},
                      title: 'About',
                      leadingIconPath: 'assets/icons/about.svg'),
                  tileItem(context, fun: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsOfUse(),
                        ));
                  },
                      title: 'Terms Of Use',
                      leadingIconPath: 'assets/icons/terms_of_use.svg'),
                  tileItem(context,
                      fun: () => cubit.shareApp(context),
                      title: 'Share App',
                      leadingIconPath: 'assets/icons/share.svg'),
                  tileItem(context,
                      fun: () => cubit.shareApp(context),
                      title: 'Language',
                      leadingIconPath: 'assets/icons/language.svg'),

                  SwitchListTile(
                    title: Text('Dark Mode', style: theme.headline6),
                    value: cubit.darkMode,
                    onChanged: cubit.onChangeMode,
                    activeColor: Color(0xff73D3DA),
                    inactiveTrackColor: Color(0xff9E9E9E),
                    inactiveThumbColor: Colors.white,
                    secondary: SvgPicture.asset(
                      'assets/icons/dark_mode.svg',
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(40, 50, 40, 20),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Contact Us',
                      style: theme.headline6!.copyWith(fontSize: 25),
                    ),
                  ),
                  tileIcon(context,
                      icon: FontAwesomeIcons.facebookF,
                      title: 'FaceBook',
                      fun: () =>
                          launch('https://www.facebook.com/migoamasha224')),
                  tileIcon(context,
                      icon: Icons.mail,
                      title: 'Gmail',
                      fun: () => launch('mailto:<migoamasha27@gmail.com>?subject=<Contact To Nota App Team>&body=<type your problem here .>')
                  ),
                  tileIcon(context,
                      icon: FontAwesomeIcons.linkedinIn,
                      title: 'Linked In',
                      fun: () => launch(
                          'https://www.linkedin.com/in/magdy-ebrahim-30765a202/')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _createLanguageDropDown(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.language, color: Colors.grey),
              SizedBox(
                width: 33,
              ),
              Text(
                Languages.of(context)!.setting['language'],
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 55),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<LanguageData>(
                      iconSize: 30,
                      hint: Text(Languages.of(context)!
                          .setting['labelSelectLanguage']),
                      onChanged: (language) {
                        changeLanguage(context, language!.languageCode);
                      },
                      isDense: false,
                      items: LanguageData.languageList()
                          .map<DropdownMenuItem<LanguageData>>(
                            (e) => DropdownMenuItem<LanguageData>(
                              value: e,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    e.flag,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text(e.name)
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile tileItem(context, {fun, title, leadingIconPath}) {
    return ListTile(
      onTap: fun,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: SvgPicture.asset(leadingIconPath) ,
    );
  }

  ListTile tileIcon(context, {fun, title, leadingIconPath, icon}) {
    return ListTile(
      onTap: fun,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 17),
      ),
      leading: Icon(
        icon,
      ),
    );
  }
}
