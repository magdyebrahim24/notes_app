import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:notes_app/layout/note/bloc/add_note_cubit.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';

class CustomAudioPlayer extends StatefulWidget {
  /// Path from where to play recorded audio
  final ap.AudioSource source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;

  final index;
  const CustomAudioPlayer({
    required this.source,
    required this.onDelete,
    this.index,
  });

  @override
  CustomAudioPlayerState createState() => CustomAudioPlayerState();
}

class CustomAudioPlayerState extends State<CustomAudioPlayer> {
  int? openedRecord;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNoteStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.onBackground),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildControl(
                      cubit.audioPlayer,
                      cubit.pausePlayer,
                      () => cubit.playPlayer(widget.source),
                      widget.index,
                      cubit.recordIndex,
                      () => cubit.checkSelectedPlayerItem(widget.index)),
                  _buildSlider(
                    constraints.maxWidth,
                    cubit.audioPlayer,
                    widget.index,
                    cubit.recordIndex,
                  ),
                  InkWell(
                      onTap: () {
                        cubit.audioPlayer
                            .stop()
                            .then((value) => widget.onDelete());
                      },
                      child: SvgPicture.asset(
                        'assets/icons/trash.svg',
                        width: 23,
                        height: 23,
                        fit: BoxFit.scaleDown,
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildControl(
      audioPlayer, pauseFun, playFun, index, recordIndex, fun) {
    Widget icon;

    if (audioPlayer.playerState.playing && index == recordIndex) {
      icon = Icon(
        Icons.pause_circle_outline,
        color: Color(0xffA5A5A5).withOpacity(.7),
        size: 27,
      );
    } else {
      icon = SvgPicture.asset(
        'assets/icons/play.svg',
        color: Color(0xffA5A5A5),
        width: 24,
        height: 24,
        fit: BoxFit.scaleDown,
      );
    }

    return InkWell(
      child: SizedBox(width: 30, height: 30, child: icon),
      onTap: () {
        fun();
        if (audioPlayer.playerState.playing) {
          pauseFun();
        } else {
          playFun();
        }
      },
    );
  }

  Widget _buildSlider(double widgetWidth, audioPlayer, index, recordIndex) {
    final position = audioPlayer.position;
    final duration = audioPlayer.duration;
    bool canSetValue = false;
    if (duration != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }
    double width = widgetWidth - 90;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).colorScheme.secondary,
        inactiveColor: Color(0xffBDBDBD),
        onChanged: (v) {
          if (duration != null) {
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
