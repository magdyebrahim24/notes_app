//
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter_sound_lite/flutter_sound.dart';
// import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// typedef _Fn = void Function();
//
// const theSource = AudioSource.microphone;
//
// /// Example app.
// class SimpleRecorder extends StatefulWidget {
//   @override
//   _SimpleRecorderState createState() => _SimpleRecorderState();
// }
//
// class _SimpleRecorderState extends State<SimpleRecorder> {
//   Codec _codec = Codec.aacMP4;
//   String _mPath =
//       '/data/user/0/com.example.notes_app/app_flutter/recorders/tau_file.mp4';
//   FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
//   FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
//   bool _mPlayerIsInited = false;
//   bool _mRecorderIsInited = false;
//   bool _mplaybackReady = false;
//
//   @override
//   void initState() {
//     _mPlayer!.openAudioSession().then((value) {
//       setState(() {
//         _mPlayerIsInited = true;
//       });
//     });
//
//     openTheRecorder().then((value) {
//       setState(() {
//         _mRecorderIsInited = true;
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _mPlayer!.closeAudioSession();
//     _mPlayer = null;
//
//     _mRecorder!.closeAudioSession();
//     _mRecorder = null;
//     super.dispose();
//   }
//
//   Future<void> openTheRecorder() async {
//     if (!kIsWeb) {
//       var status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         throw RecordingPermissionException('Microphone permission not granted');
//       }
//     }
//     await _mRecorder!.openAudioSession();
//     if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
//       _codec = Codec.opusWebM;
//       _mPath = 'tau_file.webm';
//       if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
//         _mRecorderIsInited = true;
//         return;
//       }
//     }
//     _mRecorderIsInited = true;
//   }
//
//   // ----------------------  Here is the code for recording and playback -------
//
//   void record() async {
//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     String appDocPath = appDocDir.path;
//
//     // create new folder
//     Directory directoryPath =
//         await Directory('$appDocPath/recorders').create(recursive: true);
//     print('/////////////////////////////////////////');
//     print(directoryPath.path);
//     _mRecorder!
//         .startRecorder(
//       toFile: '${directoryPath.path}/tau_file1.mp4',
//       codec: _codec,
//       audioSource: theSource,
//     )
//         .then((value) {
//       setState(() {});
//     });
//   }
//
//   void stopRecorder() async {
//     await _mRecorder!.stopRecorder().then((value) {
//       setState(() {
//         var url = value;
//         print(url.toString());
//         _mplaybackReady = true;
//       });
//     });
//   }
//
//   void play() {
//     assert(_mPlayerIsInited &&
//         _mplaybackReady &&
//         _mRecorder!.isStopped &&
//         _mPlayer!.isStopped);
//     _mPlayer!
//         .startPlayer(
//             fromURI: _mPath,
//             //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
//             whenFinished: () {
//               setState(() {});
//             })
//         .then((value) {
//       setState(() {});
//     });
//   }
//
//   void stopPlayer() {
//     _mPlayer!.stopPlayer().then((value) {
//       setState(() {});
//     });
//   }
//
// // ----------------------------- UI --------------------------------------------
//
//   _Fn? getRecorderFn() {
//     if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
//       return null;
//     }
//     return _mRecorder!.isStopped ? record : stopRecorder;
//   }
//
//   _Fn? getPlaybackFn() {
//     if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
//       return null;
//     }
//     return _mPlayer!.isStopped ? play : stopPlayer;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget makeBody() {
//       return Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.all(3),
//             padding: const EdgeInsets.all(3),
//             height: 80,
//             width: double.infinity,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: Color(0xFFFAF0E6),
//               border: Border.all(
//                 color: Colors.indigo,
//                 width: 3,
//               ),
//             ),
//             child: Row(children: [
//               ElevatedButton(
//                 onPressed: getRecorderFn(),
//                 //color: Colors.white,
//                 //disabledColor: Colors.grey,
//                 child: Text(_mRecorder!.isRecording ? 'Stop' : 'Record'),
//               ),
//               SizedBox(
//                 width: 20,
//               ),
//               Text(_mRecorder!.isRecording
//                   ? 'Recording in progress'
//                   : 'Recorder is stopped'),
//             ]),
//           ),
//           Container(
//             margin: const EdgeInsets.all(3),
//             padding: const EdgeInsets.all(3),
//             height: 80,
//             width: double.infinity,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: Color(0xFFFAF0E6),
//               border: Border.all(
//                 color: Colors.indigo,
//                 width: 3,
//               ),
//             ),
//             child: Row(children: [
//               ElevatedButton(
//                 onPressed: getPlaybackFn(),
//                 //color: Colors.white,
//                 //disabledColor: Colors.grey,
//                 child: Text(_mPlayer!.isPlaying ? 'Stop' : 'Play'),
//               ),
//               SizedBox(
//                 width: 20,
//               ),
//               Text(_mPlayer!.isPlaying
//                   ? 'Playback in progress'
//                   : 'Player is stopped'),
//             ]),
//           ),
//         ],
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       appBar: AppBar(
//         title: const Text('Simple Recorder'),
//       ),
//       body: makeBody(),
//     );
//   }
// }
