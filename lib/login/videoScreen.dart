// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackground extends StatefulWidget {
  const VideoBackground({super.key});

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _vidController;
  String? _error;

  @override
  void initState() {
    super.initState();

    _vidController =
        VideoPlayerController.asset('assets/videos/login_bg_vid.mp4');

    _vidController.initialize().then((_) {
      print("Video initialized, size: ${_vidController.value.size}");
      setState(() {});
      _vidController.setLooping(true);
      _vidController.play();
    }).catchError((error) {
      print("error: $error");
      setState(() {
        _error = 'Video failed to load: $error';
      });
    });
  }

  @override
  void dispose() {
    _vidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!_vidController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _vidController.value.size.width,
          height: _vidController.value.size.height,
          child: VideoPlayer(_vidController),
        ),
      ),
    );
  }
}
