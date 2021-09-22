import 'package:flutter/material.dart';
import 'package:notes_app/shared/components/show_full_image.dart';

class ImageList extends StatelessWidget {
  final cubit;
  final List imageList;
  ImageList({required this.imageList,this.cubit});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:imageList.length,
        itemBuilder: (ctx, index) {
          return InkWell(
            onTap:()=> Navigator.push(context, MaterialPageRoute(fullscreenDialog: true,builder: (context) => FullImage(fullImagePath: imageList[index],),)),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 4, horizontal: 10),
              child: Row(
                children: [
                  // SizedBox(width: 5,),
                  Icon(
                    Icons.image_rounded,
                    color: Colors.grey,
                    size: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Text(
                        '${imageList[index].toString().split('/').last}',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.grey, fontSize: 17),
                      )),
                  IconButton(
                      onPressed: () {print(imageList);
                        cubit.deleteSavedImage(imageID: imageList[index]['id'].toInt(),selectedItemIndex:index);
                        },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.grey,
                      ))
                  // Image.file(File(cubit.image!.path),width: 50,height: 50 ,fit: BoxFit.cover ,),
                ],
              ),
            ),
          );
        });
  }
}
