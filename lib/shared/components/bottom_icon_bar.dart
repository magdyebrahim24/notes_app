import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/shared/audio/recorder.dart';

class BottomIconBar extends StatelessWidget {
  final deleteFun, addImageFun, addToFavoriteFun, addToSecretFun,isRecording;

  final bool isFavorite;
  const BottomIconBar(
      {this.deleteFun,
        this.isRecording,
      this.addImageFun,
      this.addToFavoriteFun,
      this.addToSecretFun,
      this.isFavorite = false});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        child: !isRecording ?Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: IconButton(
                onPressed: addToSecretFun,
                icon: SvgPicture.asset('assets/icons/share.svg',
                    color: Theme.of(context).textTheme.headline6!.color),
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: addToSecretFun,
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
                onPressed: addToFavoriteFun,
                icon: isFavorite
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
            SizedBox(
              width: 125,
            ),

            // Expanded(flex: 2,child: SizedBox(),)
          ],
        ):AudioRecorder(),
      ),
    );
  }
}

class AddTaskBottomIconBar extends StatelessWidget {
  final deleteFun, addToFavoriteFun, addToSecretFun;
  final bool isFavorite;

  const AddTaskBottomIconBar(
      {this.deleteFun,
      this.addToFavoriteFun,
      this.addToSecretFun,
      this.isFavorite = false});

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
                  icon: SvgPicture.asset('assets/icons/share.svg',
                      color: Theme.of(context).textTheme.headline6!.color),
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: addToSecretFun,
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
                  onPressed: addToFavoriteFun,
                  icon: isFavorite
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
      ),
    );
  }
}
