

import 'package:share/share.dart';

void share(List<String> imagesPaths){
  Share.shareFiles(imagesPaths,text: 'this message shared from Nota App');
}