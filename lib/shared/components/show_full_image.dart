import 'dart:io';

import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  final fullImagePath;

  const FullImage({Key? key, this.fullImagePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3,
              scaleEnabled: true,
              child: Image.file(
               File(fullImagePath) ,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 25,
            child: MaterialButton(
              minWidth: 30,
              height: 55,
              color: Colors.black,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                // side: BorderSide(color: Colors.white, width: 2)
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.expand_more,
                size: 35,
                color: Colors.white,
              ),
              // color: backGroundColor
            ),
          ),
        ],
      ),
    );
  }
}
