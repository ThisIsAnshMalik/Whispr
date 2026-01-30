import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Helper for picking media (video, audio, image) from device or camera.
/// Handles errors by showing a SnackBar when [BuildContext] is still mounted.
class MediaPickerHelper {
  MediaPickerHelper._();

  static final ImagePicker _imagePicker = ImagePicker();

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
