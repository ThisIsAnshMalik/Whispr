import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

/// Max allowed duration for video and audio (5 minutes).
const Duration kMaxMediaDuration = Duration(minutes: 5);

/// Helper to get video/audio duration from file paths.
class MediaDurationHelper {
  MediaDurationHelper._();

  /// Returns video duration, or null on error.
  static Future<Duration?> getVideoDuration(String path) async {
    if (path.isEmpty) return null;
    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.file(File(path));
      await controller.initialize();
      final duration = controller.value.duration;
      return duration;
    } catch (_) {
      return null;
    } finally {
      await controller?.dispose();
    }
  }

  /// Returns audio duration, or null on error.
  static Future<Duration?> getAudioDuration(String path) async {
    if (path.isEmpty) return null;
    final player = AudioPlayer();
    try {
      final duration = await player.setFilePath(path);
      return duration;
    } catch (_) {
      return null;
    } finally {
      await player.dispose();
    }
  }

  /// Returns true if [duration] is within the max allowed (5 min).
  static bool isWithinLimit(Duration? duration) {
    if (duration == null) return true;
    return duration <= kMaxMediaDuration;
  }
}
