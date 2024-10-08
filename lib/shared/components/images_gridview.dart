import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/shared/components/show_full_image.dart';
import 'package:notes_app/shared/localizations/localization/language/languages.dart';
import 'package:notes_app/shared/share/share_functions.dart';

class GridViewForImages extends StatelessWidget {
  final List imagesList;
  final deleteFun;
  GridViewForImages(this.imagesList,
      {required this.deleteFun});

  @override
  Widget build(BuildContext context) {
    return  Padding(padding: EdgeInsets.only(top: 15,bottom: 20),
    child: Material(
    color: Theme.of(context).cardTheme.color,
    borderRadius: BorderRadius.circular(25),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Container(
    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
    decoration: BoxDecoration(border: BorderDirectional(start: BorderSide(color: Theme.of(context).colorScheme.secondary,width: 10),),),
    child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              childrenPadding: EdgeInsets.zero,
              tilePadding: EdgeInsets.zero,
              title: Text(
               Languages.of(context)!.addNote['images'].toString(),
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline4!.color, fontSize: 17),
              ),
              leading: Icon(
                Icons.perm_media_outlined,
                color: Theme.of(context).textTheme.headline4!.color,
                size: 18,
              ),
              maintainState: false,
              initiallyExpanded: true,
              iconColor: Theme.of(context).textTheme.headline4!.color,
              children: [
                StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  itemCount: imagesList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    onTapUp: (val) {
                      showImageSelection(
                          context, val, index, imagesList[index]);
                    },
                    child: Hero(
                      tag: imagesList[index]['link'].toString(),
                      child: Material(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        // borderRadius: BorderRadius.circular(15.0),
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15.0),
                        side: BorderSide(width: 2,color:  Theme.of(context).colorScheme.onBackground)),
                        child: Image.file(
                          File(imagesList[index]['link']),
                          fit: BoxFit.fitWidth,
                          isAntiAlias: true,
                        ),
                      ),
                    ),
                  ),
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8.0,
                ),
              ],
            ),
          ))
    ));
  }

  Future<void> showImageSelection(context, val, index, data) async {
    return showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            val.globalPosition.dx,
            val.globalPosition.dy,
            val.globalPosition.dx,
            val.globalPosition.dy),
        items: [
          PopupMenuItem(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    minWidth: 50,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                        return FullImage(fullImagePath: data['link']);
                      }));
                    },
                    child: Icon(
                      Icons.fit_screen_outlined,
                      color: Theme.of(context).textTheme.headline6!.color,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    minWidth: 50,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Navigator.of(context).pop();
                      share([data['link']],
                          text:
                              'This Images Shared From Nota App \nyou can download from play store now.');
                    },
                    child: SvgPicture.asset(
                      'assets/icons/share.svg',
                      color: Theme.of(context).textTheme.headline6!.color,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await deleteFun(data['id'], index);
                      Navigator.pop(context);
                    },
                    // height: 30,
                    minWidth: 50,
                    child: SvgPicture.asset(
                      'assets/icons/trash.svg',
                      height: 21,
                      width: 21,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            height: 30,
            padding: EdgeInsets.zero,
            value: null,
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));


  }
}
