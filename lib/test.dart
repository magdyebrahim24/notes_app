import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';


class WidgetUIDemo extends StatefulWidget {
  @override
  _WidgetUIDemoState createState() => _WidgetUIDemoState();
}

class _WidgetUIDemoState extends State<WidgetUIDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Widget UI Demo'),
      ),
      body: Body(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final recorder=AudioRecorder();
  final player=PlayAudioRecorder();
  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }
  @override
  void dispose() {
    recorder.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool? isRecorder=recorder.isRecorder;
    bool? isPlay=player.isPlay;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
             child: Icon(isRecorder?Icons.mic_off:Icons.mic),
            onPressed: () {
                recorder.toggleRecorder();
               setState(() {});
            },
          ),
          MaterialButton(
             child: Icon(isPlay?Icons.stop:Icons.play_arrow),
            onPressed: () {
               player.togglePlaying(whenFinished: (){});
            },
          ),
        ],
      ),
    );
  }
}
final pathToSaveAudio='audio.aac';
class AudioRecorder{
  FlutterSoundRecorder? audioRecorder;
  bool isRecorderInitialised=false;
  bool get isRecorder =>audioRecorder!.isRecording;

  Future init()async{
    audioRecorder=FlutterSoundRecorder();
    final state= await Permission.microphone.request();
    if(state !=PermissionStatus.granted){
      throw RecordingPermissionException('Microphone Permission');
    }
    await audioRecorder!.openAudioSession();
    isRecorderInitialised=true;
  }
  Future dispose()async{
    if(!isRecorderInitialised) return;
    await audioRecorder!.closeAudioSession();
    audioRecorder =null;
    isRecorderInitialised=false;
  }

  Future record()async{
    if(!isRecorderInitialised) return;
    await audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future stop()async{
    if(!isRecorderInitialised) return;
    await audioRecorder!.stopRecorder();
  }
  Future toggleRecorder()async{
    if(audioRecorder!.isStopped){
        await record();
    }else{
      await stop();
    }
  }
}
class PlayAudioRecorder{
  FlutterSoundPlayer? soundPlayer;
  bool get isPlay =>soundPlayer!.isPlaying;
  Future init()async{
    soundPlayer=FlutterSoundPlayer();
    soundPlayer!.openAudioSession();
  }
  Future dispose()async{
    soundPlayer!.closeAudioSession();
    soundPlayer=null;
  }
  Future play(VoidCallback whenFinished)async{
    await soundPlayer!.startPlayer(fromURI: pathToSaveAudio,whenFinished: whenFinished);
  }
  Future stop()async{
    await soundPlayer!.stopPlayer();
  }
  Future togglePlaying({required whenFinished})async{
    if(soundPlayer!.isStopped){
      await play(whenFinished);
    }else{
      await stop();
    }
  }
}

// class MainBody extends StatefulWidget {
//
//   @override
//   _MainBodyState createState() => _MainBodyState();
// }
//
// class _MainBodyState extends State<MainBody> {
//   bool initialized = false;
//
//   String? recordingFile;
//   late Track track;
//
//   @override
//   void initState() {
//     if (!kIsWeb) {
//       var status = Permission.microphone.request();
//       status.then((stat) {
//         if (stat != PermissionStatus.granted) {
//           throw RecordingPermissionException(
//               'Microphone permission not granted');
//         }
//       });
//     }
//     super.initState();
//     tempFile(suffix: '.aac').then((path) {
//       recordingFile = path;
//       track = Track(trackPath: recordingFile);
//       setState(() {});
//     });
//   }
//
//   Future<bool> init() async {
//     if (!initialized) {
//       await initializeDateFormatting();
//       initialized = true;
//     }
//     return initialized;
//   }
//
//   void _clean() async {
//     if (recordingFile != null) {
//       try {
//         await File(recordingFile!).delete();
//       } on Exception {
//         // ignore
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _clean();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         initialData: false,
//         future: init(),
//         builder: (context, snapshot) {
//           if (snapshot.data == false) {
//             return Container(
//               width: 0,
//               height: 0,
//               color: Colors.white,
//             );
//           } else {
//             return ListView(
//               children: <Widget>[
//                 _buildRecorder(track),
//               ],
//             );
//           }
//         });
//   }
//
//
//   Widget _buildRecorder(Track track) {
//     return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: RecorderPlaybackController(
//             child: Column(
//               children: [
//                 Left('Recorder'),
//                 SoundRecorderUI(track),
//                 Left('Recording Playback'),
//                 SoundPlayerUI.fromTrack(
//                   track,
//                   enabled: false,
//                   showTitle: true,
//                   audioFocus: AudioFocus.requestFocusAndDuckOthers,
//                 ),
//               ],
//             )));
//   }
// }
//
// ///
// class Left extends StatelessWidget {
//   ///
//   final String label;
//
//   ///
//   Left(this.label);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16.0, bottom: 4, left: 8),
//       child: Container(
//           alignment: Alignment.centerLeft,
//           child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
//     );
//   }
// }
//
//
//
// Future<String> tempFile({String? suffix}) async {
//   suffix ??= 'tmp';
//
//   if (!suffix.startsWith('.')) {
//     suffix = '.$suffix';
//   }
//   var uuid = Uuid();
//   String path;
//   if (!kIsWeb) {
//     var tmpDir = await getTemporaryDirectory();
//     path = '${join(tmpDir.path, uuid.v4())}$suffix';
//     var parent = dirname(path);
//     Directory(parent).createSync(recursive: true);
//   } else {
//     path = 'uuid.v4()}$suffix';
//   }
//
//   return path;
// }
