import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final onPressed;
  MyBottomNavigationBar({required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * .4,
              onPressed: onPressed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.grey.withOpacity(.3),
              padding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10
              ),
              child: Text('Add Image',style: TextStyle(color: Colors.white,fontSize: 16)),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * .4,
              padding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10
              ),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.redAccent.withOpacity(.1),
              child: Text('Delete Note',style: TextStyle(color: Colors.red,fontSize: 16),),
            )
          ],
        ),
      ),
    );
  }
}
