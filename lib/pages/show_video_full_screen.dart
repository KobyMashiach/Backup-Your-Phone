import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShowVideosFullScreen extends StatefulWidget {
  final VideoPlayerController video;
  const ShowVideosFullScreen({Key? key, required this.video}) : super(key: key);

  @override
  State<ShowVideosFullScreen> createState() => _ShowVideosFullScreenState();
}

class _ShowVideosFullScreenState extends State<ShowVideosFullScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.network(widget.videoPath)
  //     ..initialize().then((_) {
  //       setState(() {});
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController _controller = widget.video;

    return Scaffold(
      appBar: ApplicationAppbar(
        title: "Backup Your Phone",
        iconButton: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.video_collection_outlined),
            onPressed: () {}),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
