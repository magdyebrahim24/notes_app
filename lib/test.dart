// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(new MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       home: new MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   MyHomePageState createState() => new MyHomePageState();
// }
//
// class MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Popup Demo'),
//         ),
//         body: new MyWidget());
//   }
// }
//
// class MyWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return new MyWidgetState();
//   }
// }
//
// class MyWidgetState extends State<MyWidget> {
//   double posx = 100.0;
//   double posy = 100.0;
//
//   void onTapDown(BuildContext context, TapDownDetails details) {
//     print('${details.globalPosition}');
//     final RenderObject? box = context.findRenderObject();
//     final Offset? localOffset = box!.getTransformTo(details.globalPosition)  ;
//     setState(() {
//       posx = localOffset!.dx;
//       posy = localOffset.dy;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new GestureDetector(
//       onTapDown: (TapDownDetails details) => onTapDown(context, details),
//       child: new Stack(fit: StackFit.expand, children: <Widget>[
//         // Hack to expand stack to fill all the space. There must be a better
//         // way to do it.
//         new Container(color: Colors.white),
//         new Positioned(
//           child: new Text('hello'),
//           left: posx,
//           top: posy,
//         )
//       ]),
//     );
//   }
// }