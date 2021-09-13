
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    this.initialOpen,
    required this.children,
  });

  final bool? initialOpen;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late final AnimationController _fabAnimationIcon = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 400),
    reverseDuration: Duration(milliseconds: 400),
  );
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
        _fabAnimationIcon.forward();
      } else {
        _controller.reverse();
        _fabAnimationIcon.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          ..._buildExpandingActionButtons(),
          _buildTapFab(),
        ],
      ),
    );
  }


  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 ;
    for (var i = 0, angleInDegrees = 90.0;
    i < count;
    i++, angleInDegrees == step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: 70 +  (i * 80),
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }


  Widget _buildTapFab() {
    return Padding(
      padding: const EdgeInsets.only(right: 15,bottom: 24),
      child: MaterialButton(
        onPressed: _toggle,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(color: Theme.of(context).scaffoldBackgroundColor, width: 6)),
        child: Icon(!_open ? Icons.add : Icons.close , size: 36,),
        color: Theme.of(context).accentColor,
        height: 96,
        minWidth: 96,
        elevation: 0,
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 33.0 + offset.dx,
          bottom: 60.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.iconPath,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(15),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: 64,
      height: 64,
      color: Theme.of(context).accentColor,
      shape: CircleBorder(),
      onPressed: onPressed,child: SvgPicture.asset(iconPath,width: 24,height: 24,),);
  }
}