// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Helper for picking media (video, audio, image) from device or camera.
/// Handles errors by showing a SnackBar when [BuildContext] is still mounted.
class MediaPickerHelper {
  MediaPickerHelper._();

  static final ImagePicker _imagePicker = ImagePicker();

  /// Records voice using the device microphone.
  /// Shows a dialog with Stop/Cancel; returns [XFile] on Stop, null on Cancel or error.
  static Future<XFile?> recordAudio(BuildContext context) async {
    final recorder = AudioRecorder();
    try {
      final hasPermission = await recorder.hasPermission();
      if (!hasPermission) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission is required to record.'),
              backgroundColor: Colors.red,
            ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not record audio: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
      return null;
    } finally {
      recorder.dispose();
    }
  }

  /// Picks a video from [source] (gallery or camera).
  /// Returns [XFile] on success, null if cancelled or on error.
  static Future<XFile?> pickVideo(
    BuildContext context, {
    required ImageSource source,
  }) async {
    try {
      final file = await _imagePicker.pickVideo(source: source);
      return file;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick video: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
      return null;
    }
  }

  /// Picks an audio file from the device.
  /// Returns [XFile] on success, null if cancelled or on error.
  static Future<XFile?> pickAudio(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );
      final path = result?.files.singleOrNull?.path;
      if (path != null) {
        return XFile(path);
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick audio: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startRecording());
  }

  Future<void> _startRecording() async {
    try {
      await widget.recorder.start(const RecordConfig(), path: widget.path);
      if (mounted) setState(() => _isRecording = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start recording: $e')),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save recording: $e')));
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
            _isRecording ? 'Recording... Tap Stop when done.' : 'Starting...',
            textAlign: TextAlign.center,
          ),
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
}
