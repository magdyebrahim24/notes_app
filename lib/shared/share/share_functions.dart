

import 'package:share/share.dart';

share(List<String> imagesPaths,{text,subject}) {
  Share.shareFiles(imagesPaths,text: text,subject: subject);
}

shareText({text,subject}) {
 Share.share(text,subject: subject);
}

void shareTask(taskTitle, taskDate, taskTime,subTasksList) async {
  String subtasksText = subTasksList.isNotEmpty ?  'With subTasks\n' : '';
  subTasksList.forEach((element) {
    subtasksText += '- ${element['body'].toString()}\n';
  });
  await shareText(
      text:
      'I share with you my task\nTask Title : $taskTitle\nTask Date : $taskDate\nTask Time : $taskTime\n$subtasksText\nthis task shared from Nota app',
      subject: 'Share task from Nota app');
}

void shareNoteAndMemory(noteImages,title,body,type,{memoryDate}) async{
  String text = '$title\n$body';
  List<String> images = [];
  noteImages.forEach((element) {images.add(element['link']); });
  if(memoryDate != null) text += '\nMemory Date : $memoryDate';
  text += '\nthis $type shared from Nota App';
  if(images.isNotEmpty){
   await Share.shareFiles(images,text: text,subject: 'Share note from Nota App');
  }else{
    await shareText(text: text,subject:  'Share $type from Nota App');
  }
}