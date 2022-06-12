// ignore_for_file: avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:backup_your_phone/pages/show_video_full_screen.dart';
import 'package:backup_your_phone/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

List<String> videos = [];

// view videos page
class VideosPage extends StatefulWidget {
  const VideosPage({Key? key}) : super(key: key);
  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final user = FirebaseAuth.instance.currentUser;
  late final List<VideoPlayerController> _controllers = [];

  VideoPlayerController getNewController(String path) {
    return VideoPlayerController.network(path)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getFirebaseVideosFolder(),
        // check if have videos files on firebase => if not view loading
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            buildVideos();
            return Scaffold(
              appBar: ApplicationAppbar(
                title: "Backup Your Phone",
                iconButton: IconButton(
                    onPressed: () {
                      selectFile(context);
                    },
                    icon: const Icon(Icons.video_camera_back_outlined)),
              ),
              floatingActionButton: const ApplicationFloatingActionButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: const ApplicationButtonbar(),
              body: GridView.builder(
                itemCount: videos.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  // grid view
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {}, //open file check
                    child: Card(
                      // shape of videos
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white30, width: 3),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.white12,
                      child: InkWell(
                        onTap: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ShowVideosFullScreen(
                                // open new page to show the pdf in full screen
                                video: _controllers[index],
                              ),
                            ),
                          );
                        },
                        child: _controllers[index].value.isInitialized
                            ? InkWell(
                                onTap: () {
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          ShowVideosFullScreen(
                                        // open new page to show the video in full screen
                                        video: _controllers[index],
                                      ),
                                    ),
                                  );
                                },
                                child: AspectRatio(
                                  aspectRatio:
                                      _controllers[index].value.aspectRatio,
                                  child: Stack(
                                    children: [
                                      VideoPlayer(_controllers[index]),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          icon: Icon(Icons.play_arrow),
                                          onPressed: (() {
                                            _controllers[index].value.isPlaying
                                                ? _controllers[index].pause()
                                                : _controllers[index].play();
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Scaffold(
                // if don't have videos files in firebase
                appBar: ApplicationAppbar(
                  title: "Backup Your Phone",
                  iconButton: IconButton(
                      onPressed: () {
                        selectFile(context);
                      },
                      icon: const Icon(Icons.video_camera_back_outlined)),
                ),
                floatingActionButton: const ApplicationFloatingActionButton(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: const ApplicationButtonbar(),
                body: const Center(
                  child: CircularProgressIndicator(),
                ));
          }
        });
  }

  buildVideos() async {
    for (var element in videos) {
      _controllers.add(getNewController(element));
    }
  }
}

Future selectFile(BuildContext context) async {
  // pick file from phone storage (allow just videos files)
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.video,
  );

  if (result == null) {
    ToastMassageShort(msg: "Please pick a video");
    return;
  }
  uploadFiles(context, result.files);
}

Future uploadFiles(BuildContext context, List<PlatformFile> files) async {
  // upload the picked videos to firebase
  final user = FirebaseAuth.instance.currentUser;

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()));
  for (var element in files) {
    final file = File(element.path!);
    final path = "${user!.uid}/videos/${element.name}";

    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      await ref.putFile(file);
    } catch (err) {
      ToastMassageLong(msg: err.toString());
    }
  }
  Navigator.of(context).pop(context);
}

Future<bool> getFirebaseVideosFolder() async {
  // refresh the list to show the updated list
  final user = FirebaseAuth.instance.currentUser;

  videos.clear();
  String url;
  final storageRef =
      FirebaseStorage.instance.ref().child(user!.uid).child('videos');
  final result = await storageRef.listAll();
  for (var element in result.items) {
    url = await element.getDownloadURL();
    videos.add(url);
  }
  return videos.isEmpty ? false : true;
}
