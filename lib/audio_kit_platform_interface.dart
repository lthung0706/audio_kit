import 'package:audio_kit/audio_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'audio_kit_method_channel.dart';

abstract class AudioKitPlatform extends PlatformInterface {
  /// Constructs a AudioKitPlatform.
  AudioKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static AudioKitPlatform _instance = MethodChannelAudioKit();

  /// The default instance of [AudioKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelAudioKit].
  static AudioKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AudioKitPlatform] when
  /// they register themselves.
  static set instance(AudioKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getDownloadsDirectory() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> trimAudio({
    required String path,
    required String name,
    int? cutRight,
    int? cutLeft,
    String? outputPath,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> fadeAudio({
    required String path,
    int? fadeIn,
    int? fadeOut,
    String? outputPath,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> extractAudioFromVideo({
    required String path,
    String? outputPath,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> mergeMultipleAudio({
    required String audioList,
    String? outputPath,
  }) {
    throw UnimplementedError('mergeMultipleAudio error');
  }

  Future<List<Audio>> getAllAudioFromDevice() {
    throw UnimplementedError('get All Audio FromDevice error');
  }

  Future<bool> mixMultipleAudio({
    required String audioList,
    required String delayList,
    String? outputPath,
  }) async {
    throw UnimplementedError('mix MultipleAudio error');
  }

   Future<bool> customEdit({
    required String cmd,
  }) async {
    throw UnimplementedError('mix MultipleAudio error');
  }

}
