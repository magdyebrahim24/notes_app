
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class BottomIconBar extends StatelessWidget {
final deleteFun, addImageFun, addToFavoriteFun, addToSecretFun;

final bool isFavorite  ;
  const BottomIconBar({this.deleteFun, this.addImageFun, this.addToFavoriteFun, this.addToSecretFun, required this.isFavorite}) ;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardTheme.color,
      // elevation: 15,

      borderRadius: BorderRadius.only(topLeft:Radius.circular(32),topRight: Radius.circular(32)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1),
        child: Container(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: addToSecretFun, icon: SvgPicture.asset('assets/icons/share.svg')),
              IconButton(
                  onPressed: addToSecretFun, icon: SvgPicture.asset('assets/icons/unlock.svg')),
              IconButton(
                  onPressed: addToFavoriteFun,
                  icon: SvgPicture.asset('assets/icons/star.svg'),),
              // if(addImageFun != null)
              //   IconButton(
              //       color: Theme.of(context).accentColor,onPressed:  addImageFun, icon: Icon(Icons.add_photo_alternate_outlined)) ,
              IconButton(
                  onPressed: deleteFun,
                  icon: SvgPicture.asset('assets/icons/trash.svg')),
            ],
          ),
        ),
      ),
    );
  }
}
