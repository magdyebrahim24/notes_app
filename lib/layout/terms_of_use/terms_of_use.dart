import 'package:flutter/material.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';

class TermsOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Languages.of(context)!.terms['title'].toString(),
          style: theme.headline4!
              .copyWith(fontSize: 21, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(Languages.of(context)!.terms['title'].toString(), context),
              subtext(
                Languages.of(context)!.terms['termsBody'].toString(),
              ),
              divider(),
              title(Languages.of(context)!.terms['privacy'].toString(), context),
              subtext(
                  Languages.of(context)!.terms['privacyBody'].toString()              ),
              divider(),
              title(Languages.of(context)!.terms['userContent'].toString()  , context),
              subtext(
                  Languages.of(context)!.terms['userContentBody'].toString()  ),
              divider(),
              title(Languages.of(context)!.terms['feedback'].toString(), context),
              subtext(
                Languages.of(context)!.terms['feedbackBody'].toString() ),
  ]),
        ),
      ),
    );
  }
}

Padding divider({indent = 33.0}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: indent),
    child: Divider(
      thickness: 1,
      height: 1,
      indent: 20,
      endIndent: 20,
    ),
  );
}

Widget title(String text, context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
    child: Text(text, style: Theme.of(context).textTheme.headline6),
  );
}

Widget subtext(String text) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Text(
      text,
      style: TextStyle(color: Color(0xff7D7D7D), fontSize: 16),
    ),
  );
}
