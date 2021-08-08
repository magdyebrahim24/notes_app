import 'package:flutter/material.dart';

class IconForSecret extends StatelessWidget {
  final onPressed;
  final body;
  IconForSecret({this.onPressed,this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13),
      child: MaterialButton(
        minWidth: 80,
        height: 80,
        child: Text('$body',
          style: Theme.of(context).textTheme.headline4),
        color: Theme.of(context).primaryColor,
        onPressed: onPressed,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
          // side: BorderSide(color:Theme.of(context).primaryColor),
    ),
      ),
    );
  }
}
