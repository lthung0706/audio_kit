package com.example.audio_kit

//import com.arthenica.ffmpegkit.FFmpegKit
//import com.arthenica.ffmpegkit.ReturnCode
//import com.arthenica.mobileffmpeg.FFmpeg

import android.content.Context
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import com.arthenica.mobileffmpeg.FFmpeg
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.io.BufferedReader
import java.io.InputStreamReader
import io.flutter.plugin.common.MethodChannel.Result



/** AudioKitPlugin */
class AudioKitPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var context: Context

  private var isExecuting = false
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "audio_kit")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")

    } else if (call.method == "getDownloadPath") {
      result.success(getDownloadsDirectory())
    } else if (call.method == "trimAudio") {
      val name = call.argument<String>("name") ?: ""
      val path = call.argument<String>("path") ?: ""
      val outPath = call.argument<String>("outPath") ?: ""
      val cutRights = call.argument<Int?>("cutRights") ?: 0
      val cutLefts = call.argument<Int?>("cutLefts") ?: 0
      val isSuccess = trimAudio(name, path,cutLefts, cutRights, outPath)

      result.success(isSuccess)
    } else if (call.method == "fadeAudio"){
      val path = call.argument<String>("path") ?: ""
      val fadeIn = call.argument<Int?>("fadeIn") ?: 0
      val fadeOut = call.argument<Int?>("fadeOut") ?: 0
      val outPath = call.argument<String>("outPath") ?: ""

      val isSuccess = fadeAudio(path,fadeIn,outPath)
      result.success(isSuccess)
    }
    else if(call.method=="extractAudioFromVideo"){
      val path = call.argument<String>("path") ?: ""
      val outPath = call.argument<String>("outPath") ?: ""
      println("text durion")

      val isSuccess = extractAudioFromVideo(path,outPath)
      println("text durion")

      result.success(isSuccess)
    } else if(call.method=="mergeMultipleAudio"){
      val audioList = call.argument<String>("audioList") ?: ""
      val outPath = call.argument<String>("outPath") ?: ""
      val itemList = audioList.split(";")
      println("inputFiles: ${audioList}")

      val  isSuccess = mergeMultipleAudio(itemList,outPath);
      result.success(isSuccess)
    }
    else if (call.method == "getAllAudio") {
      val audioList = getAllAudioFromDevice(context)
      val gson = Gson()
      val audioListJson = gson.toJson(audioList)
      result.success(audioListJson)
    }
    else if(call.method == "cancelCutAudio"){
      cancelExecution()
    } else if(call.method == "mixAudio"){
      val audioList = call.argument<String>("audioList") ?: ""
      val delays = call.argument<String>("delays") ?: ""
      val outPath = call.argument<String>("outPath") ?: ""
      val audioLists = audioList.split(";")
      val delayLists = delays.split(";")

      val  isSuccess = mixAudio(audioLists,delayLists,outPath)


    }else if(call.method=="customEdit"){
      val cmd = call.argument<String>("cmd") ?: ""

      println("custom cmd: ${cmd}")

      val  isSuccess = customEdit(cmd);
      result.success(isSuccess)
    } else {
      result.notImplemented()
    }
  }
  private fun trimAudio(name: String, path: String, cutLefts: Int, cutRights: Int, outPath: String): Boolean {
    val cmd = arrayOf(
      "-y",
      "-i", path,
      "-vn",
      "-ss", cutLefts.toString(),
      "-to", cutRights.toString(),
      "-ar", "16k",
      "-ac", "2",
      "-b:a", "96k",
      "-acodec", "libmp3lame",
      outPath
    )
    return try {
      isExecuting = true
      val rc = FFmpeg.execute(cmd)
      isExecuting = false
      if (rc == 0) {
        println("Cut successful: $outPath")
        true
      } else {
        println("Lỗi khi cắt file âm thanh")
        false
      }
    } catch (e: Exception) {
      println("Error cutting audio: $e")
      false
    }
    return true;
  }

  private fun fadeAudio(path: String, fadeDuration: Int, outPath: String): Boolean {
    val cmd = arrayOf(
      "-y",
      "-i", path,
      "-af", "afade=t=in:ss=0:d=$fadeDuration,afade=t=out:st=${getAudioDuration(path) - fadeDuration}:d=$fadeDuration",
      "-ar", "16k",
      "-ac", "2",
      "-b:a", "96k",
      "-acodec", "libmp3lame",
      outPath
    )

    return try {
      isExecuting = true
      val rc = FFmpeg.execute(cmd)
      isExecuting = false
      if (rc == 0) {
        println("Fade successful: $outPath")
        true
      } else {
        println("Error fading audio")
        false
      }
    } catch (e: Exception) {
      println("Error fading audio: $e")
      false
    }
    return  true;
  }

  private fun extractAudioFromVideo(videoPath: String, audioPath: String): Boolean {
    val cmd = arrayOf(
      "-i $videoPath -vn -ab 320 $audioPath"
    )
    println("text durion")


    return try {
      isExecuting = true
      val rc = FFmpeg.execute("-i $videoPath -vn $audioPath")
//      println("text durion"+rc.duration)
      isExecuting = false
      if (rc==0) {
        println("Fade successful: $audioPath")
        true
      } else {
        println("Error fading audio")
        false
      }
    } catch (e: Exception) {
      println("Error fading audio: $e")
      false
    }
  }

  private fun mergeMultipleAudio(audioList: List<String>, audioPath: String): Boolean {

    val inputFiles = audioList.joinToString(separator = " ") { "-i $it" }
    val filterComplex = "[${(0 until audioList.size).joinToString("][") { "$it:a" }}]"
    val concatCommand = "amix=inputs=${audioList.size}:duration=first:dropout_transition=${audioList.size}"
    val outputCommand = "output.mp3"
    println("inputFiles: $inputFiles")

    println("text durion")


    return try {
      isExecuting = true
      val rc = FFmpeg.execute("$inputFiles -filter_complex [0:0][1:0] amix=inputs=2:duration=longest -c:a $audioPath")
//      println("text durion"+rc.duration)
      isExecuting = false
      if (rc==0) {
        println("merge Multiple Audio successful: $audioPath")
        true
      } else {
        println("Error merge Multiple Audio")
        false
      }
    } catch (e: Exception) {
      println("Error merge Multiple Audio\": $e")
      false
    }
  }

  private fun getAudioDuration(path: String): Int {
    val cmd = arrayOf(
      "-i", path,
      "-f", "null",
      "-"
    )

    try {
      val processBuilder = ProcessBuilder(*cmd)
      val process = processBuilder.start()

      val reader = BufferedReader(InputStreamReader(process.errorStream))
      var line: String?
      var durationInSeconds = 0

      while (reader.readLine().also { line = it } != null) {
        if (line!!.contains("Duration:")) {
          val durationString = line!!.substringAfter("Duration:").substringBefore(",")
          durationInSeconds = parseDurationString(durationString)
          break
        }
      }

      process.waitFor()
      return durationInSeconds
    } catch (e: Exception) {
      e.printStackTrace()
    }

    return 0
  }

  private fun parseDurationString(durationString: String): Int {
    val parts = durationString.trim().split(":")
    val hours = parts[0].toIntOrNull() ?: 0
    val minutes = parts[1].toIntOrNull() ?: 0
    val seconds = parts[2].toFloatOrNull() ?: 0f
    return ((hours * 3600) + (minutes * 60) + seconds).toInt()
  }


  private fun getAllAudioFromDevice(context: Context): List<AudioModel>? {
    val tempAudioList: MutableList<AudioModel> = ArrayList()
    val uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    val projection = arrayOf(
      MediaStore.Audio.AudioColumns.DATA,
      MediaStore.Audio.AudioColumns.TITLE, MediaStore.Audio.AudioColumns.ALBUM,
      MediaStore.Audio.ArtistColumns.ARTIST,
      MediaStore.Audio.AudioColumns.DURATION,
      MediaStore.Audio.AudioColumns.SIZE,
    )
    val c = context.contentResolver.query(
      uri,
      projection,
      null,
      null,
      null
    )
    if (c != null) {
      while (c.moveToNext()) {
        val audioModel = AudioModel()
        val path = c.getString(0)
        val name = c.getString(1)
        val album = c.getString(2)
        val artist = c.getString(3)
        val duration = c.getString(4)
        val size = c.getString(5)

        audioModel.setaName(name)
        audioModel.setaAlbum(album)
        audioModel.setaArtist(artist)
        audioModel.setaPath(path)
        audioModel.setaSize(size)
        audioModel.setaDuration(duration)
        Log.e("Name :$name", " Album :$album")
        Log.e("Path :$path", " Artist :$artist")

        tempAudioList.add(audioModel)

      }
      c.close()
    }
    return tempAudioList
  }

  private fun mixAudio(audioPaths: List<String>,delays: List<String>, outPath: String
  ):Boolean {
    println("dalays: $delays")

    val inputOptions = audioPaths.mapIndexed { index, path ->
      "-i $path"
    }.joinToString(" ")

    val filterDelayOptions = delays.mapIndexed { index, delay ->
      "[$index:a]adelay=$delay|$delay[a$index];"
    }.joinToString("")

    val filterInputs = delays.indices.joinToString("") { "[a$it]" }

    val command = "$inputOptions -filter_complex \"$filterDelayOptions$filterInputs amix=inputs=${audioPaths.size}:duration=longest:dropout_transition=${audioPaths.size}\" -codec:a libmp3lame -q:a 0 $outPath"


    println("command: $command")

    return try {
      isExecuting = true
      val rc = FFmpeg.execute(command)
//      println("text durion"+rc.duration)
      isExecuting = false
      if (rc==0) {
        println("Mix Multiple Audio successful")
        true
      } else {
        println("Error mix Multiple Audio")
        false
      }
    } catch (e: Exception) {
      println("Error mix Multiple Audio\": $e")
      false
    }
  }

  fun customEdit(cmd: String):Boolean {
    return try {
      isExecuting = true
      val rc = FFmpeg.execute(cmd)
//      println("text durion"+rc.duration)
      isExecuting = false
      println("rc: $rc")
      if (rc==0) {
        println("custom edit Audio successful")
        true
      } else {
        println("custom edit Audio Error")
        false
      }
    } catch (e: Exception) {
      println("custom edit Audio Error\": $e")
      false
    }
  }


  fun cancelExecution() {
    if(isExecuting){
      isExecuting = false
      FFmpeg.cancel()
    }
  }
  private fun getDownloadsDirectory(): String {
    return Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).absolutePath
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
