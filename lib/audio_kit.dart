import 'dart:io';
// import 'dart:typed_data';

import 'package:audio_kit/audio_kit_platform_interface.dart';
import 'package:audio_kit/audio_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class AudioKit {
  Future<String?> getPlatformVersion() {
    return AudioKitPlatform.instance.getPlatformVersion();
  }

  ///Return a [File] with type is audio
  static Future<File?> pickFile({bool? pickVideo = false}) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: pickVideo! ? FileType.video : FileType.audio);

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }

  static Future<List<String>> pickMultipleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );
    if (result != null) {
      List<String> files = result.paths.map((path) => path!).toList();
      return files;
    } else {
      return [];
    }
  }

  static Future<bool> trimAudio({
    ///Audio file path
    required String path,
    String? name,
    required int cutRight,
    required int cutLeft,
    String? outputPath,
  }) async {
    if (name == null) {
      var x = DateTime.now().millisecondsSinceEpoch;
      name = 'audio_$x.mp3';
    }
    String dir = "";
    if (outputPath != null) {
      var dowloadPath = await AudioKitPlatform.instance.getDownloadsDirectory();
      dir = '$dowloadPath/$name.mp3';
    } else {
      dir = '$outputPath/$name.mp3';
    }
    return AudioKitPlatform.instance.trimAudio(
        path: path,
        name: name,
        outputPath: dir,
        cutLeft: cutLeft,
        cutRight: cutRight);
  }

  static Future<bool> fadeAudio({
    required String path,
    int? fadeIn,
    int? fadeOut,
    String? name,
    String? outputPath,
  }) async {
    if (name == null) {
      var x = DateTime.now().millisecondsSinceEpoch;
      name = 'audio_$x.mp3';
    }
    String dir = "";
    if (outputPath == null) {
      var dowloadPath = await AudioKitPlatform.instance.getDownloadsDirectory();
      dir = '$dowloadPath/$name.mp3';
    } else {
      dir = '$outputPath/$name.mp3';
    }
    return AudioKitPlatform.instance.fadeAudio(
      path: path,
      outputPath: dir,
      fadeIn: fadeIn,
      fadeOut: fadeOut,
    );
  }

  static Future<bool> extractAudioFromVideo({
    required String path,
    String? name,
    String? outputPath,
  }) async {
    if (name == null) {
      var x = DateTime.now().millisecondsSinceEpoch;
      name = 'audio_$x.mp3';
    }
    String dir = "";
    if (outputPath == null) {
      var dowloadPath = await AudioKitPlatform.instance.getDownloadsDirectory();
      dir = '$dowloadPath/$name.mp3';
    } else {
      dir = '$outputPath/$name.mp3';
    }
    return AudioKitPlatform.instance.extractAudioFromVideo(
      path: path,
      outputPath: dir,
    );
    // try {
    //   ByteData _video = await rootBundle.load(name);
    //   var path = await AudioKitPlatform.instance.getDownloadsDirectory();
    //   var sampleVideo = "${path}/sample_video.mp4";
    //   File _avFile = await File(sampleVideo).create();
    //   await _avFile.writeAsBytes(_video.buffer.asUint8List());
    //   var sampleAudio = "${path}/sample_audio.mp3";
    //   File audioFile = await _avFile.copy(sampleAudio);
    // } catch (e) {
    //   print("etract error: $e");
    // }
    // return true;
  }

  static Future<bool> mergeMultipleAudio({
    required List<String> audioList,
    String? outputPath,
    String? name,
  }) async {
    if (name == null) {
      var x = DateTime.now().millisecondsSinceEpoch;
      name = 'audio_merge_$x';
    }

    var audioLists = audioList.join(";");
    String dir = "";

    if (outputPath == null) {
      var dowloadPath = await AudioKitPlatform.instance.getDownloadsDirectory();
      dir = '$dowloadPath/$name.mp3';
    } else {
      dir = '$outputPath/$name.mp3';
    }
    return AudioKitPlatform.instance.mergeMultipleAudio(
      audioList: audioLists,
      outputPath: dir,
    );
  }

  static Future<ByteData> fileToByteData(String path) async {
    File file = File(path);
    Uint8List bytes = await file.readAsBytes();
    ByteData data = bytes.buffer.asByteData();
    return data;
  }

  static Future<String> getDownloadsDirectory() async {
    var path = await AudioKitPlatform.instance.getDownloadsDirectory();
    return path ?? "";
  }

  ///Get all [Audio] from divice
  static Future<List<Audio>> getAllAudioFromDevice() async {
    var audioList = await AudioKitPlatform.instance.getAllAudioFromDevice();
    return audioList;
  }

  static Future<bool> mixMultipleAudio({
    required List<String> audioList,
    required List<String> delayList,
    String? outputPath,
    String? name,
  }) async {
    if (name == null) {
      var x = DateTime.now().millisecondsSinceEpoch;
      name = 'audio_mix_$x';
    }

    var audioLists = audioList.join(";");
    var delayLists = delayList.join(";");
    String dir = "";

    if (outputPath == null) {
      var dowloadPath = await AudioKitPlatform.instance.getDownloadsDirectory();
      dir = '$dowloadPath/$name.mp3';
    } else {
      dir = '$outputPath/$name.mp3';
    }
    return AudioKitPlatform.instance.mixMultipleAudio(
      audioList: audioLists,
      delayList: delayLists,
      outputPath: dir,
    );
  }

  static Future<bool> customEdit({
    required String cmd,
    String? name,
  }) async {
    if (name == null) {
      var x = DateTime.now().millisecondsSinceEpoch;
      name = 'audio_mix_$x';
    }

    var x = DateTime.now().millisecondsSinceEpoch;

    String dir = "";

    var dowloadPath = await AudioKitPlatform.instance.getDownloadsDirectory();
    dir = '$dowloadPath/$name.mp3';

    cmd = "$cmd $dir";

    return AudioKitPlatform.instance.customEdit(
      cmd: cmd,
    );
  }
}
