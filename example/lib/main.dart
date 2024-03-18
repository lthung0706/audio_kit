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
            // var audioFile = await AudioKit.pickMultipleFile();
            // if (true) {
            //   // AudioKit.trimAudio(
            //   //   path: audioFile.path,
            //   //   name: "neww",
            //   //   cutLeft: 0,
            //   //   cutRight: 30,
            //   // );
            //   // var x = DateTime.now().millisecondsSinceEpoch;
            //   // AudioKit.mixMultipleAudio(audioList: audioFile, delayList: ["0","10000","12000"]);
            //   // await AudioKit.customEdit(cmd: "-i ${audioFile[0]} -ss 00:00:10 -to 00:00:30 -af \"afade=t=in:st=0:d=3,afade=t=out:st=27:d=3,volume=0.5\"");
            // }
            var x = await AudioKit. getAllAudioFromDevice();
          },
        ),
      ),
    );
  }
}
