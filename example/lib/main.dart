import 'package:audio_kit/audio_kit.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _audioEditorPlugin = AudioKit();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _audioEditorPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            AudioKit.checkPermission();
            // var audioFile = await AudioKit.pickMultipleFile();
            // if (true) {
            //   //   // AudioKit.trimAudio(
            //   //   //   path: audioFile.path,
            //   //   //   name: "neww",
            //   //   //   cutLeft: 0,
            //   //   //   cutRight: 30,
            //   //   // );
            //   //   // var x = DateTime.now().millisecondsSinceEpoch;
            //   AudioKit.mixMultipleAudio(audioList: [
            //     // "/storage/emulated/0/Download/audio_mix_1712506320152.mp3",
            //     "/storage/emulated/0/Music/Recordings/Call Recordings/Mai FUCKBoiz-2204101448.awb",
            //     "/storage/emulated/0/Music/Recordings/Standard Recordings/Ghi tiêu chuẩn 2.mp3"
            //   ], delayList: [
            //     0,
            //     5000,
            //     10000
            //   ], fadeTimes: [
            //     5,
            //     5,
            //     5,
            //     5,
            //     5,
            //     5
            //   ], durations: [
            //     80,
            //     10,
            //     16
            //   ], volume: 1);
            //   // await AudioKit.getAudioDataSamples(filePath: audioFile!.path);
            //   // await AudioKit.customEdit(
            //   //     cmd:
            //   //         "-i ${audioFile[0]} -filter_complex \"[0:a]atrim=end=6[a1];[0:a]atrim=start=12[a2];[a1][a2]concat=n=2:v=0:a=1[out]\" -map \"[out]\"");
            // }
            // // var x = await AudioKit. getAllAudioFromDevice();
          },
        ),
      ),
    );
  }
}
