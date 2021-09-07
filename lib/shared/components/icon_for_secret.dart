import 'package:flutter/material.dart';

class IconForSecret extends StatelessWidget {
  final onPressed;
  final body;
  final color;
  IconForSecret({this.onPressed,this.body,this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13),
      child: MaterialButton(
        minWidth: 48,
        height: 48,
        child: body,
        color: color,
        onPressed: onPressed,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          // side: BorderSide(color:Theme.of(context).primaryColor),
    ),
      ),
    );
  }
}
