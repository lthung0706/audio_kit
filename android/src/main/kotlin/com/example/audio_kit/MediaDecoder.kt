package com.example.audio_kit;

import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaCodec
import android.media.MediaExtractor
import android.media.MediaFormat
import java.io.File
import java.nio.ByteBuffer
import kotlin.math.abs

class MediaDecoder {

    private val SAMPLE_RATE = 44100
    private val CHANNEL_CONFIG = AudioFormat.CHANNEL_IN_MONO
    private val AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT
    private val BUFFER_SIZE = AudioRecord.getMinBufferSize(SAMPLE_RATE, CHANNEL_CONFIG, AUDIO_FORMAT)

    fun generateWaveform(filePath: String): List<Double> {
        val mediaExtractor = MediaExtractor()
        mediaExtractor.setDataSource(filePath)
        val trackIndex = selectTrack(mediaExtractor)
        mediaExtractor.selectTrack(trackIndex)
        val mediaFormat = mediaExtractor.getTrackFormat(trackIndex)
        val codec = MediaCodec.createDecoderByType(mediaFormat.getString(MediaFormat.KEY_MIME) ?: "")
        codec.configure(mediaFormat, null, null, 0)
        codec.start()

        val bufferInfo = MediaCodec.BufferInfo()
        val byteBuffer = ByteBuffer.allocate(BUFFER_SIZE)
        val audioSamples = mutableListOf<Double>()

        var outputDone = false
        while (!outputDone) {
            val inputBufferIndex = codec.dequeueInputBuffer(10000)
            if (inputBufferIndex >= 0) {
                val sampleSize = mediaExtractor.readSampleData(byteBuffer, 0)
                if (sampleSize < 0) {
                    codec.queueInputBuffer(inputBufferIndex, 0, 0, 0, MediaCodec.BUFFER_FLAG_END_OF_STREAM)
                    outputDone = true
                } else {
                    val presentationTimeUs = mediaExtractor.sampleTime
                    codec.queueInputBuffer(inputBufferIndex, 0, sampleSize, presentationTimeUs, 0)
                    mediaExtractor.advance()
                }
            }

            val outputBufferIndex = codec.dequeueOutputBuffer(bufferInfo, 10000)
            if (outputBufferIndex >= 0) {
                val outputBuffer = codec.getOutputBuffer(outputBufferIndex)
                val pcmData = ShortArray(bufferInfo.size / 2)
                outputBuffer?.asShortBuffer()?.get(pcmData)
                audioSamples.addAll(pcmData.map { it.toDouble() })
                codec.releaseOutputBuffer(outputBufferIndex, false)
            } else if (outputBufferIndex == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED || outputBufferIndex == MediaCodec.INFO_TRY_AGAIN_LATER) {
                // do nothing
            }
        }

        codec.stop()
        codec.release()
        mediaExtractor.release()

        return calculateWaveform(audioSamples)
    }

    private fun selectTrack(extractor: MediaExtractor): Int {
        val numTracks = extractor.trackCount
        for (i in 0 until numTracks) {
            val format = extractor.getTrackFormat(i)
            val mime = format.getString(MediaFormat.KEY_MIME)
            if (mime?.startsWith("audio/") == true) {
                return i
            }
        }
        return -1
    }

    private fun calculateWaveform(samples: List<Double>): List<Double> {
        val sampleRate = SAMPLE_RATE.toDouble()
        val chunkSize = samples.size / 20
        val waveform = mutableListOf<Double>()
        for (i in 0 until 20) {
            var sum = 0.0
            for (j in 0 until chunkSize) {
                sum += abs(samples[i * chunkSize + j])
            }
            waveform.add(sum / chunkSize)
        }
        return waveform
    }
}



