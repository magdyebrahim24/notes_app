import 'package:flutter/material.dart';
import 'package:notes_app/layout/introduction/intro_page.dart';
import 'package:notes_app/layout/terms_of_use/terms_of_use.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Languages.of(context)!.appInfo['title'],
          style: theme.headline5,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntroPage(),
                    )),
                title: Text(
                    Languages.of(context)!.appInfo['onBoarding'],
                  style: theme.headline6
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 15,
                  color: theme.headline6!.color,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 25),
              ),
              divider(indent: 7.0),
              title(Languages.of(context)!.appInfo['info'], context),
              subtext(
               Languages.of(context)!.appInfo['appInfoBody'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
