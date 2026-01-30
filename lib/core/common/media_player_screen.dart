// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:video_player/video_player.dart';
import 'package:whispr_app/core/assets/image_assets.dart';
import 'package:whispr_app/core/common/common_text.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

/// Media player screen for playing video or audio files.
class MediaPlayerScreen extends StatefulWidget {
  final String mediaPath;
  final bool isVideo;
  final String? caption;

  const MediaPlayerScreen({
    super.key,
    required this.mediaPath,
    required this.isVideo,
    this.caption,
  });

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  // Video player
  VideoPlayerController? _videoController;

  // Audio player
  just_audio.AudioPlayer? _audioPlayer;

  // Stream subscriptions for cleanup
  final List<StreamSubscription> _subscriptions = [];

  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _hasError = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      if (widget.isVideo) {
        await _initializeVideoPlayer();
      } else {
        await _initializeAudioPlayer();
      }
    } catch (e) {
      debugPrint('Error initializing player: $e');
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  Future<void> _initializeVideoPlayer() async {
    _videoController = VideoPlayerController.file(File(widget.mediaPath));
    await _videoController!.initialize();

    _videoController!.addListener(_videoListener);

    if (mounted) {
      setState(() {
        _isInitialized = true;
        _duration = _videoController!.value.duration;
      });
      // Auto-play
      _videoController!.play();
    }
  }

  void _videoListener() {
    if (mounted && _videoController != null) {
      setState(() {
        _position = _videoController!.value.position;
        _duration = _videoController!.value.duration;
        _isPlaying = _videoController!.value.isPlaying;
      });
    }
  }

  Future<void> _initializeAudioPlayer() async {
    _audioPlayer = just_audio.AudioPlayer();
    await _audioPlayer!.setFilePath(widget.mediaPath);

    // Store subscriptions for cleanup
    _subscriptions.add(
      _audioPlayer!.positionStream.listen((position) {
        if (mounted) {
          setState(() => _position = position);
        }
      }),
    );

    _subscriptions.add(
      _audioPlayer!.durationStream.listen((duration) {
        if (mounted && duration != null) {
          setState(() => _duration = duration);
        }
      }),
    );

    _subscriptions.add(
      _audioPlayer!.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
          });
        }
      }),
    );

    if (mounted) {
      setState(() => _isInitialized = true);
      // Auto-play
      _audioPlayer!.play();
    }
  }

  void _togglePlayPause() {
    if (!_isInitialized) return;

    if (widget.isVideo && _videoController != null) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    } else if (_audioPlayer != null) {
      if (_audioPlayer!.playing) {
        _audioPlayer!.pause();
      } else {
        _audioPlayer!.play();
      }
    }
  }

  void _seekTo(Duration position) {
    if (!_isInitialized) return;

    if (widget.isVideo && _videoController != null) {
      _videoController!.seekTo(position);
    } else if (_audioPlayer != null) {
      _audioPlayer!.seek(position);
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();

    // Remove video listener before disposing
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppPallete.whiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: CommonText(
          text: widget.isVideo ? 'Video' : 'Audio',
          fontSize: 0.02.sh,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Media display area
            Expanded(child: Center(child: _buildMediaContent())),

            // Caption if available
            if (widget.caption != null && widget.caption!.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
                child: CommonText(
                  text: widget.caption!,
                  fontSize: 0.014.sh,
                  color: AppPallete.whiteColor.withOpacity(0.8),
                  textAlign: TextAlign.center,
                  maxLine: 3,
                ),
              ),
              SizedBox(height: 0.02.sh),
            ],

            // Controls
            if (_isInitialized && !_hasError) _buildControls(),
            SizedBox(height: 0.03.sh),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    if (_hasError) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 0.1.sh),
          SizedBox(height: 0.02.sh),
          CommonText(
            text: 'Failed to load media',
            fontSize: 0.016.sh,
            color: AppPallete.whiteColor.withOpacity(0.7),
          ),
        ],
      );
    }

    if (!_isInitialized) {
      return CircularProgressIndicator(
        color: AppPallete.whiteColor,
        strokeWidth: 2,
      );
    }

    if (widget.isVideo) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else {
      // Audio visualization
      return _buildAudioVisualization();
    }
  }

  Widget _buildAudioVisualization() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Album art / audio icon
        Container(
          width: 0.5.sw,
          height: 0.5.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppPallete.primaryColor, AppPallete.secondaryColor],
            ),
            boxShadow: [
              BoxShadow(
                color: AppPallete.primaryColor.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  ImageAssets.audioExImg,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // Overlay with audio icon
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppPallete.blackColor.withOpacity(0.4),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      _isPlaying ? Icons.music_note : Icons.music_off,
                      color: AppPallete.whiteColor,
                      size: 0.12.sh,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 0.04.sh),
        CommonText(
          text: 'Audio Confession',
          fontSize: 0.022.sh,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
      child: Column(
        children: [
          // Progress bar
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: AppPallete.primaryColor,
              inactiveTrackColor: AppPallete.whiteColor.withOpacity(0.2),
              thumbColor: AppPallete.whiteColor,
              overlayColor: AppPallete.primaryColor.withOpacity(0.2),
            ),
            child: Slider(
              value: _duration.inMilliseconds > 0
                  ? _position.inMilliseconds / _duration.inMilliseconds
                  : 0,
              onChanged: (value) {
                final newPosition = Duration(
                  milliseconds: (value * _duration.inMilliseconds).round(),
                );
                _seekTo(newPosition);
              },
            ),
          ),

          // Time labels
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: _formatDuration(_position),
                  fontSize: 0.012.sh,
                  color: AppPallete.whiteColor.withOpacity(0.7),
                ),
                CommonText(
                  text: _formatDuration(_duration),
                  fontSize: 0.012.sh,
                  color: AppPallete.whiteColor.withOpacity(0.7),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.02.sh),

          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rewind 10s
              IconButton(
                onPressed: () {
                  final newPosition = _position - const Duration(seconds: 10);
                  _seekTo(
                    newPosition < Duration.zero ? Duration.zero : newPosition,
                  );
                },
                icon: Icon(
                  Icons.replay_10,
                  color: AppPallete.whiteColor,
                  size: 0.035.sh,
                ),
              ),
              SizedBox(width: 0.04.sw),

              // Play/Pause button
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  padding: EdgeInsets.all(0.025.sh),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppPallete.primaryColor,
                        AppPallete.secondaryColor,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppPallete.primaryColor.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppPallete.whiteColor,
                    size: 0.04.sh,
                  ),
                ),
              ),
              SizedBox(width: 0.04.sw),

              // Forward 10s
              IconButton(
                onPressed: () {
                  final newPosition = _position + const Duration(seconds: 10);
                  _seekTo(newPosition > _duration ? _duration : newPosition);
                },
                icon: Icon(
                  Icons.forward_10,
                  color: AppPallete.whiteColor,
                  size: 0.035.sh,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
