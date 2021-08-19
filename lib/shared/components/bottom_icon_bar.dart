
import 'package:flutter/material.dart';

import '../constants.dart';

class BottomIconBar extends StatelessWidget {
final deleteFun, addImageFun, addToFavoriteFun, addToSecretFun;

final bool isFavorite  ;
  const BottomIconBar({this.deleteFun, this.addImageFun, this.addToFavoriteFun, this.addToSecretFun, required this.isFavorite}) ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 30,left: 30,bottom: 15,
      top: 5),
      child: Material(
        color: Theme.of(context).cardTheme.color,
        elevation: 15,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                color: Theme.of(context).accentColor,
                  onPressed: addToSecretFun, icon: Icon(Icons.lock_open_outlined)),
              IconButton(
                  color: Theme.of(context).accentColor,
                  onPressed: addToFavoriteFun,
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    size: 28,
                  )),
              if(addImageFun != null)
                IconButton(
                    color: Theme.of(context).accentColor,onPressed:  addImageFun, icon: Icon(Icons.add_photo_alternate_outlined)) ,
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
