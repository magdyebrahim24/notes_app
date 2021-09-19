
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes_app/layout/note/bloc/add_note_cubit.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';
import 'dart:math' as math;

import 'package:notes_app/shared/components/speedDial_FAB/bloc/cubit.dart';
import 'package:notes_app/shared/components/speedDial_FAB/bloc/states.dart';
import 'package:notes_app/shared/constants.dart';

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


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpeedDialFABCubit()..onBuild(this, widget.initialOpen),
      child: BlocConsumer<SpeedDialFABCubit,SpeedDialFABStates>(
        builder: (context, state) {
          SpeedDialFABCubit cubit = SpeedDialFABCubit.get(context);
          return  SizedBox.expand(
            child: Stack(
              alignment: Alignment.bottomRight,
              clipBehavior: Clip.none,
              children: [
                ..._buildExpandingActionButtons(cubit.fabExpandAnimation),
                _buildTapFab(cubit.fABToggle,cubit.isFABOpen),
              ],
            ),
          );
        },listener: (context, state) {

        },
      ),
    );
  }


  List<Widget> _buildExpandingActionButtons(expandAnimation) {
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
          progress: expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }


  Widget _buildTapFab(toggle,open) {
    return BlocConsumer<AddNoteCubit,AddNoteStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        AddNoteCubit cubit =AddNoteCubit.get(context);
      return  Padding(
          padding: const EdgeInsets.only(right: 15,bottom: 24),
          child: AnimatedBuilder(
            animation: cubit.pulsatingAnimation!,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    for (int i = 1; i <= 2; i++)
                      BoxShadow(
                        color: accentColor.withOpacity(cubit.pulsatingAnimationController!.value / 4),
                        spreadRadius: cubit.pulsatingAnimation!.value ,
                      )
                  ],
                ),
                child:  MaterialButton(
                  onPressed: !cubit.isRecording? toggle:()=>cubit.stopRecorder(context),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(color: Theme.of(context).scaffoldBackgroundColor, width: 6)),
                  child: Icon(!open&&cubit.isRecording?Icons.stop :!open? Icons.add : Icons.close , size: 36,),
                  color: Theme.of(context).colorScheme.secondary,
                  height: 96,
                  minWidth: 96,
                  elevation: 0,
                ),
              );
            },
          ),
        );
      },
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
    return BlocConsumer<SpeedDialFABCubit,SpeedDialFABStates>(
      listener: (context,state){},
      builder: (context, state) {
        SpeedDialFABCubit cubit =SpeedDialFABCubit.get(context);
        return MaterialButton(
          padding: EdgeInsets.all(15),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minWidth: 64,
          height: 64,
          color: Theme.of(context).colorScheme.secondary,
          shape: CircleBorder(),
          onPressed: (){onPressed!();cubit.fABToggle();},child: SvgPicture.asset(iconPath,width: 24,height: 24,),);
      },
    );
  }
}