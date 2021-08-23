import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        SettingCubit cubit = SettingCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Setting'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              ListTile(
                subtitle: Text(
                  "10.1.6",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                title: Text(
                  'Version',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              ),
              // Divider(
              //   height: .5,
              //   thickness: .5,
              //   color: Colors.grey,
              // ),
              tileItem(
                  fun: () {}, title: 'About', leadingIcon: Icons.info_outline),
              tileItem(
                  fun: () {},
                  title: 'Contact Us',
                  leadingIcon: Icons.contact_page_outlined),
              tileItem(
                  fun: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsOfUse(),
                        ));
                  },
                  title: 'Terms Of Use',
                  leadingIcon: Icons.contact_page_outlined),
              tileItem(
                  fun: () => cubit.onShareWithEmptyOrigin(context),
                  title: 'Share App',
                  leadingIcon: Icons.share),

              SwitchListTile(
                title: const Text('Dark Mode',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                value: cubit.darkMode,
                onChanged: cubit.onChangeMode,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                secondary: const Icon(
                  Icons.dark_mode_outlined,
                  color: Colors.white,
                ),
              ),

              _createLanguageDropDown(context),
              Text( cubit.language.toString() + '  ' ,style: TextStyle(color: Colors.grey,fontSize: 20),),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                    child: Text(
                      'contactUS',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              tileItem(
                  leadingIcon: FontAwesomeIcons.facebookF,
                  title: 'faceBook',
                  fun: () => launch('https://www.facebook.com/migoamasha224')),
              tileItem(
                  leadingIcon: FontAwesomeIcons.twitter,
                  title: 'Twitter',
                  fun: () async {
                    String fbProtocolUrl = 'fb://profile/page_id';

                    String fallbackUrl = 'https://www.facebook.com/page_name';

                    try {
                      bool launched =
                          await launch(fbProtocolUrl, forceSafariVC: false);

                      if (!launched) {
                        await launch(fallbackUrl, forceSafariVC: false);
                      }
                    } catch (e) {
                      await launch(fallbackUrl, forceSafariVC: false);
                    }
                    // launch(
                    //         'https://twitter.com/migoo_1_3?s=09&fbclid=IwAR3k92gBqVe_OWHYwn2jsvsdV7hpO_lCB9dqJdS2SSM-7yhlaD_i8S7nsKM')
                  })

              // DrawerTile(

              //     leadingIconColor: primaryColor.withOpacity(.8),
              //     icon: FontAwesomeIcons.twitter,
              //     tittle: Languages.of(context)!.aboutScreen['twitter'],
              //     fun: () => launch(
              //         'https://twitter.com/migoo_1_3?s=09&fbclid=IwAR3k92gBqVe_OWHYwn2jsvsdV7hpO_lCB9dqJdS2SSM-7yhlaD_i8S7nsKM')),
              // DrawerTile(
              //   leadingIconColor: primaryColor,
              //   icon: FontAwesomeIcons.google,
              //   tittle: Languages.of(context)!.aboutScreen['gmail'],
              //   fun: () => launch(_emailLaunchUri.toString()),
              // ),
              // DrawerTile(
              //     leadingIconColor: Colors.green,
              //     icon: FontAwesomeIcons.whatsapp,
              //     tittle: Languages.of(context)!.aboutScreen['whatsApp'],
              //     fun: () async => await launch(
              //         "https://wa.me/01552154105?text=write your problem")),
            ],
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

  ListTile tileItem({fun, title, leadingIcon}) {
    return ListTile(
      onTap: fun,
      title: Text(
        title,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      leading: Icon(
        leadingIcon,
        color: Colors.white,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 25,
      ),
    );
  }
}
