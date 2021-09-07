import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme=Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('hi mariam'),
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/drawer.svg'),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Notes'),
              TextButton(onPressed: () {}, child: Text('see all')),
            ],
          ),
          Card(

            color: Colors.amberAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              width: 128,
              height: 140,
              decoration: BoxDecoration(color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.red,),
                    width: 7,
                    clipBehavior: Clip.antiAliasWithSaveLayer,

                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lorem ipsum',
                            style: theme.textTheme.bodyText1!,
                          ),
                          SizedBox(height: 4,),
                          Text(
                              'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore.',
                          maxLines: 7,
                           overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.caption,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ListView.builder(
          //   itemCount: 10,
          //     itemBuilder: (context,index){
          //     return
          //     }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tasks'),
              TextButton(onPressed: () {}, child: Text('see all')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Memories'),
              TextButton(onPressed: () {}, child: Text('see all')),
            ],
          ),
        ],
      ),
    );
  }
}
