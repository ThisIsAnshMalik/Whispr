// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/helpers/media_duration_helper.dart';

/// Helper for picking media (video, audio, image) from device or camera.
/// Video and audio are limited to 5 minutes max.
class MediaPickerHelper {
  MediaPickerHelper._();

  static final ImagePicker _imagePicker = ImagePicker();

  /// Records voice using the device microphone (max 5 minutes).
  /// Shows a dialog with Stop/Cancel; returns [XFile] on Stop, null on Cancel or error.
  static Future<XFile?> recordAudio(BuildContext context) async {
    final recorder = AudioRecorder();
    try {
      final hasPermission = await recorder.hasPermission();
      if (!hasPermission) {
        if (context.mounted) {
          CommonSnackbar.showError(
            context,
            message: 'Microphone permission is required to record.',
          );
        }
        return null;
      }

      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      final file = await showDialog<XFile>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => _RecordAudioDialog(recorder: recorder, path: path),
      );
      return file;
    } catch (e) {
      if (context.mounted) {
        CommonSnackbar.showError(
          context,
          message: 'Could not record audio: $e',
        );
      }
      return null;
    } finally {
      recorder.dispose();
    }
  }

  /// Picks a video from [source] (gallery or camera). Max duration 5 minutes.
  /// Returns [XFile] on success, null if cancelled, on error, or if video exceeds 5 min.
  static Future<XFile?> pickVideo(
    BuildContext context, {
    required ImageSource source,
  }) async {
    try {
      final file = await _imagePicker.pickVideo(source: source);
      if (file == null || !context.mounted) return file;
      final duration = await MediaDurationHelper.getVideoDuration(file.path);
      if (!MediaDurationHelper.isWithinLimit(duration)) {
        CommonSnackbar.showError(
          context,
          message: 'Video must be 5 minutes or less.',
        );
        return null;
      }
      return file;
    } catch (e) {
      if (context.mounted) {
        CommonSnackbar.showError(context, message: 'Could not pick video: $e');
      }
      return null;
    }
  }

  /// Picks an audio file from the device. Max duration 5 minutes.
  /// Returns [XFile] on success, null if cancelled, on error, or if audio exceeds 5 min.
  static Future<XFile?> pickAudio(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );
      final path = result?.files.singleOrNull?.path;
      if (path == null) return null;
      if (!context.mounted) return XFile(path);
      final duration = await MediaDurationHelper.getAudioDuration(path);
      if (!MediaDurationHelper.isWithinLimit(duration)) {
        CommonSnackbar.showError(
          context,
          message: 'Audio must be 5 minutes or less.',
        );
        return null;
      }
      return XFile(path);
    } catch (e) {
      if (context.mounted) {
        CommonSnackbar.showError(context, message: 'Could not pick audio: $e');
      }
      return null;
    }
  }

  // /// Picks an image from [source] (gallery or camera).
  // /// Returns [XFile] on success, null if cancelled or on error.
  // static Future<XFile?> pickImage(
  //   BuildContext context, {
  //   required ImageSource source,
  // }) async {
  //   try {
  //     final file = await _imagePicker.pickImage(source: source);
  //     return file;
  //   } catch (e) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Could not pick image: $e'),
  //           backgroundColor: Colors.red.shade700,
  //         ),
  //       );
  //     }
  //     return null;
  //   }
  // }
}

class _RecordAudioDialog extends StatefulWidget {
  final AudioRecorder recorder;
  final String path;

  const _RecordAudioDialog({required this.recorder, required this.path});

  @override
  State<_RecordAudioDialog> createState() => _RecordAudioDialogState();
}

class _RecordAudioDialogState extends State<_RecordAudioDialog> {
  bool _isRecording = false;
  bool _isStopping = false;
  int _elapsedSeconds = 0;
  bool _elapsedTimerStarted = false;
  static const int _maxSeconds = 5 * 60; // 5 minutes

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startRecording());
  }

  Future<void> _startRecording() async {
    try {
      await widget.recorder.start(const RecordConfig(), path: widget.path);
      if (mounted) {
        setState(() => _isRecording = true);
        _startElapsedTimer();
      }
    } catch (e) {
      if (mounted) {
        CommonSnackbar.showError(
          context,
          message: 'Failed to start recording: $e',
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_isStopping) return;
    setState(() => _isStopping = true);
    try {
      await widget.recorder.stop();
      if (mounted) {
        Navigator.of(context).pop(XFile(widget.path));
      }
    } catch (e) {
      if (mounted) {
        CommonSnackbar.showError(
          context,
          message: 'Failed to save recording: $e',
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _cancelRecording() async {
    if (_isStopping) return;
    setState(() => _isStopping = true);
    try {
      await widget.recorder.cancel();
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record voice'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isRecording ? Icons.mic : Icons.mic_none,
            size: 48,
            color: _isRecording ? Colors.red : Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _isRecording
                ? 'Recording... Tap Stop when done. (Max 5 min)'
                : 'Starting...',
            textAlign: TextAlign.center,
          ),
          if (_isRecording) ...[
            const SizedBox(height: 12),
            Text(
              '${_formatTime(_elapsedSeconds)} / ${_formatTime(_maxSeconds)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isStopping ? null : _cancelRecording,
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: (_isRecording && !_isStopping) ? _stopRecording : null,
          child: const Text('Stop & use'),
        ),
      ],
    );
  }

  void _startElapsedTimer() {
    if (_elapsedTimerStarted) return;
    _elapsedTimerStarted = true;
    void tick() {
      if (!mounted || _isStopping) return;
      final next = _elapsedSeconds + 1;
      setState(() => _elapsedSeconds = next);
      if (next >= _maxSeconds) {
        _stopRecording();
      } else {
        Future.delayed(const Duration(seconds: 1), tick);
      }
    }

    Future.delayed(const Duration(seconds: 1), tick);
  }
}
