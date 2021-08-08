
import 'package:flutter/material.dart';

class BottomIconBar extends StatelessWidget {
final deleteFun, addImageFun, addToFavoriteFun, addToSecretFun;

final bool isFavorite  ;
  const BottomIconBar({this.deleteFun, this.addImageFun, this.addToFavoriteFun, this.addToSecretFun, required this.isFavorite}) ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
      child: Material(
        elevation: 15,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: addToSecretFun, icon: Icon(Icons.lock_open_outlined)),
              IconButton(
                  onPressed: addToFavoriteFun,
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    size: 28,
                  )),
              if(addImageFun != null)
                IconButton(onPressed:  addImageFun, icon: Icon(Icons.add_photo_alternate_outlined)) ,
              IconButton(
                  onPressed: deleteFun,
                  icon: Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.redAccent,
                    size: 28,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
