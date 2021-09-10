

import 'package:share/share.dart';

share(List<String> imagesPaths,{text,subject}) {
  Share.shareFiles(imagesPaths,text: text,subject: subject);
}

shareText({text,subject}) {
 Share.share(text,subject: subject);
}