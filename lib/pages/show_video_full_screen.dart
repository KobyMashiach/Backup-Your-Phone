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
    final VideoPlayerController controller = widget.video;

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
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            controller.value.isPlaying ? controller.pause() : controller.play();
          });
        },
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
