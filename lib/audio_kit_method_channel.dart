// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:audio_kit/audio_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import 'audio_kit_platform_interface.dart';

/// An implementation of [AudioKitPlatform] that uses method channels.
class MethodChannelAudioKit extends AudioKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('audio_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> cancelKit() async {
    final version =
        await methodChannel.invokeMethod<String>('cancelKit');
    return version;
  }

  @override
  Future<bool> trimAudio({
    required String path,
    required String name,
    int? cutRight,
    int? cutLeft,
    String? outputPath,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('trimAudio', {
      'name': name,
      'path': path,
      'cutLefts': cutLeft,
      'cutRights': cutRight,
      'outPath': outputPath,
    });

    print("trim: $result");

    return result ?? false;
  }

  @override
  Future<bool> fadeAudio({
    required String path,
    int? fadeIn,
    int? fadeOut,
    String? outputPath,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('fadeAudio', {
      'path': path,
      'fadeIn': fadeIn,
      'fadeOut': fadeOut,
      'outPath': outputPath,
    });

    print("fade: $result");

    return result ?? false;
  }

  @override
  Future<bool> extractAudioFromVideo({
    required String path,
    String? outputPath,
  }) async {
    final result =
        await methodChannel.invokeMethod<bool>('extractAudioFromVideo', {
      'path': path,
      'outPath': outputPath,
    });

    print("extractAudioFromVideo: $result");

    return result ?? false;
  }

  @override
  Future<bool> mergeMultipleAudio({
    required String audioList,
    String? outputPath,
  }) async {
    final result =
        await methodChannel.invokeMethod<bool>('mergeMultipleAudio', {
      'audioList': audioList,
      'outPath': outputPath,
    });

    print("mergeMultipleAudio: $result");

    return result ?? false;
  }

  @override
  Future<String?> getDownloadsDirectory() async {
    final result = await methodChannel.invokeMethod<String>('getDownloadPath');
    return result;
  }

  @override
  Future<List<Audio>> getAllAudioFromDevice() async {
    final String resultJson = await methodChannel.invokeMethod('getAllAudio');
    final List<dynamic> audioListJson = jsonDecode(resultJson);
    final List<Audio> audioList =
        audioListJson.map((json) => Audio.fromJson(json)).toList();
    var newAudioList = await getAudioData(audioList);

    // Chờ cho tất cả các tác vụ hoàn thành
    // await Future.wait(futures);
    return newAudioList;
  }

  Future getAudioData(List<Audio> audioList) async {
    for (var element in audioList) {
      try {
        MetadataRetriever.fromFile(
          File(element.path ?? ""),
        ).then(
          (metadata) {
            element.imageArt = metadata.albumArt;
          },
        ).catchError((e) {
          print("error: $e");
        });
      } catch (e) {
        print(e.toString());
      }
    }
    return audioList;
  }

  @override
  Future<bool> mixMultipleAudio(
      {required String audioList,
      required String delayList,
      String? outputPath,
      required String fadeTimes,
      required String volumne,
      required String startFadeOuts}) async {
    final result = await methodChannel.invokeMethod<bool>('mixAudio', {
      'audioList': audioList,
      'delays': delayList,
      'outPath': outputPath,
      'fadeTimes': fadeTimes,
      'volume': volumne,
      'startFadeOuts': startFadeOuts,
    });

    print("mixAudio: $result");

    return result ?? false;
  }

  @override
  Future<bool> customEdit({
    required String cmd,
  }) async {
    var result = await methodChannel.invokeMethod<bool>('customEdit', {
      'cmd': cmd,
    });

    print("customEdit: $result");

    return result ?? false;
  }
}
