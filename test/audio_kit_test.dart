// import 'package:flutter_test/flutter_test.dart';
// import 'package:audio_kit/audio_kit.dart';
// import 'package:audio_kit/audio_kit_platform_interface.dart';
// import 'package:audio_kit/audio_kit_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockAudioKitPlatform
//     with MockPlatformInterfaceMixin
//     implements AudioKitPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final AudioKitPlatform initialPlatform = AudioKitPlatform.instance;

//   test('$MethodChannelAudioKit is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelAudioKit>());
//   });

//   test('getPlatformVersion', () async {
//     AudioKit audioKitPlugin = AudioKit();
//     MockAudioKitPlatform fakePlatform = MockAudioKitPlatform();
//     AudioKitPlatform.instance = fakePlatform;

//     expect(await audioKitPlugin.getPlatformVersion(), '42');
//   });
// }
