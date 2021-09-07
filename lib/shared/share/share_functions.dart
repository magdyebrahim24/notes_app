

import 'package:share/share.dart';

void share(List<String> imagesPaths,{text,subject}) async{
 await Share.shareFiles(imagesPaths,text: text,subject: subject);
}