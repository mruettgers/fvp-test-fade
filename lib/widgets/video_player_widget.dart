import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class VideoPlayerWidget extends StatefulWidget {
  final String src;
  final Function onCompleted;

  const VideoPlayerWidget({
    super.key,
    required this.src,
    required this.onCompleted,
  });

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final VideoPlayerController _videoPlayerController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    print('Initializing video player (key: ${widget.key})');
    _isInitialized = false;

    _videoPlayerController = VideoPlayerController.asset(widget.src);

    _videoPlayerController.initialize().then((_) async {
      _videoPlayerController.addListener(() {
        if (_isInitialized &&
            _videoPlayerController.value.isCompleted &&
            _videoPlayerController.value.position >=
                _videoPlayerController.value.duration) {
          widget.onCompleted();
        }
      });
      setState(() {
        _isInitialized = true;
      });
      _videoPlayerController.play();
    });
  }

  @override
  void dispose() {
    print('VideoPlayerWidget disposing (key: ${widget.key})');
    print('VideoController disposing (key: ${widget.key})');
    _videoPlayerController.dispose();
    print('VideoController disposed (key: ${widget.key})');
    super.dispose();
    print('VideoPlayerWidget disposed (key: ${widget.key})');
  }

  @override
  Widget build(BuildContext context) {
    return !_isInitialized
        ? const Center(
          key: ValueKey('loading'),
          child: CircularProgressIndicator(),
        )
        : AspectRatio(
          key: ValueKey('video'),
          aspectRatio: _videoPlayerController.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController),
        );
  }
}
