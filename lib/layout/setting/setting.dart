import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_app/layout/about/about.dart';
import 'package:notes_app/layout/setting/bloc/setting_cubit.dart';
import 'package:notes_app/layout/setting/bloc/setting_states.dart';
import 'package:notes_app/layout/terms_of_use/terms_of_use.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';
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
            title: Text(
              Languages.of(context)!.setting['title'],
              style: theme.headline5,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // version
                  ListTile(
                    subtitle: Text("10.1.6", style: theme.bodyText2),
                    title: Text('Version', style: theme.headline6),
                    contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                  ),
                  tileItem(context,
                      fun: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => About(),)),
                      title: 'About',
                      leadingIconPath: 'assets/icons/about.svg' ,),
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
                      fun: () => cubit.languageBottomSheet(context),
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
                        color: theme.headline6!.color
                    ),

                    contentPadding: EdgeInsets.symmetric(horizontal: 40),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(65, 40, 65, 20),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
                    child: Text(
                      'Contact Us',
                      style: theme.headline6!.copyWith(fontSize: 25,),
                    ),
                  ),
                  tileIcon(context,
                      icon: FontAwesomeIcons.linkedinIn,
                      title: 'Linked In',
                      fun: () => launch(
                          'https://www.linkedin.com/in/magdy-ebrahim-30765a202/')),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ListTile tileItem(context, {fun, title, leadingIconPath}) {
    return ListTile(
      onTap: fun,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: SvgPicture.asset(leadingIconPath,color: Theme.of(context).textTheme.headline6!.color) ,
      contentPadding: EdgeInsets.symmetric(horizontal: 40),
      trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,color: Theme.of(context).textTheme.headline6!.color,),
    );
  }

  Widget tileIcon(context, {fun, title, leadingIconPath, icon}) {
    return InkWell(
      onTap: fun,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: Theme.of(context).textTheme.headline6!.color,
            ),
            SizedBox(width: 17,),
            Text(
              title,
              style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
