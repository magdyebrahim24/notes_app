import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PulsatingCircleIconButton(
          onTap: () {},
          icon: Icon(
            Icons.monetization_on,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}

class PulsatingCircleIconButton extends StatefulWidget {
  const PulsatingCircleIconButton({
    required this.onTap,
    required this.icon,
  }) ;

  final GestureTapCallback onTap;
  final Icon icon;

  @override
  _PulsatingCircleIconButtonState createState() => _PulsatingCircleIconButtonState();
}

class _PulsatingCircleIconButtonState extends State<PulsatingCircleIconButton> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );
    _animationController!.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation!,
        builder: (context, _) {
          return Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                for (int i = 1; i <= 2; i++)
                  BoxShadow(
                    color: Colors.white.withOpacity(_animationController!.value / 4),
                    spreadRadius: _animation!.value ,
                  )
              ],
            ),
            child: widget.icon,
          );
        },
      ),
    );
  }
}