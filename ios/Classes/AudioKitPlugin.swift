import Flutter
import UIKit
import AVFoundation
import MobileCoreServices
import ffmpegkit

public class AudioKitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "audio_kit", binaryMessenger: registrar.messenger())
    let instance = AudioKitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      
    case "getDownloadPath":
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      result(paths[0].path)
      
    case "customEdit":
      guard let args = call.arguments as? [String: Any],
            let cmd = args["cmd"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", 
                           message: "Missing command argument", 
                           details: nil))
        return
      }
      
      // Execute FFmpeg command
      executeFFmpegCommand(cmd) { success in
        result(success)
      }
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func executeFFmpegCommand(_ command: String, completion: @escaping (Bool) -> Void) {
    FFmpegKit.executeAsync(command) { session in
      guard let returnCode = session?.getReturnCode() else {
        completion(false)
        return
      }
      
      if ReturnCode.isSuccess(returnCode) {
        print("FFmpeg command completed successfully")
        completion(true)
      } else {
        print("FFmpeg command failed with state \(returnCode.description)")
        completion(false)
      }
    }
  }
}
