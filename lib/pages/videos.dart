import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:flutter/material.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppbar(
        title: "Backup Your Phone",
        iconButton: IconButton(
            onPressed: () {
              uploadVideo();
            },
            icon: const Icon(Icons.video_file_outlined)),
      ),
      floatingActionButton: const ApplicationFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const ApplicationButtonbar(),
      body: const Text("Video"),
    );
  }
}

uploadVideo() {}
