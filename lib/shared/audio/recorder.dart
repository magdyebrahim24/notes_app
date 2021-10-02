import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes_app/layout/note/bloc/add_note_cubit.dart';
import 'package:notes_app/layout/note/bloc/add_note_states.dart';

class AudioRecorder extends StatefulWidget {
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder>
    with SingleTickerProviderStateMixin {
  AnimationController? playPauseAnimationController;

  @override
  void initState() {
    playPauseAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNoteStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);
        return
            // Column(
            //  mainAxisAlignment: MainAxisAlignment.center,
            //  children: [
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // _buildRecordStopControl(cubit.isRecording,cubit.isPaused,()=>cubit.stop(context),cubit.start),
            // const SizedBox(width: 20),
            _buildPauseResumeControl(cubit.isRecording, cubit.isPaused,
                cubit.resume, cubit.pauseRecorder),
            const SizedBox(width: 20),
            _buildText(cubit.isRecording, cubit.isPaused, cubit.recordDuration),
            SizedBox(
              width: 125,
            ),
          ],
        );
        // if (cubit.amplitude != null) ...[
        //   const SizedBox(height: 40),
        //   Text('Current: ${cubit.amplitude?.current ?? 0.0}'),
        //   Text('Max: ${cubit.amplitude?.max ?? 0.0}'),
        // ],
        // ],
        // );
      },
    );
  }

  // Widget _buildRecordStopControl(isRecording,isPaused,stopFun,startFun) {
  //   late Icon icon;
  //   late Color color;
  //
  //   if (isRecording || isPaused) {
  //     icon = Icon(Icons.stop, color: Colors.red, size: 30);
  //     color = Colors.red.withOpacity(0.1);
  //   } else {
  //     final theme = Theme.of(context);
  //     icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
  //     color = Colors.redAccent;
  //   }
  //
  //   return ClipOval(
  //     child: Material(
  //       color: color,
  //       child: InkWell(
  //         child: SizedBox(width: 56, height: 56, child: icon),
  //         onTap: () {
  //           isRecording ? stopFun() :startFun();
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPauseResumeControl(isRecording, isPaused, resumeFun, pauseFun) {
    if (!isRecording && !isPaused) {
      return const SizedBox.shrink();
    }

    if (!isPaused) {
      playPauseAnimationController!.reverse();
    } else {
      playPauseAnimationController!.forward();
    }

    return InkWell(
      child: Container(
        width: 35,
        height: 35,
        alignment: Alignment.center,
        padding: EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.headline6!.color,
          shape: BoxShape.circle,
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            shape: BoxShape.circle,
          ),
          child: AnimatedIcon(
            size: 24,
            icon: AnimatedIcons.pause_play,
            progress: playPauseAnimationController!,
            semanticLabel: 'Play Pause',
            color: Theme.of(context).textTheme.headline6!.color,
          ),
        ),
      ),
      onTap: () {
        isPaused ? resumeFun() : pauseFun();
      },
    );
  }

  Widget _buildText(isRecording, isPaused, recordDuration) {
    if (isRecording || isPaused) {
      return _buildTimer(recordDuration);
    }

    return Text("Waiting to record");
  }

  Widget _buildTimer(recordDuration) {
    final String minutes = _formatNumber(recordDuration ~/ 60);
    final String seconds = _formatNumber(recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(
          color: Theme.of(context).textTheme.headline6!.color,
          fontSize: 20,
          fontWeight: FontWeight.w500),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  @override
  void dispose() {
    playPauseAnimationController!.dispose();
    super.dispose();
  }
}
