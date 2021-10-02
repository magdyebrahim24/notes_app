
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/layout/note/bloc/add_note_cubit.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';

class PlayPauseAnimatedIcon extends StatefulWidget {

  final controller ,onTaFun ;

  const PlayPauseAnimatedIcon({Key? key,required this.controller,required this.onTaFun}) : super(key: key);

  @override
  State<PlayPauseAnimatedIcon> createState() => _PlayPauseAnimatedIconState();
}

class _PlayPauseAnimatedIconState extends State<PlayPauseAnimatedIcon> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit,AddNoteStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        AddNoteCubit cubit = AddNoteCubit.get(context);
      return  InkWell(
        onTap: widget.onTaFun,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2,),
          ),
          child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: widget.controller,
              semanticLabel: 'Play Pause',
            ),
        ),
      );
      },

    );
  }
}
