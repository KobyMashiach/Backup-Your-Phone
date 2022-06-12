// ignore_for_file: avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:backup_your_phone/appAndButtonBars/application_appbar.dart';
import 'package:backup_your_phone/appAndButtonBars/application_buttombar.dart';
import 'package:backup_your_phone/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

// final path = "${user!.uid}/videos/";
// final ref = FirebaseStorage.instance.ref().child(path);

// list of all videos pathes
List<String> videos = [];

// view videos page
class VideosPage extends StatefulWidget {
  const VideosPage({Key? key}) : super(key: key);
  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ApplicationAppbar(
          title: "Backup Your Phone",
          iconButton: IconButton(
              onPressed: () async {
                selectFile(context);
              },
              icon: const Icon(Icons.videocam)),
        ),
        floatingActionButton: const ApplicationFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const ApplicationButtonbar(),
        body: const Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 60),
          child: LoadVideos(),
        ));
  }
}

class LoadVideos extends StatefulWidget {
  const LoadVideos({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadVideos> createState() => _LoadVideosState();
}

class _LoadVideosState extends State<LoadVideos> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = getNewController();
  }

  String getVideoPath() {
    return 'https://firebasestorage.googleapis.com/v0/b/backupyourphone-aa039.appspot.com/o/VEYPtZYrphfu6qlv1qfSLAMt3I02%2Fvideos%2FVID-20210506-WA0004.mp4?alt=media&token=071ef3dc-a7f9-4e86-8c2d-443402e2ed74';
  }

  VideoPlayerController getNewController() {
    return VideoPlayerController.network(getVideoPath())
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  void updateVideos() {
    setState(() async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));
      try {
        videos = await getFirebaseVideoFolder();
      } catch (err) {
        ToastMassageLong(msg: err.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
            // child: Image.network(
            //   videos[index],
            //   fit: BoxFit.fill,
            //   loadingBuilder: (BuildContext context,
            //       Widget child, // circular until loading
            //       ImageChunkEvent? loadingProgress) {
            //     if (loadingProgress == null) return child;
            //     return Center(
            //       child: CircularProgressIndicator(
            //         backgroundColor: Colors.white,
            //         value: loadingProgress.expectedTotalBytes != null
            //             ? loadingProgress.cumulativeBytesLoaded /
            //                 loadingProgress.expectedTotalBytes!
            //             : null,
            //       ),
            //     );
            //   },
            // ),
            child: _controller.value.isInitialized
                ? InkWell(
                    onTap: () {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_controller),
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
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

// Future selectDirectory() async {
//   String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

//   if (selectedDirectory == null) {
//     ToastMassageShort(msg: "Please pick a folder");
//     return;
//   }
//   ToastMassageShort(msg: selectedDirectory);
//   var file = File(selectedDirectory);
//   return Image.file(file);
// }

Future selectFile(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(allowMultiple: true, type: FileType.video);

  if (result == null) {
    // List<File> files = result.paths.map((path) => File(path!)).toList();
    ToastMassageShort(msg: "Please pick a image");
    videos = await getFirebaseVideoFolder();

    return;
  }
  uploadFiles(context, result.files);
  // openFile(file);
}

void openFile(PlatformFile file) {
  OpenFile.open(file.path);
}

Future uploadFile(BuildContext context, PlatformFile files) async {
  final user = FirebaseAuth.instance.currentUser;

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()));
  final file = File(files.path!);
  final path = "${user!.uid}/videos/${files.name}";

  final ref = FirebaseStorage.instance.ref().child(path);

  try {
    await ref.putFile(file);
    String fileUrl = await ref.getDownloadURL();
    videos.add(fileUrl);

    // await folderRef.delete();
    Navigator.of(context).pop(context);
    getFirebaseVideoFolder();
  } catch (err) {
    ToastMassageLong(msg: err.toString());
    Navigator.of(context).pop(context);
  }
}

Future uploadFiles(BuildContext context, List<PlatformFile> files) async {
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
      String fileUrl = await ref.getDownloadURL();
      videos.add(fileUrl);
      getFirebaseVideoFolder();
    } catch (err) {
      ToastMassageLong(msg: err.toString());
    }
  }
  Navigator.of(context).pop(context);
}

Future<List<String>> getFirebaseVideoFolder() async {
  final user = FirebaseAuth.instance.currentUser;

  List<String> _result = [];
  String url;
  final Reference storageRef =
      FirebaseStorage.instance.ref().child(user!.uid).child('videos');
  storageRef.listAll().then((result) async {
    for (var element in result.items) {
      url = await element.getDownloadURL();
      _result.add(url);
    }
  });
  return _result;
}
