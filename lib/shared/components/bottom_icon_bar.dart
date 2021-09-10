import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomIconBar extends StatelessWidget {
  final deleteFun, addImageFun, addToFavoriteFun, addToSecretFun;

  final bool isFavorite;
  const BottomIconBar(
      {this.deleteFun,
      this.addImageFun,
      this.addToFavoriteFun,
      this.addToSecretFun,
      required this.isFavorite});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 12,),
            Expanded(
              child: IconButton(
                onPressed: addToSecretFun,
                icon: SvgPicture.asset('assets/icons/share.svg'),
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,highlightColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: addToSecretFun,
                icon: SvgPicture.asset(
                  'assets/icons/unlock.svg',
                ),
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,highlightColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: addToFavoriteFun,
                icon: SvgPicture.asset('assets/icons/star.svg'),
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,highlightColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: deleteFun,
                icon: SvgPicture.asset('assets/icons/trash.svg'),
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
            ),
            SizedBox(width: 125,),

            // Expanded(flex: 2,child: SizedBox(),)
          ],
        ),
      ),
    );
  }
}




class AddTaskBottomIconBar extends StatelessWidget {
  final deleteFun, addImageFun, addToFavoriteFun, addToSecretFun;
  final bool isFavorite;

  const AddTaskBottomIconBar({this.deleteFun, this.addImageFun, this.addToFavoriteFun, this.addToSecretFun, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33),
      child: Material(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 67,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: addToSecretFun,
                  icon: SvgPicture.asset('assets/icons/share.svg'),
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,highlightColor: Colors.transparent,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: addToSecretFun,
                  icon: SvgPicture.asset(
                    'assets/icons/unlock.svg',
                  ),
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,highlightColor: Colors.transparent,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: addToFavoriteFun,
                  icon: SvgPicture.asset('assets/icons/star.svg'),
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,highlightColor: Colors.transparent,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: deleteFun,
                  icon: SvgPicture.asset('assets/icons/trash.svg'),
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
