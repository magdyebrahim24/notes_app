import 'package:flutter/material.dart';

showOptionBar(
  context,{secretFun,favFun,deleteFun,isFavorite = 0}
) {
  return showModalBottomSheet<void>(
      context: context,
      elevation: 7,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 65,
          color: Theme.of(context).primaryColor,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                bottomIcon(
                    fun: secretFun, icon: Icons.lock_open_outlined, text: 'Secret'),
                bottomIcon(fun: favFun, icon: isFavorite == 1 ?  Icons.star : Icons.star_border, text: 'Favorite'),
                bottomIcon(
                    fun: () {isFavorite=0;}, icon: Icons.ios_share_outlined, text: 'Share'),
                bottomIcon(
                    fun: deleteFun,
                    icon: Icons.delete_outline_rounded,
                    text: 'Delete'),
              ],
            ),
          ),
        );
      });
}

Widget bottomIcon({text, icon, fun}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 13),
    child: InkWell(
      onTap: fun,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 10, color: Colors.white),
          )
        ],
      ),
    ),
  );
}

