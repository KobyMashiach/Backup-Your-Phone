// ignore_for_file: avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
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

  //-------------------TEST---------------------------
  VideoPlayerController getNewController(String path) {
    return VideoPlayerController.network(path)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  //-------------------TEST---------------------------

  @override
  Widget build(BuildContext context) {
    _controllers.add(getNewController(
        'https://firebasestorage.googleapis.com/v0/b/backupyourphone-aa039.appspot.com/o/EYjeDysmhKV3lWmQuPbmgbwhE6Y2%2Fvideos%2FVID-20220609-WA0001.mp4?alt=media&token=d083ed41-67a4-41f9-8f61-5d28c68fedb1'));
    _controllers.add(getNewController(
        'https://firebasestorage.googleapis.com/v0/b/backupyourphone-aa039.appspot.com/o/EYjeDysmhKV3lWmQuPbmgbwhE6Y2%2Fvideos%2FVID-20220611-WA0000.mp4?alt=media&token=65f46efb-b87b-4ee1-a2b1-b6c67c6f347a'));
    return FutureBuilder<bool>(
        future:
            getFirebaseVideosFolder(), // check if have videos files on firebase => if not view loading
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
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
                          // Navigator.push<void>(
                          //   context,
                          //   MaterialPageRoute<void>(
                          //     builder: (BuildContext context) =>
                          //         ShowPdfFullScreen(
                          //       // open new page to show the pdf in full screen
                          //       pdfPath: images[index],
                          //     ),
                          //   ),
                          // );
                        },
                        child: _controllers[index].value.isInitialized
                            ? InkWell(
                                onTap: () {
                                  _controllers[index].value.isPlaying
                                      ? _controllers[index].pause()
                                      : _controllers[index].play();
                                },
                                child: AspectRatio(
                                  aspectRatio:
                                      _controllers[index].value.aspectRatio,
                                  child: Stack(
                                    children: [
                                      VideoPlayer(_controllers[index]),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.play_arrow, shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            blurRadius: 10,
                                          )
                                        ]),
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
