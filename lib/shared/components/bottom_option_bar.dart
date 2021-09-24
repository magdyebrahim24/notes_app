import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

showOptionBar(context,
    {secretFun, favFun, deleteFun, isFavorite = 0, onCloseFun ,shareFun}) {
  return showModalBottomSheet<void>(
      context: context,
      barrierColor: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          padding: EdgeInsets.fromLTRB(7, 7, 7, 0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),

          ),
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),

              color: Theme.of(context).cardTheme.color,
             ),
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 67,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: (){Navigator.pop(context);shareFun();},
                    icon: SvgPicture.asset('assets/icons/share.svg',
                        width: 23,
                        height: 23,
                        color: Theme.of(context).textTheme.headline6!.color),
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: secretFun,
                    icon: SvgPicture.asset('assets/icons/unlock.svg',
                        color: Theme.of(context).textTheme.headline6!.color),
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: favFun,
                    icon: isFavorite == 1
                        ? SvgPicture.asset(
                            'assets/icons/fill_star.svg',
                            color: Theme.of(context).textTheme.headline6!.color,
                            height: 19,
                            width: 19,
                          )
                        : SvgPicture.asset(
                            'assets/icons/star.svg',
                            color: Theme.of(context).textTheme.headline6!.color,
                          ),
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: deleteFun,
                    icon: SvgPicture.asset('assets/icons/trash.svg'),
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        );
      }).whenComplete(() {
    onCloseFun(null);
  });
}
