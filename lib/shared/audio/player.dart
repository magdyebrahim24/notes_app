import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:notes_app/layout/note/bloc/add_note_cubit.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';

class AudioPlayer extends StatefulWidget {
  /// Path from where to play recorded audio
  final ap.AudioSource source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;

  final index ;
  const AudioPlayer({
    required this.source,
    required this.onDelete, this.index,
  });

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

class AudioPlayerState extends State<AudioPlayer> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  @override
  void initState() {

    // _init();

    super.initState();
  }

  int? openedRecord;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit,AddNoteStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);
        return LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildControl(cubit.audioPlayer,cubit.pausePlayer, ()=> cubit.playPlayer(widget.source),widget.index,cubit.recordIndex,()=>cubit.checkSelectedPlayerItem(widget.index)),
                _buildSlider(constraints.maxWidth,cubit.audioPlayer,widget.index,cubit.recordIndex,),
                IconButton(
                  icon: Icon(Icons.delete,
                      color: const Color(0xFF73748D), size: _deleteBtnSize),
                  onPressed: () {
                    cubit.audioPlayer.stop().then((value) => widget.onDelete());
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildControl(audioPlayer,pauseFun,playFun,index,recordIndex,fun) {
    Icon icon;
    Color color;

    if (audioPlayer.playerState.playing && index == recordIndex) {
      icon = Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
      color = Colors.redAccent;
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            fun();
            if (audioPlayer.playerState.playing) {
              pauseFun();
            } else {

              playFun();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider(double widgetWidth, audioPlayer,index,recordIndex) {
    final position = audioPlayer.position;
    final duration = audioPlayer.duration;
    bool canSetValue = false;
    if (duration != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).accentColor,
        onChanged: (v) {
          if (duration != null ) {
            final position = v * duration.inMilliseconds;
            audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && index == recordIndex
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }
}
